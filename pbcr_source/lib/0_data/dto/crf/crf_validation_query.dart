// ignore_for_file: constant_identifier_names

import 'package:g_json/g_json.dart';

enum QueryOperator {
  Unknown('Unknown'),
  IsEmpty('IsEmpty'),
  IsNotEmpty('IsNotEmpty'),
  In('In'),
  NotIn('NotIn'),
  LT('<'),
  LTE('<='),
  GT('>'),
  GTE('>='),
  Equals('='),
  NotEquals('<>'),
  Between('Between'),
  NotBetween('NotBetween'),
  Like('Like'),
  DateLT('DateLT'),
  DateGT('DateGT'),
  YearLT('YearLT'),
  YearGT('YearGT');

  final String value;
  const QueryOperator(this.value);

  static QueryOperator fromString(String value) {
    var v = value.replaceAll(' ', '').toLowerCase();
    return QueryOperator.values.firstWhere(
          (el) => el.value.toLowerCase() == v,
      orElse: () => QueryOperator.Unknown,
    );
  }
}

enum ValidationType {
  Unknown('Unknown'),
  Error('Error'),
  Query('Query'),
  Warning('Warning'),
  Enabled('Enabled'),     // control event
  Disabled('Disabled');   // control event

  final String value;
  const ValidationType(this.value);

  static ValidationType fromString(String value) {
    var v = value.toLowerCase();
    return ValidationType.values.firstWhere(
          (el) => el.value.toLowerCase() == v,
      orElse: () => ValidationType.Unknown,
    );
  }
}

enum QueryOperandType {
  I('I'), // input value from form
  V('V'), // value
  M('M'); // ??

  final String value;
  const QueryOperandType(this.value);

  static QueryOperandType fromString(String value) {
    var v = value.toUpperCase();
    return QueryOperandType.values.firstWhere(
          (el) => el.value == v,
      orElse: () => QueryOperandType.V,
    );
  }
}

class ValidationQuery {
  final String conditionSeq;
  final QueryOperator operator;
  final QueryOperandType leftType;
  final String leftValue1;
  final String leftValue2; // leftType = I, leftValue2 = itemUid
  final QueryOperandType rightType;
  final String rightValue1;
  final String rightValue2; // rightType = I, rightValue2 = itemUid

  ValidationQuery({
    required this.conditionSeq,
    required this.operator,
    required this.leftType,
    required this.leftValue1,
    required this.leftValue2,
    required this.rightType,
    required this.rightValue1,
    required this.rightValue2,
  });

  factory ValidationQuery.fromJSON(JSON json) {
    return ValidationQuery(
      conditionSeq: json["condition_seq"].stringValue,
      operator: QueryOperator.fromString(json["op"].stringValue),
      leftType: QueryOperandType.fromString(json["left"]["type"].stringValue),
      leftValue1: json["left"]["value1"].stringValue,
      leftValue2: json["left"]["value2"].stringValue,
      rightType: QueryOperandType.fromString(json["right"]["type"].stringValue),
      rightValue1: json["right"]["value1"].stringValue,
      rightValue2: json["right"]["value2"].stringValue,
    );
  }
}
