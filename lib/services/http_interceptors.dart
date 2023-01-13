import 'package:http_interceptor/http_interceptor.dart';
import 'package:logger/logger.dart';

class LoggingInterceptor implements InterceptorContract {
  Logger logger = Logger();

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    logger.v("Requisição para: ${data.baseUrl}\n"
        "Tipo da requisição: ${data.method}\n"
        "Cabeçalhos: ${data.headers}\n"
        "Corpo: ${data.body}");
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    if (data.statusCode ~/ 100 == 2) {
      logger.i("Resposta de: ${data.url}\n"
          "Status: ${data.statusCode}\n"
          "Cabeçalhos: ${data.headers}\n"
          "Corpo: ${data.body}");
      return data;
    } else {
      logger.e("Resposta de: ${data.url}\n"
          "Cabeçalhos: ${data.headers}\n"
          "Corpo: ${data.body}");
      return data;
    }
  }
}
