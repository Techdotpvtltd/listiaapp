abstract class AppException implements Exception {
  final String message;
  final int? errorCode;

  AppException({required this.message, this.errorCode});
}
