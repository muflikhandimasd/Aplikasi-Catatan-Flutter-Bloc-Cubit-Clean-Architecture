abstract class Failure {
  final String message;
  Failure({required this.message});
}

class CacheFailure extends Failure {
  CacheFailure({required super.message});
}
