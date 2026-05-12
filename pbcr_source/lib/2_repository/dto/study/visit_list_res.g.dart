// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_list_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitListRes _$VisitListResFromJson(Map<String, dynamic> json) => VisitListRes(
      userName: json['usernm'] as String,
      menuAuthLevel: (json['_MENU_AUTH_LVL'] as num).toInt(),
      userOrganName: json['userorgannm'] as String,
      userId: json['userid'] as String,
      visitList: (json['visitList'] as List<dynamic>)
          .map((e) => VisitItemRes.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VisitListResToJson(VisitListRes instance) =>
    <String, dynamic>{
      'usernm': instance.userName,
      '_MENU_AUTH_LVL': instance.menuAuthLevel,
      'userorgannm': instance.userOrganName,
      'userid': instance.userId,
      'visitList': instance.visitList,
    };

VisitItemRes _$VisitItemResFromJson(Map<String, dynamic> json) => VisitItemRes(
      isExist: (json['IS_EXIST'] as num).toInt(),
      studyEventSeq: (json['STUDYEVENT_SEQ'] as num).toInt(),
      studyNo: json['STDYNO'] as String,
      studyEventOid: json['STUDYEVENT_OID'] as String,
      studyEventName: json['STUDYEVENT_NAME'] as String,
      orderNumber: (json['ORDER_NUMBER'] as num).toInt(),
      repeating: json['REPEATING'] as String,
      eventType: json['EVENT_TYPE'] as String,
      mandatory: json['MANDATORY'] as String,
      scheduleYn: json['SCHEDULE_YN'] as String,
      eventStatus: json['EVENT_STATUS'] as String,
      useYn: json['USE_YN'] as String,
      eventPeriodMin: (json['EVENT_PERIOD_MIN'] as num?)?.toInt(),
      eventPeriodMax: (json['EVENT_PERIOD_MAX'] as num?)?.toInt(),
      eventCycle: json['EVENT_CYCLE'] as String,
      eventInterval: json['EVENT_INTERVAL'] as String,
    );

Map<String, dynamic> _$VisitItemResToJson(VisitItemRes instance) =>
    <String, dynamic>{
      'IS_EXIST': instance.isExist,
      'STUDYEVENT_SEQ': instance.studyEventSeq,
      'STDYNO': instance.studyNo,
      'STUDYEVENT_OID': instance.studyEventOid,
      'STUDYEVENT_NAME': instance.studyEventName,
      'ORDER_NUMBER': instance.orderNumber,
      'REPEATING': instance.repeating,
      'EVENT_TYPE': instance.eventType,
      'MANDATORY': instance.mandatory,
      'SCHEDULE_YN': instance.scheduleYn,
      'EVENT_STATUS': instance.eventStatus,
      'USE_YN': instance.useYn,
      'EVENT_PERIOD_MIN': instance.eventPeriodMin,
      'EVENT_PERIOD_MAX': instance.eventPeriodMax,
      'EVENT_CYCLE': instance.eventCycle,
      'EVENT_INTERVAL': instance.eventInterval,
    };
