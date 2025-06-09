#pragma once
#include <drogon/HttpController.h>
#include <jwt-cpp/jwt.h>
#include <drogon/orm/Mapper.h>
#include <models/Users.h>
#include <bcrypt/BCrypt.hpp>


class ItemsController : public drogon::HttpController<ItemsController> {
public:
    METHOD_LIST_BEGIN
    ADD_METHOD_TO(ItemsController::getItemsBySearchStr, "/items/get/search", drogon::Get, "JwtAuthFilter");
    ADD_METHOD_TO(ItemsController::getItemsByID, "/items/get/id", drogon::Get, "JwtAuthFilter");
    ADD_METHOD_TO(ItemsController::getCategories, "/items/get_categories", drogon::Get, "JwtAuthFilter");
    ADD_METHOD_TO(ItemsController::addItem, "/items/add", drogon::Post, "JwtAuthFilter");
    ADD_METHOD_TO(ItemsController::updateItem, "/items/update", drogon::Post, "JwtAuthFilter");
    ADD_METHOD_TO(ItemsController::uploadImage, "/items/imageUpload", drogon::Post, "JwtAuthFilter");
    ADD_METHOD_TO(ItemsController::downloadImage, "/images/{1}", drogon::Get);
    METHOD_LIST_END

    void getItemsBySearchStr(const drogon::HttpRequestPtr &req,
               std::function<void(const drogon::HttpResponsePtr &)> &&callback);
    void getItemsByID(const drogon::HttpRequestPtr &req,
               std::function<void(const drogon::HttpResponsePtr &)> &&callback);
    void getCategories(const drogon::HttpRequestPtr &req,
               std::function<void(const drogon::HttpResponsePtr &)> &&callback);
    void addItem(const drogon::HttpRequestPtr &req,
               std::function<void(const drogon::HttpResponsePtr &)> &&callback);
    void updateItem(const drogon::HttpRequestPtr &req,
               std::function<void(const drogon::HttpResponsePtr &)> &&callback);
    void uploadImage(const drogon::HttpRequestPtr &req,
               std::function<void(const drogon::HttpResponsePtr &)> &&callback);
    void downloadImage(const drogon::HttpRequestPtr &req,
               std::function<void(const drogon::HttpResponsePtr &)> &&callback,  std::string filename );
};
