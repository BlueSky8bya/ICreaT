enum StatsType {
  oneWeek,
  oneMonth,
  threeMonth,
  sixMonth;

  int get days {
    switch (this) {
      case StatsType.oneWeek:
        return 6;
      case StatsType.oneMonth:
        return 30;
      case StatsType.threeMonth:
        return 92;
      case StatsType.sixMonth:
        return 185;
    }
  }

  int get targetGroups {
    switch (this) {
      case StatsType.oneWeek:
        return 7;
      case StatsType.oneMonth:
        return 30;
      case StatsType.threeMonth:
        return 30;
      case StatsType.sixMonth:
        return 30;
    }
  }

  String get label {
    switch (this) {
      case StatsType.oneWeek:
        return '1주';
      case StatsType.oneMonth:
        return '1개월';
      case StatsType.threeMonth:
        return '3개월';
      case StatsType.sixMonth:
        return '6개월';
    }
  }
}
