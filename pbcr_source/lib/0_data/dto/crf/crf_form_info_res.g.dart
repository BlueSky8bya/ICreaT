// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crf_form_info_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CRFFormInfoRes _$CRFFormInfoResFromJson(Map<String, dynamic> json) =>
    CRFFormInfoRes(
      itemList: (json['itemGroupList'] as List<dynamic>)
          .map((e) => CRFItemGroupRes.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CRFFormInfoResToJson(CRFFormInfoRes instance) =>
    <String, dynamic>{
      'itemGroupList': instance.itemList.map((e) => e.toJson()).toList(),
    };
