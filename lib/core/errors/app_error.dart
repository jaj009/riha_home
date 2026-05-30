/// Generic error wrapper for app-level errors.
class AppError {
  final String message;
  final dynamic cause;

  const AppError(this.message, [this.cause]);

  @override
  String toString() =>
      'AppError: $message${cause != null ? ' (cause: $cause)' : ''}';
}
