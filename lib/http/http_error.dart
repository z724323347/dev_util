/// http error
class HttpError with Exception {
  final String message;
  final int code;

  HttpError(this.message, {this.code});

  @override
  String toString() {
    // TODO: implement toString
    return this.message;
  }
}
