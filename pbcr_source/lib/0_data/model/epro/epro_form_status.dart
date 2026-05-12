enum FormStatus {
  ready,
  completed,
  crfWrite,
  confirmed,
  pending;

  bool get isEditable => this == crfWrite || this == ready;
  bool get isPending => this == pending || this == crfWrite;
  bool get isSubmitted => this == completed || this == crfWrite || this == confirmed;
  bool get isCompleted => this == completed || this == confirmed;

  static FormStatus fromString(String status) {
    switch (status) {
      case 'R':
        return FormStatus.ready;
      case 'Y':
        return FormStatus.completed;
      case 'N':
        return FormStatus.crfWrite;
      case 'C':
        return FormStatus.confirmed;
      default:
        return FormStatus.ready;
    }
  }

  static String toStatusString(FormStatus status) {
    switch (status) {
      case FormStatus.ready:
        return 'R';
      case FormStatus.completed:
        return 'Y';
      case FormStatus.crfWrite:
        return 'N';
      case FormStatus.confirmed:
        return 'C';
      case FormStatus.pending:
        return 'P'; // 새로운 상태용 코드
    }
  }
}
