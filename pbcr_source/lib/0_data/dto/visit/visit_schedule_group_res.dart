import 'package:json_annotation/json_annotation.dart';
import 'package:icreat_dct/0_data/model/icreat/visit_schedule_group_model.dart';
import 'package:icreat_dct/0_data/dto/visit/visit_schedule_item_res.dart';

part 'visit_schedule_group_res.g.dart';

@JsonSerializable(explicitToJson: true)
class VisitScheduleGroupRes {
  @JsonKey(name: 'scheduleList')
  final List<VisitScheduleItemRes> scheduleList;

  VisitScheduleGroupRes({
    required this.scheduleList,
  });

  factory VisitScheduleGroupRes.fromJson(Map<String, dynamic> json) =>
      _$VisitScheduleGroupResFromJson(json);

  Map<String, dynamic> toJson() => _$VisitScheduleGroupResToJson(this);
}

extension VisitScheduleGroupResExt on VisitScheduleGroupRes {
  VisitScheduleGroupModel toModel() => VisitScheduleGroupModel(
        scheduleList: scheduleList.map((e) => e.toModel()).toList(),
      );
}
