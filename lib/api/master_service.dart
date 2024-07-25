import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

enum Level { debug, info, warning, error, alien }

void logDebug(String message, {Level level = Level.info}) {
  // Define ANSI escape codes for different colors
  const String resetColor = '\x1B[0m';
  const String redColor = '\x1B[31m'; // Red
  const String greenColor = '\x1B[32m'; // Green
  const String yellowColor = '\x1B[33m'; // Yellow
  const String cyanColor = '\x1B[36m'; // Cyan

  // Get the current time in hours, minutes, and seconds
  final now = DateTime.now();
  final timeString =
      '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

  // Only log messages if the app is running in debug mode
  if (kDebugMode) {
    try {
      String logMessage;
      switch (level) {
        case Level.debug:
          logMessage = '$cyanColor[DEBUG][$timeString] $message$resetColor';
          break;
        case Level.info:
          logMessage = '$greenColor[INFO][$timeString] $message$resetColor';
          break;
        case Level.warning:
          logMessage = '$yellowColor[WARNING][$timeString] $message $resetColor';
          break;
        case Level.error:
          logMessage = '$redColor[ERROR][$timeString] $message $resetColor';
          break;
        case Level.alien:
          logMessage = '$redColor[ALIEN][$timeString] $message $resetColor';
          break;
      }

      debugPrint(logMessage);
    } catch (e) {
      print(e.toString());
    }
  }
}

String _prettyJsonEncode(dynamic data) {
  try {
    const encoder = JsonEncoder.withIndent('  ');
    final jsonString = encoder.convert(data);
    return jsonString;
  } catch (e) {
    return data.toString();
  }
}

class MasterService {
  static Dio init({String? token}) {
    Dio dio = Dio();

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          logDebug('''
            \n.........................................................................
            \nonRequest: ${options.method} request => ${options.baseUrl}${options.path}
            \nonRequest: Request Headers => ${options.headers}
            \nonRequest: Request Data => ${_prettyJsonEncode(options.data)}
          ''', level: Level.info);

          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          logDebug('''
            \nonResponse: ${response.requestOptions.method} request => ${response.requestOptions.baseUrl}${response.requestOptions.path}
            \nonResponse: StatusCode: ${response.statusCode}, Data: ${_prettyJsonEncode(response.data)}
            \n.........................................................................
          ''', level: Level.debug);

          return handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) {
          logDebug('''
            \nonError: ${error.requestOptions.method} request => ${error.requestOptions.baseUrl}${error.requestOptions.path}
            \nonError: ${error.error}, Message: ${error.message}
            \nonError: ${error.response?.data['error_message']}
            \nonError: ${error.response?.data['message']}
            \nData: ${_prettyJsonEncode(error.response?.data)}
          ''', level: Level.error);


          if (error.type == DioExceptionType.connectionError) {
            return handler.resolve(Response(requestOptions: error.requestOptions,
                statusCode: 503,
                data: {'error': 'Network Unavailable'}
            ));
          }
          else {
            return handler.resolve(error.response!);
          }
        },
      ),
    );

    dio.options.baseUrl = kDebugMode
        ? 'https://market-74s4lexw6q-as.a.run.app/api'
        : 'https://market-74s4lexw6q-as.a.run.app/api';

    if (token != null) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }

    return dio;
  }
}