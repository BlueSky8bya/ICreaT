// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crf_item_group_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CRFItemGroupRes _$CRFItemGroupResFromJson(Map<String, dynamic> json) =>
    CRFItemGroupRes(
      itemGroupSeq: (json['itemgroup_seq'] as num).toInt(),
      itemGroupUid: json['itemgroup_uid'] as String,
      itemGroupOid: json['itemgroup_oid'] as String,
      itemGroupName: json['itemgroup_name'] as String? ?? '',
      itemGroupType: json['itemgroup_type'] as String,
      comments: json['comments'] as String?,
      itemList: (json['itemList'] as List<dynamic>)
          .map((e) => CrfItemRes.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CRFItemGroupResToJson(CRFItemGroupRes instance) =>
    <String, dynamic>{
      'itemgroup_seq': instance.itemGroupSeq,
      'itemgroup_uid': instance.itemGroupUid,
      'itemgroup_oid': instance.itemGroupOid,
      'itemgroup_name': instance.itemGroupName,
      'itemgroup_type': instance.itemGroupType,
      'comments': instance.comments,
      'itemList': instance.itemList,
    };
