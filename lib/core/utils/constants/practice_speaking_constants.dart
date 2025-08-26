class PracticeSpeakingConstants {
  static String baseUrl = '';
  static String startSession = '$baseUrl/interview/start';
  static String getQuestion(String sessionId) => '$baseUrl/interview/question$sessionId';
  static String submitAnswer = '$baseUrl/interview/answer';
  static String endSession(String sessionId) => '$baseUrl/interview/$sessionId/end';
  
  static String? userToken;
}
