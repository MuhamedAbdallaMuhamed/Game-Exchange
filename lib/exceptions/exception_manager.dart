import 'package:GM_Nav/config/exception_constants.dart';
import '../config/game_constants.dart';
import 'type_exceptions/arithmatic_exception.dart';
import 'type_exceptions/authentication_exception.dart';
import 'type_exceptions/connection_exception.dart';
import 'type_exceptions/exist_exception.dart';
import 'type_exceptions/not_found.dart';
import 'type_exceptions/runtime_exception.dart';

abstract class ExceptionManager implements Exception {
  String message;

  static Exception getException(ExceptionConstants error, [String info]) {
    switch (error) {
      case ExceptionConstants.CONNECTIONFAILED:
        return ConnectionException(info);
        break;
      case ExceptionConstants.NOTFOUND:
        return NotFoundException(info);
        break;
      case ExceptionConstants.EXISTED:
        return AlreadyExistException(info);
        break;
      case ExceptionConstants.RUNTIMEFAILED:
        return RuntimeException(info);
        break;
      case ExceptionConstants.ARITHMATICERROR:
        return ArithmaticException(info);
        break;
      case ExceptionConstants.AUTHENTICATIONFAILED:
        return AuthenticationException(info);
        break;
      default:
        return Exception(GameConstants.GLOBLE_MESSAGE);
    }
  }
}
