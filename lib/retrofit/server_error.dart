import 'package:doctro/constant/commn_function.dart';
import 'package:dio/dio.dart' hide Headers;

class ServerError implements Exception {
  int? _errorCode;
  String _errorMessage = "";

  ServerError.withError({error}) {
    _handleError(error);
  }

  getErrorCode() {
    return _errorCode;
  }

  getErrorMessage() {
    return _errorMessage;
  }

  _handleError(DioError error) {
    switch (error.type) {
      case DioErrorType.connectTimeout:
        _errorMessage = "Connection timeout";
        CommonFunction.toastMessage('Connection timeout');
        break;
      case DioErrorType.sendTimeout:
        _errorMessage = "Receive timeout in send request";
        CommonFunction.toastMessage('Receive timeout in send request');
        break;
      case DioErrorType.receiveTimeout:
        _errorMessage = "Receive timeout in connection";
        CommonFunction.toastMessage('Receive timeout in connection');
        break;
      case DioErrorType.response:
        _errorMessage = "Received invalid status code: ${error.response!.data}";
        try {
          if (error.response!.data['errors']['name'] != null) {
            CommonFunction.toastMessage(error.response!.data['errors']['name'][0]);
            return;
          } else if (error.response!.data['errors']['phone'] != null) {
            CommonFunction.toastMessage(error.response!.data['errors']['phone'][0]);
            return;
          }
          else if (error.response!.data['errors']['phone_code'] != null) {
            CommonFunction.toastMessage(error.response!.data['errors']['phone_code'][0]);
            return;
          }
          else if (error.response!.data['errors']['password'] != null) {
            CommonFunction.toastMessage(error.response!.data['errors']['password'][0]);
            return;
          }
          else if (error.response!.data['errors']['email_id'] != null) {
            CommonFunction.toastMessage(error.response!.data['errors']['email_id'][0]);
            return;
          }
          else if (error.response!.data['errors']['description'] != null) {
            CommonFunction.toastMessage(error.response!.data['errors']['description'][0]);
            return;
          }
          else if (error.response!.data['errors']['old_password'] != null) {
            CommonFunction.toastMessage(error.response!.data['errors']['old_password'][0]);
            return;
          }
          else if (error.response!.data['errors']['password'] != null) {
            CommonFunction.toastMessage(error.response!.data['errors']['password'][0]);
            return;
          }
          else if (error.response!.data['errors']['password_confirmation'] != null) {
            CommonFunction.toastMessage(error.response!.data['errors']['password_confirmation'][0]);
            return;
          }
          else if (error.response!.data['errors']['password_confirmation'] != null) {
            CommonFunction.toastMessage(error.response!.data['errors']['password_confirmation'][0]);
            return;
          }
          else {
            CommonFunction.toastMessage(error.response!.data['message'].toString());
            return;
          }
        } catch (error1, stacktrace) {
          CommonFunction.toastMessage(error.response!.data.toString());
          print(
              "Exception occurred: $error stackTrace: $stacktrace apiError: ${error.response!.data}");
        }
        break;
      case DioErrorType.cancel:
        _errorMessage = "Request was cancelled";
        CommonFunction.toastMessage('Request was cancelled');
        break;
      case DioErrorType.other:
        _errorMessage = "Connection failed. Please check internet connection";
        CommonFunction.toastMessage('Connection failed. Please check internet connection');
        break;
    }
    return _errorMessage;
  }
}
