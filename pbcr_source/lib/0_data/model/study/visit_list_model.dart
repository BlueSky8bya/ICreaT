class VisitListModel {
  final String userName;
  final int menuAuthLevel;
  final String userOrganName;
  final String userId;
  final List<VisitItemModel> visitList;

  VisitListModel({
    required this.userName,
    required this.menuAuthLevel,
    required this.userOrganName,
    required this.userId,
    required this.visitList,
  });
}

class VisitItemModel {
  final int isExist;
  final int studyEventSeq;
  final String studyNo;
  final String studyEventOid;
  final String studyEventName;
  final int orderNumber;
  final String repeating;
  final String eventType;
  final String mandatory;
  final String scheduleYn;
  final String eventStatus;
  final String useYn;
  final int? eventPeriodMin;
  final int? eventPeriodMax;
  final String eventCycle;
  final String eventInterval;

  VisitItemModel({
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
}
