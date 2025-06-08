abstract class AuthRepository{
  Future<void> login(String email, String password);
  Future<void> register(String email, String password);

  Future<String> getAuthTokenFromSecuredStorage();

  Future<void> logout();
  Future<void> refreshToken();
  Future<bool> isAuthenticated();

}