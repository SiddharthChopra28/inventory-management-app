#include <drogon/drogon.h>
int main() {
    drogon::app().addListener("0.0.0.0", 5556);
    drogon::app().loadConfigFile("../config.json");


    drogon::app().run();
    drogon::app().getDbClient()->execSqlSync(
        R"sql(
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT UNIQUE NOT NULL,
                password TEXT NOT NULL
            );
            CREATE TABLE IF NOT EXISTS items (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                quantity INT NOT NULL,
                category TEXT,
                price FLOAT,
                imageURL TEXT
            );
        )sql");

}
