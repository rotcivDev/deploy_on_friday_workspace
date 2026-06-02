# Systems Programming Refinement Spec: v0.1 Prototype

This document is the systems programming refinement specification for the **v0.1 Root Prototype**. It details the CMake/CTest build scaffolding, Makefile wrappers, and NCurses screen coordination patterns.

---

## 🛠️ 1. Compilation & Build Scaffolding

To compile with `-std=c17` and strict warning flags, we define a standard CMake build sequence.

### 📝 Recommended Root `CMakeLists.txt` Template
*(This file should be created by the user in the project root)*

```cmake
cmake_minimum_required(VERSION 3.16)
project(DungeonsAndDevs C)

set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

# Enforce strict warning boundaries
add_compile_options(-Wall -Wextra -Werror -pedantic)

# Find NCurses library
find_package(Curses REQUIRED)
include_directories(${CURSES_INCLUDE_DIR})

# Find PostgreSQL libpq (required by PostgreSQL repository adapter)
find_package(PostgreSQL REQUIRED)
include_directories(${PostgreSQL_INCLUDE_DIRS})

# Include directories
include_directories(domain)
include_directories(application)
include_directories(infrastructure)

# Domain Source files
set(DOMAIN_SRC
    domain/card.c
    domain/deck.c
    domain/player.c
    domain/game_rules.c
)

# Application Source files
set(APP_SRC
    application/game_service.c
    application/bot_ai.c
)

# Infrastructure Source files
set(INFRA_SRC
    infrastructure/db/postgresql_repository.c
)

# Client Target
add_executable(dungeon_client
    client/ncurses_ui.c
    ${DOMAIN_SRC}
    ${APP_SRC}
    ${INFRA_SRC}
)
target_link_libraries(dungeon_client ${CURSES_LIBRARIES} ${PostgreSQL_LIBRARIES})

# Enable CTest framework
enable_testing()

# Add a mock test target
add_executable(run_unit_tests
    testing/unit_tests.c
    ${DOMAIN_SRC}
    ${APP_SRC}
)
target_link_libraries(run_unit_tests ${PostgreSQL_LIBRARIES})
add_test(NAME CoreGameTests COMMAND run_unit_tests)
```

---

## ⚙️ 2. Makefile Wrapper (Dependency Installation & Run)

Following the user preference to use `make` for dependency installation and build commands, here is the recommended root `Makefile` wrapper.

### 📝 Recommended `Makefile` Template
*(This file should be created by the user in the project root)*

```makefile
.PHONY: all build test clean run setup-deps

all: build

setup-deps:
	@echo "Installing system dependencies..."
	sudo apt-get update && sudo apt-get install -y cmake build-essential libncurses5-dev libncursesw5-dev libpq-dev postgresql

build:
	mkdir -p build
	cd build && cmake .. && make

test: build
	cd build && ctest --output-on-failure

run: build
	./build/dungeon_client

clean:
	rm -rf build
```

---

## 📺 3. NCurses Multi-Panel GUI Architecture

To display multiple panels (Stats, Hand, Log, Bots, Arena) in the terminal cleanly, NCurses uses `WINDOW` structures. The client must isolate the screen updates into dedicated layout zones.

### NCurses Panel Structure Example (`client/ncurses_ui.c`)

```c
#include <ncurses.h>
#include <stdlib.h>

typedef struct {
    WINDOW* stats_win;
    WINDOW* arena_win;
    WINDOW* hand_win;
    WINDOW* log_win;
} ui_layout_t;

// Initialize screen and panels
ui_layout_t* ui_init() {
    initscr();
    cbreak();
    noecho();
    keypad(stdscr, TRUE);
    curs_set(0); // Hide physical cursor

    ui_layout_t* ui = malloc(sizeof(ui_layout_t));
    if (!ui) return NULL;

    int max_y, max_x;
    getmaxyx(stdscr, max_y, max_x);

    // Dynamic panel slice allocation
    ui->stats_win = newwin(6, max_x, 0, 0);                 // Top stats banner
    ui->arena_win = newwin(max_y - 14, max_x - 30, 6, 0);   // Center-left main arena
    ui->log_win = newwin(max_y - 14, 30, 6, max_x - 30);    // Center-right activity logs
    ui->hand_win = newwin(8, max_x, max_y - 8, 0);          // Bottom player hand

    // Enable drawing borders around panels
    box(ui->stats_win, 0, 0);
    box(ui->arena_win, 0, 0);
    box(ui->log_win, 0, 0);
    box(ui->hand_win, 0, 0);

    return ui;
}

void ui_refresh(ui_layout_t* ui) {
    wrefresh(ui->stats_win);
    wrefresh(ui->arena_win);
    wrefresh(ui->log_win);
    wrefresh(ui->hand_win);
}

void ui_cleanup(ui_layout_t* ui) {
    if (ui) {
        delwin(ui->stats_win);
        delwin(ui->arena_win);
        delwin(ui->log_win);
        delwin(ui->hand_win);
        free(ui);
    }
    endwin(); // Exit ncurses clean
}
```

---

## 🧪 4. CTest Unit Testing Guide

The testing execution needs to verify domain rule determinism without spinning up UI loops.
* Store test scripts in `testing/unit_tests.c`.
* Ensure that the entrypoint `main()` executes assertions on card drawing, level calculation, and combat results.
* Assertions should print failure reports and return a non-zero exit code on failure to alert CTest:

```c
#include <assert.h>
#include <stdio.h>
#include "player.h"

void test_combat_victory() {
    player_t p = { .level = 1, .base_power_bonus = 2 }; // Power = 3
    monster_t m = { .power = 2 };
    
    assert(resolve_combat(&p, &m) == COMBAT_WIN);
    printf("test_combat_victory PASSED\n");
}

int main() {
    test_combat_victory();
    return 0; // Success
}
```
