import 'package:json_annotation/json_annotation.dart';
import 'package:icreat_dct/0_data/model/crf/crf_form_info_model.dart';
import 'package:icreat_dct/0_data/dto/crf/crf_item_group_res.dart';

part 'crf_form_info_res.g.dart';

@JsonSerializable(explicitToJson: true)
class CRFFormInfoRes {
  @JsonKey(name: 'itemGroupList')
  final List<CRFItemGroupRes> itemList;

  CRFFormInfoRes({
    required this.itemList,
  });

  factory CRFFormInfoRes.fromJson(Map<String, dynamic> json) =>
      _$CRFFormInfoResFromJson(json);
  Map<String, dynamic> toJson() => _$CRFFormInfoResToJson(this);
}

extension CrfFormInfoResExt on CRFFormInfoRes {
  CFRFormInfoModel toModel() => CFRFormInfoModel(
        itemGroupList: itemList.map((e) => e.toModel()).toList(),
      );
}