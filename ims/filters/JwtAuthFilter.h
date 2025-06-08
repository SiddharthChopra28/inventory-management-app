//
// Created by siddharth on 6/9/25.
//


#ifndef JWTAUTHFILTER_H
#define JWTAUTHFILTER_H

#include <drogon/drogon.h>
#include <drogon/utils/Utilities.h>

class JwtAuthFilter: public drogon::HttpFilter<JwtAuthFilter> {
public:
    void doFilter(const drogon::HttpRequestPtr& req, drogon::FilterCallback&& fcb, drogon::FilterChainCallback&& fccb) override;

};



#endif //JWTAUTHFILTER_H
