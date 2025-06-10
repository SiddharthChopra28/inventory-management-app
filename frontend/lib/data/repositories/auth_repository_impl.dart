import 'package:frontend/domain/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final dio = Dio();
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  final String _baseUrl = 'http://10.0.2.2:5556';

  @override
  Future<bool> login(String username, String password) async {
    try {
      final response = await dio.post(
        '$_baseUrl/auth/login',
        data: {'username': username, 'password': password},
      );
      var retjson = response.data;
      await _storage.write(key: 'accessToken', value: retjson['accessToken']);
      print("written to storage");
      var token = await FlutterSecureStorage().read(key: 'accessToken');
       
      return true;


      }
      catch (e) {
      print(e);
      print("error hereeeee");
      return false;
    }
  }

  @override
  Future<bool> register(String username, String password) async{
    try {
      final response = await dio.post(
        '$_baseUrl/auth/register',
        data: {'username': username, 'password': password},
      );
      if (response.statusCode == 200) {
        return true;
      }
      else{
        return false;
      }

    }
    catch (e) {
      return false;
    }
  }

  @override
  Future<void> logout() async {
    try {
        await _storage.delete(key: 'accessToken');

    }
    catch (e) {
      print(e);
    }
  }

  @override
  Future<bool> isAuthenticated() async{
    var accTok = await _storage.read(key: 'accessToken');
    return (accTok != null);

  }

  @override
  Future<String> getAccessTokenFromSecuredStorage() async{
    var x = await _storage.read(key: 'accessToken');
    if (x == null){
      return "";
    }
    return x;

  }

}


