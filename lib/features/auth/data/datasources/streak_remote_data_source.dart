import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lissan_ai/features/auth/data/models/streak_calendar_model.dart';
import 'package:lissan_ai/features/auth/data/models/streak_info_model.dart';

abstract class StreakRemoteDataSource {
  Future<void> freezeStreak();
  Future<StreakCalendarModel> getActivityCalendar();
  Future<StreakInfoModel> getStreakInfo();
  Future<void> recordActivity();
}

class StreakRemoteDataSourceImpl implements StreakRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  StreakRemoteDataSourceImpl({required this.client, required this.baseUrl});

  @override
  Future<void> freezeStreak() async {
    final response = await client.post(Uri.parse('$baseUrl/streak/freeze'));
    if (response.statusCode != 200) {
      throw Exception('Failed to freeze streak');
    }
  }

  @override
  Future<StreakCalendarModel> getActivityCalendar() async {
    final response = await client.get(Uri.parse('$baseUrl/streak/calendar'));
    if (response.statusCode == 200) {
      return StreakCalendarModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load activity calendar');
    }
  }

  @override
  Future<StreakInfoModel> getStreakInfo() async {
    final response = await client.get(Uri.parse('$baseUrl/streak/info'));
    if (response.statusCode == 200) {
      return StreakInfoModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load streak info');
    }
  }

  @override
  Future<void> recordActivity() async {
    final response = await client.post(Uri.parse('$baseUrl/streak/activity'));
    if (response.statusCode != 200) {
      throw Exception('Failed to record activity');
    }
  }
}
