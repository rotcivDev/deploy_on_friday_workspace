# Database Architecture Refinement Spec: v0.1 Prototype

This document is the database design refinement specification for the **v0.1 Root Prototype**. It details the schema, the interface between the database adapter (`libpq`) and the Clean Architecture repositories, and provides guides for querying and seeding.

---

## 🗄️ 1. Database Schema Context

The database is built on the relational schema defined in **[01_schema.sql](file:///home/msratso/workspaces/c_dev/walkthrough/database/01_schema.sql)**. For the local prototype, the primary data access requirements are:
1. **Fetch Card Definitions**: Retrieve all card names, descriptions, power levels, and types from `card_definitions` and `card_types` to build the in-memory decks.
2. **Fetch Player Classes**: Retrieve starting class descriptions and power stats from the `classes` table.
3. **Manage Player Profiles**: Fetch and persist player levels, power, and class choices.

---

## 📐 2. Clean Architecture Interface: Repository Pattern

To preserve architectural decoupling, the game logic (`domain/` and `application/` layers) must not have direct dependencies on `libpq-fe.h` or SQL execution details. 

We recommend implementing an abstract **Repository Interface** in the application layer, and implementing it via a concrete database connector in the infrastructure layer.

### 📝 Example Interface: `domain/repositories/card_repository.h`
*(This header should be placed in the codebase by the user based on this design)*

```c
#ifndef CARD_REPOSITORY_H
#define CARD_REPOSITORY_H

#include <stddef.h>

// Domain Card Definition representation
typedef struct {
    int id;
    char name[150];
    char description[512];
    int power_bonus;
    int monster_power;
    int reward_levels;
    int reward_treasures;
    char card_type[50];
} db_card_t;

// Opaque context for database connection
typedef struct db_connection db_connection_t;

// Repository Operations
db_connection_t* db_connect(const char* conn_str);
void db_disconnect(db_connection_t* conn);

db_card_t* db_fetch_all_cards(db_connection_t* conn, size_t* out_count);
void db_free_cards(db_card_t* cards);

#endif // CARD_REPOSITORY_H
```

### 🛠️ Example Implementation Guideline: `infrastructure/db/postgresql_repository.c`
The systems programmer should implement the repository using `libpq`. Key operations mapping to `libpq` APIs:

```c
#include "card_repository.h"
#include <postgresql/libpq-fe.h>
#include <stdlib.h>
#include <string.h>

struct db_connection {
    PGconn* conn;
};

db_connection_t* db_connect(const char* conn_str) {
    db_connection_t* db = malloc(sizeof(db_connection_t));
    if (!db) return NULL;
    
    db->conn = PQconnectdb(conn_str);
    if (PQstatus(db->conn) != CONNECTION_OK) {
        // Log error and clean up
        PQfinish(db->conn);
        free(db);
        return NULL;
    }
    return db;
}

db_card_t* db_fetch_all_cards(db_connection_t* conn, size_t* out_count) {
    const char* query = "SELECT c.id, c.name, c.description, c.power_bonus, "
                        "c.monster_power, c.reward_levels, c.reward_treasures, t.name "
                        "FROM card_definitions c "
                        "JOIN card_types t ON c.card_type_id = t.id;";
                        
    PGresult* res = PQexec(conn->conn, query);
    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
        PQclear(res);
        return NULL;
    }

    int rows = PQntuples(res);
    *out_count = (size_t)rows;
    
    db_card_t* cards = malloc(sizeof(db_card_t) * rows);
    for (int i = 0; i < rows; i++) {
        cards[i].id = atoi(PQgetvalue(res, i, 0));
        strncpy(cards[i].name, PQgetvalue(res, i, 1), sizeof(cards[i].name) - 1);
        strncpy(cards[i].description, PQgetvalue(res, i, 2), sizeof(cards[i].description) - 1);
        cards[i].power_bonus = atoi(PQgetvalue(res, i, 3));
        cards[i].monster_power = atoi(PQgetvalue(res, i, 4));
        cards[i].reward_levels = atoi(PQgetvalue(res, i, 5));
        cards[i].reward_treasures = atoi(PQgetvalue(res, i, 6));
        strncpy(cards[i].card_type, PQgetvalue(res, i, 7), sizeof(cards[i].card_type) - 1);
    }

    PQclear(res);
    return cards;
}

void db_disconnect(db_connection_t* conn) {
    if (conn) {
        if (conn->conn) PQfinish(conn->conn);
        free(conn);
    }
}
```

---

## ⚙️ 3. Seeding & Local Execution Checklist

To test Epic 2, the systems programmer or developer should set up the local PostgreSQL cluster using the following steps:

1. **Spin up PostgreSQL local server**:
   ```bash
   initdb -D pgdata
   pg_ctl -D pgdata -l logfile start
   createdb dungeons_devs
   ```
2. **Apply Schemas**:
   Apply SQL files from `walkthrough/database/` in sequential order:
   ```bash
   psql -d dungeons_devs -f walkthrough/database/01_schema.sql
   psql -d dungeons_devs -f walkthrough/database/02_seed_core_data.sql
   psql -d dungeons_devs -f walkthrough/database/03_seed_cards.sql
   psql -d dungeons_devs -f walkthrough/database/04_seed_achievements.sql
   ```

---

## 📈 4. Performance & JSONB Indexing Guidance

For future expansions (such as recording game statistics and match history events in `game_events`), the schema configures JSONB logs:
* Event logs are stored in `game_events (payload JSONB)`.
* We enforce efficient queries on specific fields (e.g. searching player cards played) by applying a GIN index:
  ```sql
  CREATE INDEX idx_events_payload ON game_events USING GIN(payload);
  ```
* Guide: When query filters require looking inside the JSON document structure (e.g. `payload @> '{"action": "played_card"}'`), the query planner will leverage this GIN index instead of performing a full table scan.
