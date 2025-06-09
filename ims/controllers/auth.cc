#include "auth.h"


void AuthController::login(const drogon::HttpRequestPtr& req,
                           std::function<void(const drogon::HttpResponsePtr&)>&& callback)
{
    auto json = req->getJsonObject();
    if (!json || (*json)["username"].empty() || (*json)["password"].empty())
    {
        auto resp = drogon::HttpResponse::newHttpResponse();
        resp->setStatusCode(drogon::k400BadRequest);
        resp->setBody("Missing credentials");
        callback(resp);
        return;
    }

    std::string username = (*json)["username"].asString();
    std::string password = (*json)["password"].asString();

    auto dbClient = drogon::app().getDbClient();
    drogon::orm::Mapper<drogon_model::sqlite3::Users> userMapper(dbClient);


    auto user = userMapper.findOne(drogon::orm::Criteria("username", drogon::orm::CompareOperator::EQ,  username));

    bool isCorrect = BCrypt::validatePassword(password, user.getValueOfPassword());


    if (!isCorrect) { // need to add a real check here
        auto resp = drogon::HttpResponse::newHttpResponse();
        resp->setStatusCode(drogon::k401Unauthorized);
        resp->setBody("Invalid username or password");
        callback(resp);
        return;
    }

    std::string token = jwt::create()
        .set_issuer("ims")
        .set_type("JWS")
        .set_payload_claim("username", jwt::claim(username))
        .set_expires_at(std::chrono::system_clock::now() + std::chrono::hours(48))
        .sign(jwt::algorithm::hs256{"thisismysecretkeyiwillputitintoenvlater"});

    Json::Value result;
    result["accessToken"] = token;
    auto resp = drogon::HttpResponse::newHttpJsonResponse(result);
    callback(resp);
}


void AuthController::registerUser(const drogon::HttpRequestPtr& req,
                           std::function<void(const drogon::HttpResponsePtr&)>&& callback)
{
    auto json = req->getJsonObject();
    if (!json || (*json)["username"].empty() || (*json)["password"].empty())
    {
        auto resp = drogon::HttpResponse::newHttpResponse();
        resp->setStatusCode(drogon::k400BadRequest);
        resp->setBody("Missing credentials");
        callback(resp);
        return;
    }

    std::string username = (*json)["username"].asString();
    std::string password = (*json)["password"].asString();

    auto dbClient = drogon::app().getDbClient();
    // std::cout<<dbClient->connectionInfo();

    drogon::orm::Mapper<drogon_model::sqlite3::Users> userMapper(dbClient);


    auto existing_users = userMapper.limit(1).findBy(
        drogon::orm::Criteria("username", drogon::orm::CompareOperator::EQ, username)
    );

    if (!existing_users.empty()) { // need to add a real check here
        auto resp = drogon::HttpResponse::newHttpResponse();
        resp->setStatusCode(drogon::k400BadRequest);
        resp->setBody("Username already exists");
        callback(resp);
        return;
    }
    drogon_model::sqlite3::Users newUser;

    newUser.setUsername(username);
    newUser.setPassword(BCrypt::generateHash(password));
    userMapper.insert(newUser);

    auto resp = drogon::HttpResponse::newHttpResponse();
    callback(resp);
}
