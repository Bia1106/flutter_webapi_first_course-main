import 'package:http_interceptor/http/http.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';
import 'package:logger/logger.dart';

class LoggingInterceptor implements InterceptorContract {
  Logger logger = Logger();
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    // TODO: implement interceptRequest
    logger.v('${data.baseUrl}\n${data.headers}\n${data.body}');
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    // TODO: implement interceptResponse
    if (data.statusCode ~/ 100 == 2) {
      logger.i('${data.url}\n${data.headers}\n${data.body}');
    } else {
      logger
          .e('${data.url}\n${data.headers}}\n${data.statusCode}\n${data.body}');
    }
    return data;
  }
}
