import 'package:icreat_dct/8_extension/string_ext.dart';
import 'package:type_caster/type_caster.dart';

import 'package:icreat_dct/0_data/model/type/crf_data_type.dart';
import 'package:icreat_dct/0_data/model/type/crf_input_type.dart';
import 'package:icreat_dct/0_data/dto/crf/crf_validation_query.dart';
import 'package:icreat_dct/6_util/logger.dart';

class ValidationQueryRunner {
  ValidationQueryRunner();

  static bool isEmpty(String value) {
    return value.isEmpty;
  }

  static bool isNotEmpty(String value) {
    return value.isNotEmpty;
  }

  static bool isEqual(String value, String baseValue) {
    return value == baseValue;
  }

  static bool isNotEqual(String value, String baseValue) {
    return value != baseValue;
  }

  static bool isGreaterThanEqual(String value, CrfDataType valueType, String baseValue) {
    if (baseValue.isNotEmpty) {
      switch (valueType) {
        case CrfDataType.string:
        case CrfDataType.text:
          int? minInt = tryInt(baseValue);
          if (minInt == null || value.length < minInt) {
            return false;
          }
        case CrfDataType.integer:
          int? minInt = tryInt(baseValue);
          int? userInputAsInt = tryInt(value);
          if (minInt == null || userInputAsInt == null || userInputAsInt < minInt) {
            return false;
          }
        case CrfDataType.float:
          double? minDouble = tryDouble(baseValue);
          double? userInputAsDouble = tryDouble(value);
          if (userInputAsDouble == null || minDouble == null || userInputAsDouble < minDouble) {
            return false;
          }
        default:
        // do nothing
      }
    }

    return true;
  }

  static bool isLessThanEqual(String value, CrfDataType valueType, String baseValue) {
    if (baseValue.isNotEmpty) {
      switch (valueType) {
        case CrfDataType.string:
        case CrfDataType.text:
          int? maxInt = tryInt(baseValue);
          if (maxInt == null || value.length > maxInt) {
            return false;
          }
        case CrfDataType.integer:
          int? maxInt = tryInt(baseValue);
          int? userInputAsInt = tryInt(value);
          if (maxInt == null || userInputAsInt == null || userInputAsInt > maxInt) {
            return false;
          }
        case CrfDataType.float:
          double? maxDouble = tryDouble(baseValue);
          double? userInputAsDouble = tryDouble(value);
          if (userInputAsDouble == null || maxDouble == null || userInputAsDouble > maxDouble) {
            return false;
          }
        default:
        // do nothing
      }
    }

    return true;
  }

  static bool isGreaterThan(String value, CrfDataType valueType, String baseValue) {
    if (baseValue.isNotEmpty) {
      switch (valueType) {
        case CrfDataType.string:
        case CrfDataType.text:
          int? minInt = tryInt(baseValue);
          if (minInt == null || value.length <= minInt) {
            return false;
          }
        case CrfDataType.integer:
          int? minInt = tryInt(baseValue);
          int? userInputAsInt = tryInt(value);
          if (minInt == null || userInputAsInt == null || userInputAsInt <= minInt) {
            return false;
          }
        case CrfDataType.float:
          double? minDouble = tryDouble(baseValue);
          double? userInputAsDouble = tryDouble(value);
          if (userInputAsDouble == null || minDouble == null || userInputAsDouble <= minDouble) {
            return false;
          }
        default:
        // do nothing
      }
    }
    return true;
  }

  static bool isLessThan(String value, CrfDataType valueType, String baseValue) {
    if (baseValue.isNotEmpty) {
      switch (valueType) {
        case CrfDataType.string:
        case CrfDataType.text:
          int? maxInt = tryInt(baseValue);
          if (maxInt == null || value.length >= maxInt) {
            return false;
          }
        case CrfDataType.integer:
          int? maxInt = tryInt(baseValue);
          int? userInputAsInt = tryInt(value);
          if (userInputAsInt == null || maxInt == null ||
              userInputAsInt >= maxInt) {
            return false;
          }
        case CrfDataType.float:
          double? maxDouble = tryDouble(baseValue);
          double? userInputAsDouble = tryDouble(value);
          if (userInputAsDouble == null || maxDouble == null ||
              userInputAsDouble >= maxDouble) {
            return false;
          }
        default:
        // do nothing
      }
    }

    return true;
  }

  static bool isBetween(String value, CrfDataType valueType, String begin, String end) {
    return isGreaterThanEqual(value, valueType, begin) && isLessThanEqual(value, valueType, end);
  }

  static bool isNotBetween(String value, CrfDataType valueType, String begin, String end) {
    return !isBetween(value, valueType, begin,end);
  }

  static bool isLike(String value, String baseValue) {
    return baseValue.contains(value);
  }

  static bool isValidMinMax(String userInput, CrfDataType dataType, String min, String max) {
    return isBetween(userInput, dataType, min, max);
  }

  static bool isIn(String userInput, String baseValue) {
    return baseValue.asList<String>().contains(userInput);
  }

  static bool isNotIn(String userInput, String baseValue) {
    return !isIn(userInput, baseValue);
  }

  static bool runQuery({
    required ValidationQuery query,
    required String itemUid,
    required String input,
    required CrfDataType dataType,
    required CrfInputType inputType,
    Map<String, String>? inputMap, // item_uid, input_value
    Map<String, String>? reservedMap, // keyword, value
  }) {

    // 1. get value from left

    QueryOperandType leftType = query.leftType;
    String? lValue;

    if (query.leftType == QueryOperandType.I) {
      if (query.leftValue1 == ':0' || query.leftValue1.isEmpty) {
        leftType = QueryOperandType.V;
      }
    }

    if (leftType == QueryOperandType.I) {
      if (query.leftValue2 == itemUid) { // self-input
        lValue = input;
      } else {
        if (inputMap != null && inputMap.containsKey(query.leftValue2)) {
          lValue = inputMap[query.leftValue2]; // other-input
        }
      }
    } else if (leftType == QueryOperandType.V) {
      lValue = query.leftValue1;
      if (query.leftValue1 == ':0' || query.leftValue1.isEmpty) {
        lValue = query.leftValue2;
      }

      if (reservedMap != null && reservedMap.containsKey(lValue)){
        lValue = reservedMap[lValue];
      }
    }

    // 2. get baseValue from right

    QueryOperandType rightType = query.rightType;
    String? bValue;
    String? eValue;

    if (query.rightType == QueryOperandType.I) {
      if (query.rightValue1 == ':0' || query.rightValue1.isEmpty) {
        rightType = QueryOperandType.V;
      }
    }

    if (rightType == QueryOperandType.I) {
      if (query.rightValue2 == itemUid) { // self-input
        bValue = input;
      } else {
        if (inputMap != null && inputMap.containsKey(query.rightValue2)) {
          bValue = inputMap[query.rightValue2]; // other-input
        }
      }
    } else if (rightType == QueryOperandType.V) {
      bValue = query.rightValue1;
      if (query.rightValue1 == ':0' || query.rightValue1.isEmpty) {
        bValue = query.rightValue2;
      }

      eValue = query.rightValue2;

      if (reservedMap != null && reservedMap.containsKey(bValue)){
        bValue = reservedMap[bValue];
      }

      if (reservedMap != null && reservedMap.containsKey(eValue)){
        eValue = reservedMap[eValue];
      }
    }

    //Logger.debug("lValue = $lValue, bValue = $bValue, eValue = $eValue, op = ${query.operator}");

    // 3. process

    if (lValue == null) {
      return true;
    }

    String sValue = lValue.toString();

    switch(query.operator) {
      case QueryOperator.IsEmpty:
        return isEmpty(sValue);
      case QueryOperator.IsNotEmpty:
        return isNotEmpty(sValue);
      case QueryOperator.In:
        if (bValue.isNullOrEmpty) {
          return true;
        }
        return isIn(sValue, bValue.toString());
      case QueryOperator.NotIn:
        if (bValue.isNullOrEmpty) {
          return true;
        }
        return isNotIn(sValue, bValue.toString());
      case QueryOperator.LT:
        if (bValue.isNullOrEmpty) {
          return true;
        }
        return isLessThan(sValue, dataType, bValue.toString());
      case QueryOperator.LTE:
        if (bValue.isNullOrEmpty) {
          return true;
        }
        return isLessThanEqual(sValue, dataType, bValue.toString());
      case QueryOperator.GT:
        if (bValue.isNullOrEmpty) {
          return true;
        }
        return isGreaterThan(sValue, dataType, bValue.toString());
      case QueryOperator.GTE:
        if (bValue.isNullOrEmpty) {
          return true;
        }
        return isGreaterThanEqual(sValue, dataType, bValue.toString());
      case QueryOperator.Equals:
        if (bValue == null) {
          return true;
        }
        return isEqual(sValue, bValue.toString());
      case QueryOperator.NotEquals:
        if (bValue == null) {
          return true;
        }
        return isNotEqual(sValue, bValue.toString());
      case QueryOperator.Between:
        if (bValue.isNullOrEmpty || eValue.isNullOrEmpty) {
          return true;
        }
        return isBetween(sValue, dataType, bValue.toString(), eValue.toString());
      case QueryOperator.NotBetween:
        if (bValue.isNullOrEmpty || eValue.isNullOrEmpty) {
          return true;
        }
        return isNotBetween(sValue, dataType, bValue.toString(), eValue.toString());
      case QueryOperator.Like:
        if (sValue.isEmpty && bValue.isNullOrEmpty) {
          return true;
        }
        return isLike(sValue, bValue.toString());
      default:
        return true;
    }
  }
}

