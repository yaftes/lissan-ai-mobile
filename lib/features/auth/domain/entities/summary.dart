import 'package:lissan_ai/features/auth/domain/entities/activity_breakdown.dart';

class Summary {
  ActivityBreakdown? activity_breakdown;
  int? consecutive_weeks;
  int? most_active_count;
  String? most_active_day;
  int? total_activities;

  Summary({
    this.activity_breakdown,
    this.consecutive_weeks,
    this.most_active_count,
    this.most_active_day,
    this.total_activities,
  });
}
