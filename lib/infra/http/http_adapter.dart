import 'dart:convert';

import 'package:http/http.dart';

import '../../data/http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  Future<dynamic> request({
    required String url,
    required String method,
    Map? body,
    Map? headers,
  }) async {
    final defaultHeaders = headers?.cast<String, String>() ?? {}
      ..addAll({
        'content-type': 'application/json',
        'accept': 'application/json',
      });

    final jsonBody = body != null ? jsonEncode(body) : null;
    var response = Response('', 500);
    Future<Response>? futureResponse;

    try {
      if (method == 'post') {
        futureResponse = client.post(
          Uri.parse(url),
          headers: defaultHeaders,
          body: jsonBody,
        );
      } else if (method == 'get') {
        futureResponse = client.get(
          Uri.parse(url),
          headers: defaultHeaders,
        );
      } else if (method == 'put') {
        futureResponse = client.put(
          Uri.parse(url),
          headers: defaultHeaders,
          body: jsonBody,
        );
      }
      if (futureResponse != null) {
        response = await futureResponse.timeout(Duration(seconds: 10));
      }
    } catch (error) {
      throw HttpError.serverError;
    }
    return _handleResponse(response);
  }

  dynamic _handleResponse(Response response) {
    if (response.statusCode == 200) {
      return response.body.isEmpty ? null : jsonDecode(response.body);
    } else if (response.statusCode == 204) {
      return null;
    } else if (response.statusCode == 400) {
      throw HttpError.badRequest;
    } else if (response.statusCode == 401) {
      throw HttpError.unauthorized;
    } else if (response.statusCode == 403) {
      throw HttpError.forbbiden;
    } else if (response.statusCode == 404) {
      throw HttpError.notFound;
    } else {
      throw HttpError.serverError;
    }
  }
}
