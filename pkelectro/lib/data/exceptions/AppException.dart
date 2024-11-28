class AppException implements Exception{
  final _prefix;
  final _message;

  AppException([this._prefix,this._message]);
  @override
  String toString() {
    // TODO: implement toString
    return "$_prefix$_message";
  }
}

class NoInternetConnection extends AppException {
  NoInternetConnection([String? message]):super(message,"No Internet Connection");
}
class RequestTimeOut extends AppException{
  RequestTimeOut([String? message]):super(message,"Request time out");
}
class InternalErrorException extends AppException{
  InternalErrorException([String? message]):super(message,"Internal error"); 
}
