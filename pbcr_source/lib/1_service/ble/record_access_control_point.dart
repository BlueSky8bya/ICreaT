import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:icreat_dct/1_service/ble/bluetooth_characteristic.dart';

class RecordAccessControlPoint {
  RecordAccessControlPoint(this.characteristic);
  final BluetoothCharacteristic characteristic;

  static const int opCodeFetchRecords = 0x01;
  static const int opCodeFetchRecordsCount = 0x04;
  static const int opCodeFetchRecordCountRes = 0x05;
  static const int opCodeResponseCode = 0x06;
  static const int opCodeFetchLatestSeqNum = 0x10;
  static const int opCodeFetchLatestSeqNumRes = 0x11;

  static const int operatorNull = 0x00;
  static const int operatorAllRecords = 0x01;
  static const int operatorGreaterThanOrEqualTo = 0x03;

  static const int filterTypeSeqNum = 0x01;

  static const int resCodeSuccess = 0x01;

  static const _writeDuration = Duration(milliseconds: 200);
  static Future<void> delayWrite() => Future.delayed(_writeDuration);

  Future<void> fetchRecordsCount() async {
    await delayWrite();
    await characteristic.writeWithLog(
      data: [opCodeFetchRecordsCount, operatorAllRecords],
      logTitle: 'fetch record count',
    );
  }

  Future<void> fetchRecords({required List<int> seqNumBytes}) async {
    await delayWrite();
    await characteristic.writeWithLog(
      data: [
        opCodeFetchRecords,
        operatorGreaterThanOrEqualTo,
        filterTypeSeqNum,
        ...seqNumBytes,
      ],
      logTitle: 'fetch records',
    );
  }

  Future<void> fetchLatestSeqNum() async {
    await delayWrite();
    await characteristic.writeWithLog(
      data: [opCodeFetchLatestSeqNum, operatorNull],
      logTitle: 'fetch latest seqNum',
    );
  }
}
