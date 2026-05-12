class EsourceSubmissionStatus {
  final int? id;
  final int formSeq; // 서버 A (ICReaT)의 formSeq
  final int studyEventSeq; // 서버 A (ICReaT)의 studyEventSeq - 일정 구분용
  final String uuid; // eSource (Esource)로 보낸 UUID
  final String visitOccurrenceId; // visit_occurrence_id (studyEventName)
  final String formName; // form_name
  final DateTime createdAt; // 생성 시간
  final String status; // 상태 (pending, approved, rejected, error)
  final DateTime? lastChecked; // 마지막 확인 시간
  final String? errorMessage; // 오류 메시지

  EsourceSubmissionStatus({
    this.id,
    required this.formSeq,
    required this.studyEventSeq,
    required this.uuid,
    required this.visitOccurrenceId,
    required this.formName,
    required this.createdAt,
    required this.status,
    this.lastChecked,
    this.errorMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'form_seq': formSeq,
      'study_event_seq': studyEventSeq,
      'uuid': uuid,
      'visit_occurrence_id': visitOccurrenceId,
      'form_name': formName,
      'created_at': createdAt.millisecondsSinceEpoch,
      'status': status,
      'last_checked': lastChecked?.millisecondsSinceEpoch,
      'error_message': errorMessage,
    };
  }

  factory EsourceSubmissionStatus.fromMap(Map<String, dynamic> map) {
    return EsourceSubmissionStatus(
      id: map['id'],
      formSeq: map['form_seq'],
      studyEventSeq: map['study_event_seq'],
      uuid: map['uuid'],
      visitOccurrenceId: map['visit_occurrence_id'],
      formName: map['form_name'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      status: map['status'],
      lastChecked: map['last_checked'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['last_checked'])
          : null,
      errorMessage: map['error_message'],
    );
  }

  EsourceSubmissionStatus copyWith({
    int? id,
    int? formSeq,
    int? studyEventSeq,
    String? uuid,
    String? visitOccurrenceId,
    String? formName,
    DateTime? createdAt,
    String? status,
    DateTime? lastChecked,
    String? errorMessage,
  }) {
    return EsourceSubmissionStatus(
      id: id ?? this.id,
      formSeq: formSeq ?? this.formSeq,
      studyEventSeq: studyEventSeq ?? this.studyEventSeq,
      uuid: uuid ?? this.uuid,
      visitOccurrenceId: visitOccurrenceId ?? this.visitOccurrenceId,
      formName: formName ?? this.formName,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      lastChecked: lastChecked ?? this.lastChecked,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

enum EsourceStatus {
  nil('0'),
  pending('10'), // 전송
  rejected('40'), // 재측정요청
  approved('50'), // 승인
  securityApproved('60'), // 보안승인
  transmissionError('98'), // 전송 오류
  dataError('99'); // 데이터 오류

  const EsourceStatus(this.value);
  final String value;

  static EsourceStatus fromProcStatCd(String procStatCd) {
    return EsourceStatus.values.firstWhere(
      (status) => status.value == procStatCd,
      orElse: () => EsourceStatus.nil,
    );
  }

  /// UI 표시용 상태 그룹
  bool get isPending => this == EsourceStatus.pending;
  bool get isApproved => this == EsourceStatus.approved || this == EsourceStatus.securityApproved;
  bool get isRejected => this == EsourceStatus.rejected;
  bool get isNull => this == EsourceStatus.nil;
  bool get isError => this == EsourceStatus.transmissionError || this == EsourceStatus.dataError;
}
