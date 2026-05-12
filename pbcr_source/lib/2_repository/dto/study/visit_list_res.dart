import 'package:json_annotation/json_annotation.dart';
import 'package:icreat_dct/0_data/model/study/visit_list_model.dart';

part 'visit_list_res.g.dart';

@JsonSerializable()
class VisitListRes {
  @JsonKey(name: 'usernm')
  final String userName;
  @JsonKey(name: '_MENU_AUTH_LVL')
  final int menuAuthLevel;
  @JsonKey(name: 'userorgannm')
  final String userOrganName;
  @JsonKey(name: 'userid')
  final String userId;
  @JsonKey(name: 'visitList')
  final List<VisitItemRes> visitList;

  VisitListRes({
    required this.userName,
    required this.menuAuthLevel,
    required this.userOrganName,
    required this.userId,
    required this.visitList,
  });

  factory VisitListRes.fromJson(Map<String, dynamic> json) =>
      _$VisitListResFromJson(json);

  Map<String, dynamic> toJson() => _$VisitListResToJson(this);
}

@JsonSerializable()
class VisitItemRes {
  @JsonKey(name: 'IS_EXIST')
  final int isExist;
  @JsonKey(name: 'STUDYEVENT_SEQ')
  final int studyEventSeq;
  @JsonKey(name: 'STDYNO')
  final String studyNo;
  @JsonKey(name: 'STUDYEVENT_OID')
  final String studyEventOid;
  @JsonKey(name: 'STUDYEVENT_NAME')
  final String studyEventName;
  @JsonKey(name: 'ORDER_NUMBER')
  final int orderNumber;
  @JsonKey(name: 'REPEATING')
  final String repeating;
  @JsonKey(name: 'EVENT_TYPE')
  final String eventType;
  @JsonKey(name: 'MANDATORY')
  final String mandatory;
  @JsonKey(name: 'SCHEDULE_YN')
  final String scheduleYn;
  @JsonKey(name: 'EVENT_STATUS')
  final String eventStatus;
  @JsonKey(name: 'USE_YN')
  final String useYn;
  @JsonKey(name: 'EVENT_PERIOD_MIN')
  final int? eventPeriodMin;
  @JsonKey(name: 'EVENT_PERIOD_MAX')
  final int? eventPeriodMax;
  @JsonKey(name: 'EVENT_CYCLE')
  final String eventCycle;
  @JsonKey(name: 'EVENT_INTERVAL')
  final String eventInterval;

  VisitItemRes({
    required this.isExist,
    required this.studyEventSeq,
    required this.studyNo,
    required this.studyEventOid,
    required this.studyEventName,
    required this.orderNumber,
    required this.repeating,
    required this.eventType,
    required this.mandatory,
    required this.scheduleYn,
    required this.eventStatus,
    required this.useYn,
    this.eventPeriodMin,
    this.eventPeriodMax,
    required this.eventCycle,
    required this.eventInterval,
  });

  factory VisitItemRes.fromJson(Map<String, dynamic> json) =>
      _$VisitItemResFromJson(json);

  Map<String, dynamic> toJson() => _$VisitItemResToJson(this);
}

extension VisitListResExt on VisitListRes {
  VisitListModel toModel() => VisitListModel(
        userName: userName,
        menuAuthLevel: menuAuthLevel,
        userOrganName: userOrganName,
        userId: userId,
        visitList: visitList.map((e) => e.toModel()).toList(),
      );
}

extension VisitItemResExt on VisitItemRes {
  VisitItemModel toModel() => VisitItemModel(
        isExist: isExist,
        studyEventSeq: studyEventSeq,
        studyNo: studyNo,
        studyEventOid: studyEventOid,
        studyEventName: studyEventName,
        orderNumber: orderNumber,
        repeating: repeating,
        eventType: eventType,
        mandatory: mandatory,
        scheduleYn: scheduleYn,
        eventStatus: eventStatus,
        useYn: useYn,
        eventPeriodMin: eventPeriodMin,
        eventPeriodMax: eventPeriodMax,
        eventCycle: eventCycle,
        eventInterval: eventInterval,
      );
}
