#include <drogon/drogon.h>
#include "controllers/auth.h"
#include "controllers/items.h"


int main() {
    drogon::app()
        .addListener("0.0.0.0", 5556)
        .loadConfigFile("../config.json")
        .setUploadPath("./uploads") // Directory where files will be saved
        .setClientMaxBodySize(16 * 1024 * 1024) // 16 MB max body size
        .setClientMaxMemoryBodySize(1 * 1024 * 1024); // 1 MB in-memory limit

    // drogon::app().getDbClient()->execSqlSync(
    // R"sql(
    //         CREATE TABLE IF NOT EXISTS users (
    //             id INTEGER PRIMARY KEY AUTOINCREMENT,
    //             username TEXT UNIQUE NOT NULL,
    //             password TEXT NOT NULL
    //         );
    //         CREATE TABLE IF NOT EXISTS items (
    //             id INTEGER PRIMARY KEY AUTOINCREMENT,
    //             name TEXT NOT NULL,
    //             quantity INT NOT NULL,
    //             category TEXT,
    //             price FLOAT,
    //             imageURL TEXT,
    //             ownerUsername TEXT
    //         );
    //     )sql");

        drogon::app().run();



}
