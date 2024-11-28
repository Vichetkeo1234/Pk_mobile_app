abstract class ApiService{
  Future<dynamic> getApi(String Url);
  Future<dynamic> posApi(String Url, {dynamic requestBody});
}