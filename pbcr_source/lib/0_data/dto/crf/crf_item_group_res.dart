import 'package:json_annotation/json_annotation.dart';
import 'package:icreat_dct/0_data/dto/crf/crf_item_res.dart';
import 'package:icreat_dct/0_data/model/crf/crf_item_group_model.dart';

part 'crf_item_group_res.g.dart';

@JsonSerializable()
class CRFItemGroupRes {
  @JsonKey(name: 'itemgroup_seq')
  final int itemGroupSeq;
  @JsonKey(name: 'itemgroup_uid')
  final String itemGroupUid;
  @JsonKey(name: 'itemgroup_oid')
  final String itemGroupOid;
  @JsonKey(name: 'itemgroup_name')
  final String? itemGroupName;
  @JsonKey(name: 'itemgroup_type')
  final String itemGroupType;
  @JsonKey(name: 'comments')
  final String? comments;
  @JsonKey(name: 'itemList')
  final List<CrfItemRes> itemList;

  CRFItemGroupRes({
    required this.itemGroupSeq,
    required this.itemGroupUid,
    required this.itemGroupOid,
    this.itemGroupName = '',
    required this.itemGroupType,
    this.comments,
    required this.itemList,
  });

  factory CRFItemGroupRes.fromJson(Map<String, dynamic> json) =>
      _$CRFItemGroupResFromJson(json);
  Map<String, dynamic> toJson() => _$CRFItemGroupResToJson(this);
}

extension CRFItemGroupResExtension on CRFItemGroupRes {
  CRFItemGroupModel toModel() {
    return CRFItemGroupModel(
      group: CRFItemGroup(
        itemGroupSeq: itemGroupSeq,
        itemGroupUid: itemGroupUid,
        itemGroupOid: itemGroupOid,
        itemGroupName: itemGroupName ?? '',
        itemGroupType: itemGroupType,
        comments: comments,
      ),
      itemList: itemList.map((e) => e.toModel()).toList(),
    );
  }
}
