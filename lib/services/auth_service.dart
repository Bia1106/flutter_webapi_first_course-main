import 'dart:io';

import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';

class AuthService {
  static const String url = 'http://192.168.0.179:3000/';

  http.Client client =
      InterceptedClient.build(interceptors: [LoggingInterceptor()]);

  login({required String email, required String password}) async {
    http.Response response = await client.post(Uri.parse('${url}login'),
        body: {'email': email, 'password': password});
    if (response.statusCode != 200) {
      throw HttpException(response.body);
    }
  }

  register() {}
}
