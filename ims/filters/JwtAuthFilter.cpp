//
// Created by siddharth on 6/9/25.
//

#include "JwtAuthFilter.h"
#include "jwt-cpp/jwt.h"

void JwtAuthFilter::doFilter(const drogon::HttpRequestPtr &req,
                              drogon::FilterCallback &&fcb,
                              drogon::FilterChainCallback &&fccb) {

    auto authHeader = req->getHeader("Authorization");
    if (authHeader.rfind("Bearer ", 0) != 0) {
        auto resp = drogon::HttpResponse::newHttpResponse();
        resp->setStatusCode(drogon::k401Unauthorized);
        resp->setBody("Missing or invalid Authorization header");
        fcb(resp);
        return;
    }

    std::string token = authHeader.substr(7);
    try {
        auto decoded = jwt::decode(token);
        auto verifier = jwt::verify()
            .allow_algorithm(jwt::algorithm::hs256{"thisismysecretkeyiwillputitintoenvlater"})
            .with_issuer("ims");
        verifier.verify(decoded);
        std::string username = decoded.get_payload_claim("username").as_string();
        req->attributes()->insert("username", username);
        fccb();
    } catch (const std::exception &e) {
        auto resp = drogon::HttpResponse::newHttpResponse();
        resp->setStatusCode(drogon::k401Unauthorized);
        resp->setBody("Token verification failed: " + std::string(e.what()));
        fcb(resp);
    }
}
