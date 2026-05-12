import 'dart:math';

import 'package:icreat_dct/0_data/model/type/crf_input_type.dart';
import 'package:icreat_dct/0_data/model/type/crf_data_type.dart';
import 'package:icreat_dct/0_data/dto/crf/crf_validation_editcheck.dart';
import 'package:icreat_dct/0_data/dto/crf/crf_validation_query.dart';

import 'form_validator_runner.dart';

class NumberParts {
  int integerPart = 0;
  int fractionalPart = 0;
  bool isNegative = false;
  bool isOk = false;

  // '1', '0', '3.14', '-5', '-3.14'
  NumberParts(String numberString) {
    double? number = double.tryParse(numberString);
    if (number == null) {
      return;
    }

    integerPart = number.toInt();
    String frac = (number - integerPart)
        .toStringAsFixed(10) // fixed sufficient size
        .substring(2) // remove "0."
        .replaceAll(RegExp(r'0*$'), ''); // remove trailing 0's

    fractionalPart = frac.isEmpty ? 0 : int.parse(frac);

    isOk = true;

    if (integerPart < 0) {
      isNegative = true;
      integerPart = integerPart.abs();
    }
  }
}

class EnOrDisItemList {
  List<String> enabled = [];
  List<String> disabled = [];

  bool get hasChangedItem => (enabled.isNotEmpty || disabled.isNotEmpty);
}

class FormValidator {
  final List<ValidationEditCheck> _editCheckList = [];
  final Map<String, String> _reservedMap = {}; // keyword, value

  bool isMandatory(String itemUid) {
    return _editCheckList.any((el) => el.itemUid == itemUid && el.type == ValidationType.Error && el.isMandatory);
  }

  void setCheckList(List<ValidationEditCheck> checkList) {
    _editCheckList.clear();
    _editCheckList.addAll(checkList);
  }

  void setReservedMap(Map<String, String> reservedMap) {
    _reservedMap.clear();
    _reservedMap.addAll(reservedMap);
  }

  void updateReservedMap(String reservedWord, String value) {
    _reservedMap[reservedWord] = value;
  }

  List<String> getDefaultDisabledItemList() {

    List<String> disabledList = [];

    for (var check in _editCheckList) {
      if (check.type == ValidationType.Enabled) { // condition to be enabled
        disabledList.addAll(check.affectedItemUidList);
      }
    }

    return disabledList;

  }

  bool isValidItemLength(String userInput, CrfDataType valueType, String? itemLength) {

    //Logger.debug("userInput=$userInput, valueType=$valueType, itemLength=$itemLength");

    if (itemLength == null) {
      return true;
    }

    // parsing itemLength

    final itemLen = NumberParts(itemLength);
    if (!itemLen.isOk) {
      return true;
    }

    if (itemLen.integerPart == 0 && itemLen.fractionalPart == 0) {
      return true;
    }

    if (valueType == CrfDataType.string || valueType == CrfDataType.text) {
      if (userInput.length != itemLen.integerPart) {
        return false;
      }
    }

    if (valueType == CrfDataType.float || valueType == CrfDataType.integer) {
      final v = NumberParts(userInput);
      if (!v.isOk) {
        return false;
      }

      if (itemLen.isNegative != v.isNegative) { // different sign
        return false;
      }

      // check integer part
      if (itemLen.integerPart > 0) {
        if (v.integerPart >= pow(10, itemLen.integerPart)) { // pow(10,0) = 1
          return false;
        }
      }

      // check fractional part
      // TODO: confirm exact meaning of fractional part
      if (itemLen.fractionalPart > 0) {
        if (!(pow(10, itemLen.fractionalPart - 1) <= v.fractionalPart &&
            v.fractionalPart < pow(10, itemLen.fractionalPart))) {
          return false;
        }
      }
    }

    return true;
  }

  String? checkWarning({
    required String itemUid,
    required String input,
    required CrfDataType dataType,
    required CrfInputType inputType,
    Map<String, String>? inputMap,
  }) {

    //Logger.debug("itemUid = $itemUid, userInput = $userInput, valueType = $valueType, inputType = $inputType");

    String? warningMessage;

    for (var check in _editCheckList) {
      if (check.itemUid != itemUid) {
        continue;
      }

      if (check.type == ValidationType.Warning) {
        for (var query in check.queryList) {
          if (ValidationQueryRunner.runQuery(
            query: query,
            itemUid: itemUid,
            input: input,
            dataType: dataType,
            inputType: inputType,
            inputMap: inputMap,
            reservedMap: _reservedMap,
          )) {
            warningMessage = check.msgOnFailure;
            break;
          }
        }
      }
    }

    return warningMessage;
  }

  String? checkQuery({
    required String itemUid,
    required String input,
    required CrfDataType dataType,
    required CrfInputType inputType,
    Map<String, String>? inputMap,
  }) {

    //Logger.debug("itemUid = $itemUid, userInput = $userInput, valueType = $valueType, inputType = $inputType");

    String? queryMessage;

    for (var check in _editCheckList) {
      if (check.itemUid != itemUid || check.type != ValidationType.Query) {
        continue;
      }

      for (var query in check.queryList) {
        if (ValidationQueryRunner.runQuery(
            query: query,
            itemUid: itemUid,
            input: input,
            dataType: dataType,
            inputType: inputType,
            inputMap: inputMap,
            reservedMap: _reservedMap,
        )) {
          queryMessage = check.msgOnFailure;
          break;
        }
      }
    }

    return queryMessage;
  }

  EnOrDisItemList checkEnable({
    required String itemUid,
    required String input,
    required CrfDataType dataType,
    required CrfInputType inputType,
    Map<String, String>? inputMap,
  }) {

    var res = EnOrDisItemList();

    for (var check in _editCheckList) {
      //Logger.debug("check = ${check.itemUid}, ${check.affectedItemUidList}");
      if (check.itemUid != itemUid || !(check.type == ValidationType.Enabled || check.type == ValidationType.Disabled)) {
        continue;
      }

      var queryRes = true;
      for (var query in check.queryList) {
        var qResult = ValidationQueryRunner.runQuery(
          query: query,
          itemUid: itemUid,
          input: input,
          dataType: dataType,
          inputType: inputType,
          inputMap: inputMap,
          reservedMap: _reservedMap,
        );
        queryRes &= qResult;
      }

      if (check.type == ValidationType.Enabled) {
        if (queryRes) {
          res.enabled.addAll(check.affectedItemUidList);
        } else {
          res.disabled.addAll(check.affectedItemUidList);
        }
      } else {
        if (queryRes) {
          res.disabled.addAll(check.affectedItemUidList);
        } else {
          res.enabled.addAll(check.affectedItemUidList);
        }
      }

    }

    return res;
  }

  (bool, String?) checkError({
    required String itemUid,
    required String input,
    required CrfDataType dataType,
    required CrfInputType inputType,
    Map<String, String>? inputMap,
  }) {

    //Logger.debug("itemUid = $itemUid, userInput = $userInput, valueType = $valueType, inputType = $inputType");

    bool hasError = false;
    String? msgOnError;

    for (var check in _editCheckList) {
      //Logger.debug("check = ${check.itemUid}, ${check.affectedItemUidList}");
      if (check.itemUid != itemUid || check.type != ValidationType.Error) {
        continue;
      }

      // check mandatory
      if (check.isMandatory && input.isEmpty) {
        hasError = true;
      }

      // check min-max
      if(!hasError && !ValidationQueryRunner.isValidMinMax(input, dataType, check.min, check.max)) {
        hasError = true;
      }

      // check prerequisite
      if (!hasError && check.prerequisite) {
        for (var query in check.queryList) {
          if(!ValidationQueryRunner.runQuery(
            query: query,
            itemUid: itemUid,
            input: input,
            dataType: dataType,
            inputType: inputType,
            inputMap: inputMap,
            reservedMap: _reservedMap,
          )) {
            hasError = true;
            break;
          }
        }
      }

      if (hasError) {
        msgOnError = check.msgOnFailure;
        break;
      }
    }

    return (hasError, msgOnError);
  }

}