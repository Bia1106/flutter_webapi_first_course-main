import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:http/http.dart' as http;

import 'http_interceptors.dart';

class WebClient {
  static const String url =
      'http://192.168.0.179:3000/'; //lembrar de alterar tanto aqui quanto no comando do json-server caso o ip mude, checar no cmd com o comando ipconfig
  http.Client client = InterceptedClient.build(
      interceptors: [LoggingInterceptor()],
      requestTimeout: const Duration(seconds: 5));
}
