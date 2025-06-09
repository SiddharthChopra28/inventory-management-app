#include "items.h"
#include "Items.h"
#include <boost/uuid/uuid.hpp>
#include <boost/uuid/uuid_generators.hpp>
#include <boost/uuid/uuid_io.hpp>


void ItemsController::getItemsBySearchStr(const drogon::HttpRequestPtr& req,
                                          std::function<void(const drogon::HttpResponsePtr&)>&& callback)
{

    std::string searchStr = req->getParameter("searchString");

    auto dbClient = drogon::app().getDbClient();
    drogon::orm::Mapper<drogon_model::sqlite3::Items> itemMapper(dbClient);

    std::vector<drogon_model::sqlite3::Items> items;

    if (searchStr == "")
    {
        items = itemMapper.findAll();
    }
    else
    {
        std::string pattern = "%" + searchStr + "%";
        auto criteria = drogon::orm::Criteria("name", drogon::orm::CompareOperator::Like, pattern) ||
                        drogon::orm::Criteria("category", drogon::orm::CompareOperator::Like, pattern);

        items = itemMapper.findBy(criteria);
    }

    Json::Value result(Json::arrayValue);
    for (const auto& item : items) {
        result.append(item.toJson());
    }
    auto resp = drogon::HttpResponse::newHttpJsonResponse(result);
    callback(resp);

}


void ItemsController::getItemsByID(const drogon::HttpRequestPtr& req,
                                          std::function<void(const drogon::HttpResponsePtr&)>&& callback)
{

    std::string idStr = req->getParameter("id");
    int id;
    try
    {
        id = stoi(idStr);
    }
    catch (...)
    {
        auto resp = drogon::HttpResponse::newHttpResponse();
        resp->setStatusCode(drogon::k400BadRequest);
        resp->setBody("Invalid ID");
        callback(resp);
        return;
    }

    auto dbClient = drogon::app().getDbClient();
    drogon::orm::Mapper<drogon_model::sqlite3::Items> itemMapper(dbClient);

    auto item = itemMapper.findByPrimaryKey(id);

    auto resp = drogon::HttpResponse::newHttpJsonResponse(item.toJson());
    callback(resp);

}

void ItemsController::getCategories(const drogon::HttpRequestPtr& req,
                                          std::function<void(const drogon::HttpResponsePtr&)>&& callback)
{

    auto dbClient = drogon::app().getDbClient();
    drogon::orm::Mapper<drogon_model::sqlite3::Items> itemMapper(dbClient);

    auto items = itemMapper.findAll();

    Json::Value cats(Json::arrayValue);

    for (const auto &item: items)
    {
        auto cat = item.getValueOfCategory();
        if ((std::find(cats.begin(), cats.end(), cat) == cats.end()))
        {
            cats.append(cat);
        }
    }

    Json::Value newJson(Json::objectValue);
    newJson["categories"] = cats;

    auto resp = drogon::HttpResponse::newHttpJsonResponse(newJson);
    callback(resp);

}

void ItemsController::addItem(const drogon::HttpRequestPtr& req,
                                          std::function<void(const drogon::HttpResponsePtr&)>&& callback)
{

    auto dbClient = drogon::app().getDbClient();
    drogon::orm::Mapper<drogon_model::sqlite3::Items> itemMapper(dbClient);

    auto json = req->getJsonObject();

    drogon_model::sqlite3::Items newItem;

    newItem.setName((*json)["name"].asString());
    newItem.setQuantity((*json)["quantity"].asInt());
    newItem.setCategory((*json)["category"].asString());
    newItem.setPrice((*json)["price"].asFloat());
    newItem.setImageurl((*json)["imageURL"].asString());

    itemMapper.insert(newItem);

    auto resp = drogon::HttpResponse::newHttpResponse();
    callback(resp);

}

void ItemsController::updateItem(const drogon::HttpRequestPtr& req,
                                          std::function<void(const drogon::HttpResponsePtr&)>&& callback)
{

    auto dbClient = drogon::app().getDbClient();
    drogon::orm::Mapper<drogon_model::sqlite3::Items> itemMapper(dbClient);

    auto json = req->getJsonObject();

    int id = (*json)["id"].asInt();
    auto item = itemMapper.findByPrimaryKey(id);

    item.setName((*json)["name"].asString());
    item.setQuantity((*json)["quantity"].asInt());
    item.setCategory((*json)["category"].asString());
    item.setPrice((*json)["price"].asFloat());
    item.setImageurl((*json)["imageURL"].asString());

    itemMapper.update(item);

    auto resp = drogon::HttpResponse::newHttpResponse();
    callback(resp);

}

void ItemsController::uploadImage(const drogon::HttpRequestPtr& req, std::function<void(const drogon::HttpResponsePtr&)>&& callback)
{
    drogon::MultiPartParser fileUpload;
    int parseResult = fileUpload.parse(req);

    if (parseResult != 0) {
        auto resp = drogon::HttpResponse::newHttpResponse();
        resp->setStatusCode(drogon::k400BadRequest);
        resp->setBody("Failed to parse multipart request");
        callback(resp);
        return;
    }

    auto files = fileUpload.getFiles();
    if (files.empty()) {
        auto resp = drogon::HttpResponse::newHttpResponse();
        resp->setStatusCode(drogon::k400BadRequest);
        resp->setBody("No files uploaded");
        callback(resp);
        return;
    }

    for (auto& file : files) {
        boost::uuids::random_generator gen;
        boost::uuids::uuid uuid = gen();

        std::string file_ext = std::string(file.getFileExtension());

        auto filename = to_string(uuid) + file_ext;
        file.setFileName(filename);
        file.save();

        auto url = "http://localhost:5556/images/" + (to_string(uuid) + file_ext);

        auto resp = drogon::HttpResponse::newHttpResponse();
        resp->setStatusCode(drogon::k200OK);
        resp->setBody(url);
        callback(resp);

    }



}


