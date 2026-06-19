abstract class Failure {
  final String message;
  Failure(this.message);
}

class ApiFailure extends Failure {
  ApiFailure(super.message);
}

class NetworkFailure extends Failure {
  NetworkFailure() : super('No internet connection');
}
