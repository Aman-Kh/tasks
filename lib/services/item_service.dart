import 'package:dio/dio.dart';

class ItemsService {
  final String _baseUrl = 'https://jsonplaceholder.typicode.com/todos';

  Future<dynamic> getData() async {
    try {
      Response response = await Dio()
          .get(_baseUrl, options: Options(contentType: "application/json"));

      if (response.statusCode == 200) {
        return response.data;
      }
      return [];
    } on DioError catch (e) {
      print("EXCEPTION:" + e.response!.data);
      return e.response!.data;
    }
  }
}
