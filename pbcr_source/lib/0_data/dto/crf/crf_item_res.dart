import 'package:icreat_dct/8_extension/string_ext.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:icreat_dct/0_data/model/crf/crf_item_model.dart';
import 'package:icreat_dct/0_data/model/type/crf_data_type.dart';
import 'package:icreat_dct/0_data/model/type/crf_input_type.dart';

part 'crf_item_res.g.dart';

@JsonSerializable()
class CrfItemRes {
  @JsonKey(name: 'order_number')
  final int? orderNumber;

  @JsonKey(name: 'item_seq')
  final int itemSeq;
  @JsonKey(name: 'item_uid')
  final String itemUid;
  @JsonKey(name: 'item_oid')
  final String itemOid;
  @JsonKey(name: 'item_name')
  final String itemName;
  @JsonKey(name: 'item_name_label')
  final String itemNameLabel;
  @JsonKey(
    name: 'data_type',
    unknownEnumValue: CrfDataType.string,
    defaultValue: CrfDataType.string,
  )
  final CrfDataType dataType;
  @JsonKey(
    name: 'input_type',
    unknownEnumValue: CrfInputType.textBox,
  )
  final CrfInputType inputType;
  @JsonKey(name: 'orgn_item_value')
  final String? orgnItemValue;
  @JsonKey(name: 'item_value')
  final String? itemValue;
  @JsonKey(name: 'code_list')
  final String? codeList;
  @JsonKey(name: 'measurement_unit')
  final String? measurementUnit;

  @JsonKey(name: 'item_length')
  final String? itemLength;

  @JsonKey(name: 'comment_header')
  final String? commentHeader;
  @JsonKey(name: 'comment_body')
  final String? commentBody;

  /// 아이템 그룹 관련
  @JsonKey(name: 'itemgroup_seq')
  final int itemGroupKey;
  @JsonKey(name: 'itemgroup_uid')
  final String itemGroupUid;
  @JsonKey(name: 'itemgroup_oid')
  final String itemGroupOid;
  @JsonKey(name: 'itemgroup_repeatkey')
  final int itemgroupRepeatkey;

  CrfItemRes({
    required this.orderNumber,
    required this.itemSeq,
    required this.itemUid,
    required this.itemOid,
    required this.itemName,
    required this.itemNameLabel,
    required this.dataType,
    required this.inputType,
    required this.itemgroupRepeatkey,
    this.itemLength,
    this.orgnItemValue,
    this.itemValue,
    this.codeList,
    this.measurementUnit,
    this.commentHeader,
    this.commentBody,
    required this.itemGroupKey,
    required this.itemGroupUid,
    required this.itemGroupOid,
  });

  factory CrfItemRes.fromJson(Map<String, dynamic> json) =>
      _$CrfItemResFromJson(json);
  Map<String, dynamic> toJson() => _$CrfItemResToJson(this);

  String? get measureUnit {
    if (!measurementUnit.isNullOrEmpty) {
      return measurementUnit;
    }

    switch(inputType) {
      case CrfInputType.measurementBpSys:
        return "mmHg";
      case CrfInputType.measurementBpDia:
        return "mmHg";
      case CrfInputType.measurementBpPulse:
        return "bpm";
      case CrfInputType.measurementBodyTemperature:
        return "℃";
      case CrfInputType.measurementBodyWeight:
        return "kg";
      default:
        return null;
    }
  }
}

extension CrfItemResExt on CrfItemRes {
  CRFItemModel toModel() => CRFItemModel(
        orderNumber: orderNumber ?? 0,
        itemSeq: itemSeq,
        itemUid: itemUid,
        itemOid: itemOid,
        itemName: itemName,
        itemNameLabel: itemNameLabel,
        itemGroupRepeatkey: itemgroupRepeatkey,
        dataType: dataType,
        inputType: inputType,
        itemLength: itemLength,
        originItemValue: orgnItemValue,
        itemValue: itemValue == '{No Data}' ? null : itemValue!,
        codeList: codeList,
        commentHeader: commentHeader,
        commentBody: commentBody,
        measurementUnit: measureUnit,
        itemGroupKey: itemGroupKey,
        itemGroupUid: itemGroupUid,
        itemGroupOid: itemGroupOid,
      );
}
