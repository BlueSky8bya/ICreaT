import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:icreat_dct/1_service/ble/ble_callback.dart';
import 'package:icreat_dct/0_data/model/ble/ble_types.dart';
import 'package:icreat_dct/6_util/device_info.dart';
import 'package:icreat_dct/6_util/logger.dart';
import 'package:icreat_dct/8_extension/int_list_ext.dart';
import 'package:synchronized/synchronized.dart';


abstract class BleDeviceService {
  static const _writeDuration = Duration(milliseconds: 200);
  static Future<void> delayWrite() => Future.delayed(_writeDuration);

  static bool _needToInit = true;
  static Future<void> init() async {
    if (DeviceInfo.isIOS && _needToInit) {
      _needToInit = false;
      Logger.debug('ble init');
      await FlutterBluePlus.isSupported;
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  BleCallback? callback;
  BluetoothConnectionState _state = BluetoothConnectionState.disconnected;
  final _scanResultLock = Lock();

  BluetoothDevice? selectedDevice;
  List<BluetoothService>? _services;
  StreamSubscription? _scanSubscription;
  StreamSubscription? _stateSubscription;
  bool _firstStateSubscription = true;
  final Set<String> _printCompleteDeviceList = {};

  Future<void> startConnect() async {
    _startScanSubscription();

    FlutterBluePlus.startScan();
  }

  void _startScanSubscription() {
    _printCompleteDeviceList.clear();
    _scanSubscription?.cancel();
    _scanSubscription = FlutterBluePlus.scanResults.listen(
      (scanResultList) async {
        scanResultList = scanResultList
            // .where(
            //   (scanResult) => scanResult.device. == BluetoothDeviceType.le,
            // )
            .toList();
        _logScanResult(scanResultList);

        await _scanResultLock.synchronized(() async {
          if (_state == BluetoothConnectionState.disconnected) {
            for (ScanResult scanResult in scanResultList) {
              await _processScanResult(scanResult);
            }
          }
        });
      },
    );
  }

  void _logScanResult(List<ScanResult> scanResultList) {
    for (var scanResult in scanResultList) {
      final id = scanResult.device.remoteId.str;
      if (!_printCompleteDeviceList.contains(id)) {
        _printCompleteDeviceList.add(id);
        Logger.debug(scanResult.toString());
      }
    }
  }

  Future<void> _processScanResult(ScanResult scanResult) async {
    if (scanFilter(scanResult)) {
      Logger.debug('device = ${scanResult.device}');
      await _stopScan();
      await _connect(scanResult.device);
    }
  }

  Future<void> _connect(BluetoothDevice device) async {
    selectedDevice = device;
    Logger.info('selected device = $device', tag: 'ble');
    _startStateSubscription();

    Logger.info('start device.connect()');
    try {
      await device.connect(timeout: const Duration(seconds: 15));
    } catch (e) {
      return;
    }

    Logger.info('start device.discoverServices()');
    _services = await device.discoverServices();

    Logger.info('completed connect!');
    _setState(BluetoothConnectionState.connected);
  }

  void _startStateSubscription() {
    _stateSubscription?.cancel();
    _firstStateSubscription = true;

    _stateSubscription = selectedDevice?.connectionState.listen((state) {
      Logger.debug(
          '[subscription] state = $state, _firstStateSubscription = $_firstStateSubscription');
      if (_firstStateSubscription) {
        _firstStateSubscription = false;
        return;
      }
      if (state == BluetoothConnectionState.disconnected) {
        processOnDisconnected();
        dispose();
      }
    });
  }

  void _setState(BluetoothConnectionState state) {
    _state = state;
    callback?.onChangeState?.call(state);
  }

  Future<void> listenCharact({
    BluetoothCharacteristic? characteristic,
    BleServiceType? serviceType,
    CharactType? charactType,
    required Function(StreamSubscription?) setSubscription,
    required Function(List<int>) onListen,
  }) async {
    final charact = characteristic ?? getCharact(serviceType!, charactType!);
    await charact?.setNotifyValue(true);

    setSubscription(charact?.lastValueStream.listen(onListen));
  }

  BluetoothCharacteristic? getCharact(
    BleServiceType serviceType,
    CharactType charactType,
  ) {
    return _services
        ?.getFromUUID(serviceType.uuid)
        ?.characteristics
        .getFromUUID(charactType.uuid);
  }

  Future<void> dispose() async {
    Logger.info('dispose()....!');
    await _stopScan();
    await disconnect();
  }

  Future<void> _stopScan() async {
    Logger.info('stopScan()....!');
    await _scanSubscription?.cancel();
    _scanSubscription = null;
    await FlutterBluePlus.stopScan();
  }

  Future<void> disconnect() async {
    Logger.info('disconnect()....!');
    _setState(BluetoothConnectionState.disconnected);
    await _stateSubscription?.cancel();
    _stateSubscription = null;
    await selectedDevice?.disconnect();
    selectedDevice = null;
  }

  List<Guid> get scanWithSerices;
  bool scanFilter(ScanResult scanResult);
  Future<void> readyToGetData();
  void processOnDisconnected();
}


extension BluetoothDeviceStateExt on BluetoothConnectionState {
  bool get isDisconnected => this == BluetoothConnectionState.disconnected;
  bool get isConnected => this == BluetoothConnectionState.connected;
}

extension _ListBluetoothServiceExt on List<BluetoothService> {
  BluetoothService? getFromUUID(Guid uuid) =>
      firstWhereOrNull((e) => e.uuid == uuid);
}

extension _ListBluetoothCharacteristicExt on List<BluetoothCharacteristic> {
  BluetoothCharacteristic? getFromUUID(Guid uuid) =>
      firstWhereOrNull((e) => e.uuid == uuid);
}

extension BleDataParser on List<int> {
  DateTime toCurrentTime() {
    return DateTime(
      sublist(0, 2).toIntValue(isLittleEndian: true),
      this[2],
      this[3],
      this[4],
      this[5],
      this[6],
    );
  }

  int? toBatteryValue() {
    if (isNotEmpty == true) {
      return first;
    }
    return null;
  }
}


