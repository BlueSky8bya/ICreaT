import 'dart:async';

import 'package:icreat_dct/1_service/ble/ble_device_service.dart';
import 'package:icreat_dct/0_data/model/ble/ble_types.dart';
import 'package:icreat_dct/1_service/ble/bluetooth_characteristic.dart';
import 'package:icreat_dct/6_util/device_info.dart';
import 'package:icreat_dct/6_util/logger.dart';
import 'package:icreat_dct/8_extension/int_ext.dart';

abstract class OmronDeviceService extends BleDeviceService {
  StreamSubscription? _timeSubscription;
  Duration? timeOffset;
  final zeroTime = DateTime(0, 0, 0, 0, 0, 0);

  Future<void> listenCurrentTime() {
    _timeSubscription?.cancel();

    return listenCharact(
      serviceType: BleServiceType.time,
      charactType: TimeCharactType.currentTime(),
      setSubscription: (subscription) => _timeSubscription = subscription,
      onListen: _parseCurrentTimeBytes,
    );
  }

  void _parseCurrentTimeBytes(List<int> timeBytes) {
    Logger.info('timeBytes length = ${timeBytes.length}, bytes = $timeBytes');
    if (timeBytes.isNotEmpty) {
      final dateTime = timeBytes.toCurrentTime();
      timeOffset = DateTime.now().difference(dateTime);
      Logger.info('Time = $dateTime, TimeOffset = $timeOffset');
      _processIfTimeNotSet(timeBytes);
    }
  }

  void _processIfTimeNotSet(List<int> timeBytes) {
    if (DeviceInfo.isAndroid && timeBytes.sublist(0, 7).every((e) => e == 0)) {
      _setCurrentTime();
    }
  }

  Future<void> _setCurrentTime() async {
    await BleDeviceService.delayWrite();
    final timeCharact = getCharact(
      BleServiceType.time,
      TimeCharactType.currentTime(),
    );

    await timeCharact?.writeWithLog(
      data: [..._getCurTimeBytes(), 0, 0, 1],
      logTitle: 'set current time',
    );
  }

  List<int> _getCurTimeBytes() {
    final now = DateTime.now();
    return [
      ...now.year.toByteList(2, isLittleEndian: true),
      now.month,
      now.day,
      now.hour,
      now.minute,
      now.second
    ];
  }

  @override
  Future<void> dispose() {
    _timeSubscription?.cancel();
    _timeSubscription = null;
    return super.dispose();
  }
}
