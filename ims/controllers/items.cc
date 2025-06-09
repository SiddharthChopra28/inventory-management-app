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
        items = itemMapper.findBy(drogon::orm::Criteria("ownerUsername", drogon::orm::CompareOperator::EQ, req->attributes()->get<std::string>("username")));
    }
    else
    {
        std::string pattern = "%" + searchStr + "%";
        auto criteria = drogon::orm::Criteria("ownerUsername", drogon::orm::CompareOperator::EQ, req->attributes()->get<std::string>("username")) && (drogon::orm::Criteria("name", drogon::orm::CompareOperator::Like, pattern) ||
                        drogon::orm::Criteria("category", drogon::orm::CompareOperator::Like, pattern));

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

    auto items = itemMapper.findBy(drogon::orm::Criteria("ownerUsername", drogon::orm::CompareOperator::EQ, req->attributes()->get<std::string>("username")));

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

    auto ownername = req->attributes()->get<std::string>("username");

    newItem.setOwnerusername(ownername);


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

    if (*item.getOwnerusername() != req->attributes()->get<std::string>("username"))
    {
        auto resp = drogon::HttpResponse::newHttpResponse();
        resp->setStatusCode(drogon::k403Forbidden);
        callback(resp);
    }

    item.setName((*json)["name"].asString());
    item.setQuantity((*json)["quantity"].asInt());
    item.setCategory((*json)["category"].asString());
    item.setPrice((*json)["price"].asFloat());
    item.setImageurl((*json)["imageURL"].asString());

    std::cout<<item.getQuantity();
    std::cout<<"helloo";

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

        auto filename = to_string(uuid) + '.' + file_ext;
        file.setFileName(filename);

        if (file.save("/home/siddharth/Documents/programs/android_apps/inventory_management_system/ims/uploads/")) { // 0 means error free
            auto error_resp = drogon::HttpResponse::newHttpResponse();
            error_resp->setStatusCode(drogon::k500InternalServerError);
            error_resp->setBody("Failed to save file");
            callback(error_resp);
            return;
        }


        std::cout<<"url"<< std::endl;
        auto url = "http://10.0.2.2:5556/images/" + filename;
        std::cout<<url<< std::endl;

        auto resp = drogon::HttpResponse::newHttpResponse();
        resp->setStatusCode(drogon::k200OK);
        resp->setBody(url);
        callback(resp);

    }
}

void ItemsController::downloadImage(const drogon::HttpRequestPtr &req,
               std::function<void(const drogon::HttpResponsePtr &)> &&callback,  std::string filename )
{
    // Specify the base directory for your files (adjust as needed)
    std::filesystem::path baseDir = "/home/siddharth/Documents/programs/android_apps/inventory_management_system/ims/uploads";
    std::filesystem::path fullPath = baseDir / filename;

    // Security: Prevent directory traversal by ensuring the file is within baseDir
    // Note: This is a simple check; for robust security, use canonical paths and validate
    if (!std::filesystem::exists(fullPath) || !is_regular_file(fullPath))
    {
        auto resp = drogon::HttpResponse::newHttpResponse();
        resp->setStatusCode(drogon::k404NotFound);
        callback(resp);
        return;
    }

    // Return the file as a response
    auto resp = drogon::HttpResponse::newFileResponse(fullPath.string(), filename);
    callback(resp);
}

