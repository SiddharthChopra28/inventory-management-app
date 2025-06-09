#pragma once
#include <drogon/HttpController.h>
#include <jwt-cpp/jwt.h>
#include <drogon/orm/Mapper.h>
#include <models/Users.h>
#include <bcrypt/BCrypt.hpp>


class ItemsController : public drogon::HttpController<ItemsController> {
public:
    METHOD_LIST_BEGIN
    METHOD_ADD(ItemsController::getItemsBySearchStr, "/items/get/search", drogon::Get, "JwtAuthFilter");
    METHOD_ADD(ItemsController::getItemsByID, "/items/get/id", drogon::Get, "JwtAuthFilter");
    METHOD_ADD(ItemsController::getCategories, "/items/get_categories", drogon::Get, "JwtAuthFilter");
    METHOD_ADD(ItemsController::addItem, "/items/add", drogon::Post, "JwtAuthFilter");
    METHOD_ADD(ItemsController::updateItem, "/items/update", drogon::Post, "JwtAuthFilter");
    METHOD_ADD(ItemsController::uploadImage, "/items/imageUpload", drogon::Post, "JwtAuthFilter");
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
};
