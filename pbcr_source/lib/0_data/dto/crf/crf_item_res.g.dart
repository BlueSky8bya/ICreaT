// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crf_item_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CrfItemRes _$CrfItemResFromJson(Map<String, dynamic> json) => CrfItemRes(
      orderNumber: (json['order_number'] as num?)?.toInt(),
      itemSeq: (json['item_seq'] as num).toInt(),
      itemUid: json['item_uid'] as String,
      itemOid: json['item_oid'] as String,
      itemName: json['item_name'] as String,
      itemNameLabel: json['item_name_label'] as String,
      dataType: $enumDecodeNullable(_$CrfDataTypeEnumMap, json['data_type'],
              unknownValue: CrfDataType.string) ??
          CrfDataType.string,
      inputType: $enumDecode(_$CrfInputTypeEnumMap, json['input_type'],
          unknownValue: CrfInputType.textBox),
      itemgroupRepeatkey: (json['itemgroup_repeatkey'] as num).toInt(),
      itemLength: json['item_length'] as String?,
      orgnItemValue: json['orgn_item_value'] as String?,
      itemValue: json['item_value'] as String?,
      codeList: json['code_list'] as String?,
      measurementUnit: json['measurement_unit'] as String?,
      commentHeader: json['comment_header'] as String?,
      commentBody: json['comment_body'] as String?,
      itemGroupKey: (json['itemgroup_seq'] as num).toInt(),
      itemGroupUid: json['itemgroup_uid'] as String,
      itemGroupOid: json['itemgroup_oid'] as String,
    );

Map<String, dynamic> _$CrfItemResToJson(CrfItemRes instance) =>
    <String, dynamic>{
      'order_number': instance.orderNumber,
      'item_seq': instance.itemSeq,
      'item_uid': instance.itemUid,
      'item_oid': instance.itemOid,
      'item_name': instance.itemName,
      'item_name_label': instance.itemNameLabel,
      'data_type': _$CrfDataTypeEnumMap[instance.dataType]!,
      'input_type': _$CrfInputTypeEnumMap[instance.inputType]!,
      'orgn_item_value': instance.orgnItemValue,
      'item_value': instance.itemValue,
      'code_list': instance.codeList,
      'measurement_unit': instance.measurementUnit,
      'item_length': instance.itemLength,
      'comment_header': instance.commentHeader,
      'comment_body': instance.commentBody,
      'itemgroup_seq': instance.itemGroupKey,
      'itemgroup_uid': instance.itemGroupUid,
      'itemgroup_oid': instance.itemGroupOid,
      'itemgroup_repeatkey': instance.itemgroupRepeatkey,
    };

const _$CrfDataTypeEnumMap = {
  CrfDataType.string: 'String',
  CrfDataType.integer: 'Integer',
  CrfDataType.float: 'Float',
  CrfDataType.date: 'Date',
  CrfDataType.unknown: 'unknown',
  CrfDataType.text: 'Text',
  CrfDataType.dateLimited: 'Date_Limited',
  CrfDataType.time: 'Time',
};

const _$CrfInputTypeEnumMap = {
  CrfInputType.textBox: 'TextBox',
  CrfInputType.date: 'Date',
  CrfInputType.time: 'Time',
  CrfInputType.calculate: 'Calculate',
  CrfInputType.comments: 'Comments',
  CrfInputType.radio: 'Radio',
  CrfInputType.dropDown: 'DropDown',
  CrfInputType.checkBox: 'CheckBox',
  CrfInputType.ae: 'AE',
  CrfInputType.drug: 'Drug',
  CrfInputType.icd10: 'ICD10',
  CrfInputType.measurementBpSys: 'M_BP_SYS',
  CrfInputType.measurementBpDia: 'M_BP_DIA',
  CrfInputType.measurementBpPulse: 'M_BP_PULSE',
  CrfInputType.measurementBodyTemperature: 'M_BT',
  CrfInputType.measurementBodyWeight: 'M_BW',
  CrfInputType.measurementSleepStart: 'M_SLEEP_START',
  CrfInputType.measurementSleepEnd: 'M_SLEEP_END',
  CrfInputType.measurementSleepDuration: 'M_SLEEP_DURATION',
  CrfInputType.measurementStep: 'M_STEP',
  CrfInputType.unknown: 'unknown',
};
