import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:icreat_dct/6_util/logger.dart';
import 'package:icreat_dct/8_extension/int_list_ext.dart';

extension BluetoothCharactExt on BluetoothCharacteristic {
  Future<void> writeWithLog({
    required List<int> data,
    required String logTitle,
  }) async {
    Logger.info('write $logTitle : ${data.toHexStringList()}', tag: 'ble');
    await write(data);
    Logger.info('completed write $logTitle', tag: 'ble');
  }
}
