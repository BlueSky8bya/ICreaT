// RACP : Record Access Control Point
// UCP : User Control Point

// HBF-222T 옴론 규격 프로토콜
import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:icreat_dct/1_service/ble/ble_callback.dart';
import 'package:icreat_dct/0_data/model/ble/ble_types.dart';
import 'package:icreat_dct/1_service/ble/bluetooth_characteristic.dart';
import 'package:icreat_dct/0_data/model/ble/ble_body_composition_model.dart';
import 'package:icreat_dct/1_service/ble/omron_device_service.dart';
import 'package:icreat_dct/1_service/ble/record_access_control_point.dart';
import 'package:icreat_dct/1_service/ble/user_control_point.dart';
import 'package:icreat_dct/1_service/ble/weight_device_gender.dart';
import 'package:icreat_dct/6_util/logger.dart';
import 'package:icreat_dct/8_extension/int_ext.dart';
import 'package:icreat_dct/8_extension/int_list_ext.dart';
import 'package:icreat_dct/8_extension/string_ext.dart';
import 'package:synchronized/synchronized.dart';

class OmronWeightDeviceService extends OmronDeviceService {
  OmronWeightDeviceService({this.pairedDeviceId});

  String? pairedDeviceId;

  WeightBleCallback? _weightCallback;
  set weightCallback(WeightBleCallback? value) {
    _weightCallback = value;
    callback = value;
  }

  BodyComposition? _bodyComposition;
  DateTime? birth;
  WeigthDeviceGender? gender;
  double? height;

  UserControlPoint? _ucp;
  RecordAccessControlPoint? _racp;

  StreamSubscription? _ucpSubscription;
  StreamSubscription? _racpSubscription;
  StreamSubscription? _measurementSubscription;

  bool isPairing = false;
  bool? isPairingSuccess;
  bool _startProcess = false;

  final _lockForParseMeasurement = Lock();

  final List<int> _measurementData = [];

  int _latestSeqNum = -1;
  int _measurementSeqNum = -2;

  @override
  bool scanFilter(ScanResult scanResult) => pairedDeviceId == null
      ? scanResult.advertisementData.serviceUuids.any(
          (srv) =>
              srv.toString().equalIgnoreCase(
                  BleServiceType.weightScale.uuid.toString()) ||
              srv.toString().equalIgnoreCase(BleServiceType.weightScale.code),
        )
      : scanResult.device.remoteId.str == pairedDeviceId;

  @override
  List<Guid> get scanWithSerices => [BleServiceType.weightScale.uuid];

  @override
  Future<void> readyToGetData() async {
    Logger.info('weight ready to get', tag: 'ble');
    _startProcess = false;

    await _initUCP();
    await _initRACP();
    await listenCurrentTime();
    await _listenUCP(
      onListen: (data) => _onDataUCP(
        data,
        isPairing ? _actionCPForPairing : _actionUCPForMeasurement,
      ),
    );
    await _listenRACP();
    await _listenMeasurement();

    _startProcess = true;
    if (isPairing) {
      await _ucp?.registerUser();
    } else {
      await _ucp?.checkUserAuth();
    }
  }

  Future<void> _initUCP() async {
    final ucpCharact = getCharact(
      BleServiceType.userData,
      UserDataCharactType.userControlPoint(),
    );
    if (ucpCharact != null) {
      _ucp = UserControlPoint(ucpCharact);
    }
  }

  Future<void> _initRACP() async {
    final racpCharact = getCharact(
      BleServiceType.omoronOption,
      OmoronOptionCharactType.recordAccessControlPoint(),
    );
    if (racpCharact != null) {
      _racp = RecordAccessControlPoint(racpCharact);
    }
  }

  Future<void> _listenUCP({
    required Function(List<int>) onListen,
  }) async {
    await listenCharact(
      characteristic: _ucp?.characteristic,
      setSubscription: (value) => _ucpSubscription = value,
      onListen: onListen,
    );
  }

  void _onDataUCP(
    List<int> data,
    void Function(UCPOpCode? reqOpCode, UCPResCode? resCode) action,
  ) async {
    Logger.info(
      'userControlPoint data = ${data.toHexStringList()}',
      tag: 'ble',
    );

    if (!_startProcess) {
      Logger.warn('not yet start process', tag: 'ble');
      return;
    }

    if (_isValidDataForUCP(data)) {
      final reqOpCode = UCPOpCodeExt.parseFromCode(data[1]);
      final resCode = UCPResCodeExt.parseFromCode(data[2]);
      _logUCP(reqOpCode: reqOpCode, resCode: resCode);

      action(reqOpCode, resCode);
    }
  }

  bool _isValidDataForUCP(List<int> data) {
    final result = data.length >= 3 && data[0] == UCPOpCode.response.code;
    if (!result) Logger.warn('ucp data inValid');
    return result;
  }

  void _logUCP({
    required UCPOpCode? reqOpCode,
    required UCPResCode? resCode,
  }) async {
    Logger.info('요청 operation = ${reqOpCode?.text}, 응답 = ${resCode?.text}');
  }

  void _actionCPForPairing(
    UCPOpCode? reqOpCode,
    UCPResCode? resCode,
  ) async {
    switch (resCode) {
      case UCPResCode.success:
        switch (reqOpCode) {
          case UCPOpCode.registerUser:
            await _ucp?.checkUserAuth();
            break;
          case UCPOpCode.deleteUser:
            await _ucp?.registerUser();
            break;
          case UCPOpCode.consent:
            await _setBirth(birth ?? DateTime(1980, 1, 1));
            await _setGender(gender ?? WeigthDeviceGender.male);
            await _setHeight(height ?? 170);
            isPairingSuccess = true;
            await _racp?.fetchLatestSeqNum();
            break;
          default:
            break;
        }
        break;
      case UCPResCode.notAuth:
        isPairingSuccess = false;
        throw '''[체중계 Pairing 오류] 
            auth code 틀려서(유저 등록 안 되어 있는 상태)
            registerUser한 이후에 다시 auth code 체크했는데 틀림
            <다른 서비스에서 등록된 AuthCode가 있음>
            <체중계에서 User Delete 하는 방법 가이드 필요>''';
      default:
        isPairingSuccess = false;
        throw '요청하지 않은 UCP response 도착 : reqOpCode = $reqOpCode, resCode = $resCode';
    }
  }

  void _actionUCPForMeasurement(
    UCPOpCode? reqOpCode,
    UCPResCode? resCode,
  ) async {
    if (resCode?.isSuccess == true) {
      switch (reqOpCode) {
        case UCPOpCode.consent:
          await _racp?.fetchRecordsCount();
          break;
        default:
          break;
      }
    } else {
      throw '체중계에 저장된 인증 값이 다릅니다. <페어링하지 않은 다른 체중계에 연결 시도한 것으로 추정>';
    }
  }

  Future<void> _listenRACP() async {
    await listenCharact(
      characteristic: _racp?.characteristic,
      setSubscription: (value) => _racpSubscription = value,
      onListen: _onDataRecordAccessControlPoint,
    );
  }

  void _onDataRecordAccessControlPoint(List<int> data) async {
    Logger.info(
      'recordAccessControlPoint data = ${data.toHexStringList()}',
      tag: 'ble',
    );
    if (data.isNotEmpty) {
      final opCode = data[0];

      switch (opCode) {
        case RecordAccessControlPoint.opCodeFetchRecordCountRes:
          final recordCount =
              [data[2], data[3]].toIntValue(isLittleEndian: true);
          if (recordCount > 0) {
            final latestSeqNum = _weightCallback?.getLatestSeqNum();

            if (latestSeqNum != null) {
              await _racp?.fetchRecords(
                seqNumBytes: (latestSeqNum == 0 ? 1 : latestSeqNum)
                    .toByteList(2, isLittleEndian: true),
              );
            } else {
              throw '_weightCallback?.getLatestSeqNum() is null';
            }
          } else {
            throw '체중계에 저장된 측정 값이 없습니다.';
          }
          break;
        case RecordAccessControlPoint.opCodeResponseCode:
          final reqOpCode = data[2];
          final resCode = data[3];
          if (resCode == RecordAccessControlPoint.resCodeSuccess) {
            if (reqOpCode == RecordAccessControlPoint.opCodeFetchRecords) {
              await _racp?.fetchLatestSeqNum();
            }
          } else {
            throw 'RACP response code is Fail';
          }
          break;
        case RecordAccessControlPoint.opCodeFetchLatestSeqNumRes:
          _latestSeqNum = [data[2], data[3]].toIntValue(isLittleEndian: true);
          await _weightCallback?.setLatestSeqNum(_latestSeqNum);
          Logger.info('_latestSeqNum = $_latestSeqNum');
          if (_measurementSeqNum == _latestSeqNum) {
            processOnDisconnected();
            disconnect();
          }
          break;
      }
    }
  }

  Future<void> _listenMeasurement() async {
    await listenCharact(
      serviceType: BleServiceType.omoronOption,
      charactType: OmoronOptionCharactType.omronMeasurement(),
      setSubscription: (value) => _measurementSubscription = value,
      onListen: (data) => _lockForParseMeasurement.synchronized(() {
        _onDataMeasurement(data);
      }),
    );
  }

  void _onDataMeasurement(List<int> data) {
    Logger.info(
      'omronMeasurement data = ${data.toHexStringList()}',
      tag: 'ble',
    );

    if (data.isNotEmpty) {
      if (data.length == BodyComposition.measurementOmronProtocol1Length) {
        _measurementData.clear();
        _measurementData.addAll(data);
      } else if (data.length ==
          BodyComposition.measurementOmronProtocol2Length) {
        if (_measurementData.length ==
            BodyComposition.measurementOmronProtocol1Length) {
          _measurementData.addAll(data);
          _bodyComposition =
              BodyComposition.fromBytesOmronProtocol(bytes: _measurementData);
          _measurementSeqNum =
              _measurementData.sublist(3, 5).toIntValue(isLittleEndian: true);
          Logger.info(
            '_measurementSeqNum = $_measurementSeqNum, _bodyComposition = $_bodyComposition',
            tag: 'ble',
          );
        }
      }
    }
  }

  Future<void> _setBirth(DateTime birth) async {
    final dobCharact =
        getCharact(BleServiceType.userData, UserDataCharactType.dateOfBirth());

    await dobCharact?.writeWithLog(
      data: [
        ...birth.year.toByteList(2, isLittleEndian: true),
        birth.month,
        birth.day,
      ],
      logTitle: 'date of birth',
    );
  }

  Future<void> _setGender(WeigthDeviceGender gender) async {
    final genderCharact =
        getCharact(BleServiceType.userData, UserDataCharactType.gender());
    await genderCharact?.writeWithLog(data: [gender.code], logTitle: 'gender');
  }

  Future<void> _setHeight(double height) async {
    final heightCharact =
        getCharact(BleServiceType.userData, UserDataCharactType.height());
    await heightCharact?.writeWithLog(
      data: (height ~/ BodyComposition.heightResoulution)
          .round()
          .toByteList(2, isLittleEndian: true),
      logTitle: 'height',
    );
  }

  @override
  void processOnDisconnected() {
    if (_bodyComposition != null) {
      if (_bodyComposition!.measureTime == zeroTime) {
        _bodyComposition!.measureTime = DateTime.now();
      } else if (timeOffset != null) {
        _bodyComposition!.measureTime =
            _bodyComposition!.measureTime.add(timeOffset!);
      }
      _weightCallback?.onNewBodyComposition?.call(_bodyComposition!);
    }
    if (isPairingSuccess != null) {
      _weightCallback?.onSuccessPairing?.call(
        isPairingSuccess!,
        selectedDevice!.remoteId.str,
      );
    }
  }

  @override
  Future<void> dispose() async {
    await super.dispose();
    weightCallback = null;

    _ucpSubscription?.cancel();
    _ucpSubscription = null;
    _measurementSubscription?.cancel();
    _measurementSubscription = null;
    _racpSubscription?.cancel();
    _racpSubscription = null;
  }
}
