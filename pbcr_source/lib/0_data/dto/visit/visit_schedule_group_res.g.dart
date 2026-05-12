// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_schedule_group_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitScheduleGroupRes _$VisitScheduleGroupResFromJson(
        Map<String, dynamic> json) =>
    VisitScheduleGroupRes(
      scheduleList: (json['scheduleList'] as List<dynamic>)
          .map((e) => VisitScheduleItemRes.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VisitScheduleGroupResToJson(
        VisitScheduleGroupRes instance) =>
    <String, dynamic>{
      'scheduleList': instance.scheduleList.map((e) => e.toJson()).toList(),
    };
