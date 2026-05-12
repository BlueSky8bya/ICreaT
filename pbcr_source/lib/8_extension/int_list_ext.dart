import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:fast_base58/fast_base58.dart';

import 'int_ext.dart';

extension IntListExt on List<int> {
  int toIntValue({bool isLittleEndian = false}) {
    int result = 0;
    forEachIndexed((index, value) {
      value <<= 8 * (isLittleEndian ? index : length - 1 - index);
      result += value;
    });

    return result;
  }

  String toHexString() {
    return map((e) => e.toHexString()).join('');
  }

  List<String> toHexStringList() {
    return map((e) => e.toHexString()).toList();
  }

  List<int> get hashSha256 => sha256.convert(this).bytes;
  String get encodeBase58 => Base58Encode(this);
  String get encodeBase64 => base64.encode(this);
}
