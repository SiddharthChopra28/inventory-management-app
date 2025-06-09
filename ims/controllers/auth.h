#pragma once
#include <drogon/HttpController.h>
#include <jwt-cpp/jwt.h>
#include <drogon/orm/Mapper.h>
#include <models/Users.h>
#include <bcrypt/BCrypt.hpp>


class AuthController : public drogon::HttpController<AuthController> {
public:
    METHOD_LIST_BEGIN
    ADD_METHOD_TO(AuthController::login, "/auth/login", drogon::Post);
    ADD_METHOD_TO(AuthController::registerUser, "/auth/register", drogon::Post);
    METHOD_LIST_END

    void login(const drogon::HttpRequestPtr &req,
               std::function<void(const drogon::HttpResponsePtr &)> &&callback);
    void registerUser(const drogon::HttpRequestPtr &req,
               std::function<void(const drogon::HttpResponsePtr &)> &&callback);
};
