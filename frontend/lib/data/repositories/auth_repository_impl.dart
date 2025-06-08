import 'package:frontend/domain/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final dio = Dio();
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  Future<bool> login(String username, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {'username': username, 'password': password},
      );
      if (response.statusCode == 200) {
        var retjson = response.data;
        await _storage.write(key: 'accessToken', value: retjson['accessToken']);
        return true;
      }
      else{
        return false;
      }

      }
      catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> register(String username, String password) async{
    try {
      final response = await dio.post(
        '/auth/register',
        data: {'username': username, 'password': password},
      );
      if (response.statusCode == 200) {
        // var retjson = response.data;
        return true;
      }
      else{
        return false;
      }

    }
    catch (e) {
      print(e);
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


