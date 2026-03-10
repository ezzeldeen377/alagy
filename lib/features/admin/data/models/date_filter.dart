enum DateFilter {
  today,
  thisMonth,
  allTime,
}

extension DateFilterExtension on DateFilter {
  String get displayName {
    switch (this) {
      case DateFilter.today:
        return 'Today';
      case DateFilter.thisMonth:
        return 'This Month';
      case DateFilter.allTime:
        return 'All Time';
    }
  }

  DateTime? get startDate {
    final now = DateTime.now();
    switch (this) {
      case DateFilter.today:
        return DateTime(now.year, now.month, now.day);
      case DateFilter.thisMonth:
        return DateTime(now.year, now.month, 1);
      case DateFilter.allTime:
        return null;
    }
  }

  DateTime? get endDate {
    final now = DateTime.now();
    switch (this) {
      case DateFilter.today:
        return DateTime(now.year, now.month, now.day, 23, 59, 59);
      case DateFilter.thisMonth:
        return DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      case DateFilter.allTime:
        return null;
    }
  }
}