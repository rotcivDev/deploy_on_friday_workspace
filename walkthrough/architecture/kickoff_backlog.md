# Kickoff Raw Backlog: v0.1 Root Prototype

This document defines the raw product backlog for the **v0.1 Root Prototype** of **Dungeon of Technical Debt** (Dungeons and Devs). It breaks down the requirements for creating a local, playable prototype running with an NCurses terminal interface, mock opponent bots, and PostgreSQL data integration.

---

## 📋 Epic List

* **Epic 1: Project Scaffolding & CMake Build**
* **Epic 2: Clean Architecture PostgreSQL Repository**
* **Epic 3: In-Memory Card & Deck Engine**
* **Epic 4: Turn Loop & Stats Engine**
* **Epic 5: Automated Mock Opponent Bots**
* **Epic 6: NCurses Multi-Panel CLI Layout**

---

## First Refinement Pass: Playable v0.1 Slice

The first implementation slice should prove the game loop before expanding the full card catalog, networking, accounts, or persistent match history. The v0.1 prototype is successful when one local human player and two deterministic mock bots can play a complete terminal match from Level 1 to Level 10 using seeded database cards, a shuffled in-memory deck, visible turn logs, and simple help/sabotage interactions.

### v0.1 Design Constraints

* **Player count**: 1 human player plus 2 mock bots.
* **Victory**: First character to reach Level 10 immediately wins.
* **Combat rule**: Player Power must be greater than or equal to Monster Power to win.
* **Base Power formula**: `Level + class base_power_bonus + equipment power_bonus + temporary modifiers`.
* **Influence**: Track as a stat in v0.1, but keep most Influence card interactions deferred unless already represented by seeded cards.
* **Randomness**: All shuffles and bot decisions must accept an explicit seed so playthroughs can be reproduced in tests.
* **Starting state**: Every player begins at Level 1, Influence 0, no equipment, 2 Encounter cards in hand, and 2 Treasure cards in hand.
* **Deck target**: Use the current seeded card set as the initial content floor; add only the minimum card links/quantities needed to build repeatable Encounter and Treasure draw piles.
* **Interaction target**: Bots may help or apply a simple sabotage modifier, but only through deterministic thresholds. Full PvP card play remains deferred unless seeded PvP cards are added.

### Suggested Build Order

1. R1 Seeded Content Smoke Test.
2. R2 Deterministic Encounter Deck.
3. R3 Deterministic Treasure Deck.
4. R4 First Combat Resolver.
5. R5 First Curse Resolvers.
6. R6 Bot Personality Baseline.
7. R7 Terminal Playtest Loop.

### Refined MVP Stories

#### R1. Seeded Content Smoke Test

As a developer,  
I want the prototype to verify that core classes, card types, monsters, equipment, AI cards, and curses exist in the database,  
So that gameplay failures are caught as content setup problems before the turn loop starts.

**Acceptance Criteria**
* Given the walkthrough seed SQL has been applied, when the prototype validates content, then it finds all seven card types: `MONSTER`, `TREASURE`, `CURSE`, `EVENT`, `EQUIPMENT`, `PVP`, and `AI`.
* Given the seeded classes, when the class list is loaded, then at least Backend Developer, Frontend Developer, DevOps Engineer, QA Engineer, Security Engineer, and AI Engineer are available.
* Given seeded cards, when deck construction starts, then the engine can classify Monster/AI cards as encounter threats, Curse cards as immediate encounters, and Equipment cards as treasure rewards.
* *Verification*: Repository/content test that fails with a readable missing-content message.

**Design Notes**
* This story prevents the early prototype from silently starting with an empty deck.
* AI cards in v0.1 may behave like monsters unless a specific AI rule resolver is later added.

#### R2. Deterministic Encounter Deck

As a game engine,  
I want a reproducible Encounter deck made from monsters, AI threats, and curses,  
So that the "Kick Open The Backlog" phase can be tested without networking or manual setup.

**Acceptance Criteria**
* Given loaded cards and a fixed seed, when the Encounter deck is built and shuffled, then repeated test runs produce the same draw order.
* Given a Monster or AI threat is drawn, when it is revealed, then combat begins with the card's configured `monster_power`, `reward_levels`, and `reward_treasures`.
* Given a Curse is drawn, when it is revealed, then it resolves immediately and moves to discard.
* Given the Encounter deck is empty, when a draw is requested, then the Encounter discard pile is reshuffled into a new draw pile using the active RNG seed stream.
* *Verification*: Unit test with fixed seed and card-count assertions.

**Design Notes**
* Encounter deck candidates for v0.1: `Null Pointer Exception`, `Legacy Monolith`, `Production Outage`, `The Singularity`, `Hallucinated Function`, `Infinite Agent Loop`, `Autonomous Junior Developer`, `Broken CI`, `Scope Creep`, and `Context Window Exceeded`.
* The Singularity should remain rare and dangerous. Use a low quantity or place it late in dedicated scripted tests so it does not dominate every early playtest.

#### R3. Deterministic Treasure Deck

As a game engine,  
I want a reproducible Treasure deck made from equipment rewards,  
So that winning combat produces visible long-term progression.

**Acceptance Criteria**
* Given loaded equipment cards and a fixed seed, when the Treasure deck is built and shuffled, then repeated test runs produce the same draw order.
* Given a player wins combat with `reward_treasures > 0`, when rewards are resolved, then that many Treasure cards are drawn into the player's hand.
* Given a player equips a card, when Power is recalculated, then the equipment's `power_bonus` is included.
* Given a Treasure deck is empty, when a reward draw is requested, then the Treasure discard pile is reshuffled into the draw pile.
* *Verification*: Unit test proving reward draw count, hand count, and Power changes.

**Design Notes**
* Initial equipment target: `ThinkPad`, `Linux Mastery`, `PostgreSQL Expertise`, and `Emacs Mastery`.
* Do not add equipment slot limits in the first refinement unless the hand/equipment system becomes trivial to exploit during playtest.

#### R4. First Combat Resolver

As a player,  
I want monster fights to resolve consistently using Level, class bonus, equipment, and temporary modifiers,  
So that progression feels fair and debuggable.

**Acceptance Criteria**
* Given Player Power is greater than or equal to Monster Power, when combat resolves, then the player wins.
* Given a win, when rewards are applied, then the player gains the configured levels and treasure draws.
* Given a loss, when bad stuff is applied, then the prototype applies a deterministic fallback penalty if the card has no custom bad-stuff resolver.
* Given a player reaches Level 10 from combat rewards, when the reward step completes, then the match ends immediately.
* *Verification*: Scripted combat tests for win, loss, and Level 10 victory.

**Design Notes**
* Default bad stuff for v0.1: lose 1 Level, minimum Level 1.
* `Production Outage` can remain a high-power midgame threat; `The Singularity` is an endgame boss and should not be expected to be defeated early.
* Keep rule callbacks simple and named by card identity or rule key. Avoid hidden random penalties during the first prototype.

#### R5. First Curse Resolvers

As a player,  
I want curses to create immediate, readable setbacks,  
So that the Encounter deck is not only combat.

**Acceptance Criteria**
* Given `Broken CI` is drawn, when it resolves, then the affected player skips their next combat opportunity and the next revealed monster is discarded without rewards.
* Given `Scope Creep` is drawn, when it resolves, then the next monster fought by that player gains +5 temporary Power.
* Given `Context Window Exceeded` is drawn, when it resolves, then the affected player discards half their hand rounded down.
* Given a curse has resolved, when the game log updates, then the player can see the curse name and effect summary.
* *Verification*: Unit tests for each seeded curse resolver.

**Design Notes**
* Curse state should be explicit and short-lived: `skip_next_combat` and `next_monster_power_bonus` are enough for v0.1.
* Do not create stacking technical-debt systems yet; that belongs in a later balance pass.

#### R6. Bot Personality Baseline

As a solo player,  
I want bots to behave predictably but not passively,  
So that local playtests exercise cooperation and sabotage.

**Acceptance Criteria**
* Given a bot has equipment in hand, when its turn reaches the play/equip step, then it equips the highest Power item available.
* Given a bot is in combat and can win, when combat resolves, then it fights without asking for help.
* Given a bot is losing by 3 Power or less, when help is available, then it requests help from the strongest non-active player.
* Given the human player is in combat and would win by 2 Power or less, when a bot sabotage check passes, then the bot applies a simple temporary +2 Monster Power modifier for v0.1.
* Given all bot choices use the match seed, when the same match is replayed, then bot choices repeat.
* *Verification*: Simulation test where a full seeded match completes without manual input.

**Design Notes**
* Bot names for the first prototype: `Legacy Maintainer` and `Prompt Intern`.
* Bot behavior should be intentionally simple. The goal is to exercise game states, not create a clever opponent yet.
* Card-driven PvP sabotage should wait until PvP cards are seeded and rule keys exist.

#### R7. Terminal Playtest Loop

As a player,  
I want the NCurses UI to show only the decisions needed for the current phase,  
So that the first playable build is understandable in a terminal.

**Acceptance Criteria**
* Given it is the human player's turn, when the Start Turn phase begins, then the UI shows current Level, Power, Influence, hand size, equipment, bot summaries, and recent log entries.
* Given the player kicks open the backlog, when an encounter appears, then the Battle Area displays card name, type, Power if relevant, rewards, and active modifiers.
* Given the player has playable equipment in hand, when the Play/Equip step is available, then the UI allows selecting a card by stable menu index.
* Given a bot takes an action, when the action resolves, then the game log records the bot action in plain language.
* *Verification*: Manual playtest checklist plus one non-interactive render smoke test if feasible.

**Design Notes**
* Favor clarity over decoration in v0.1. The joke should come from card names and logs, not from a crowded layout.
* Suggested log tone: short satirical messages such as `Prompt Intern equipped ThinkPad. Finally, a real machine.`

### Deferred From First Refinement

* Real multiplayer sockets and server/client synchronization.
* Persistent accounts, rankings, achievements, and match history.
* Trading and negotiation beyond simple help requests.
* Full equipment slot rules.
* Complex class-specific abilities beyond base Power bonuses.
* Deep Influence economy.
* Large card expansion, rarity balancing, and AI-specific chain reactions.
* Spectator mode, reconnect support, and production deployment concerns.

---

## Architecture Refinement Pass: Clean v0.1 Boundaries

The v0.1 prototype is local and NCurses-driven, but it should still be shaped like the later server-authoritative game. The terminal UI should submit player intentions, the application layer should coordinate use cases, the domain layer should own game state and rules, and infrastructure should be the only layer that knows about PostgreSQL, `libpq`, terminal libraries, files, or operating-system details.

### Dependency Rule For v0.1

```text
client/ncurses
    -> application/use_cases
        -> domain/model + domain/rules
        -> application/ports
            <- infrastructure/postgresql
            <- infrastructure/random
```

* **Domain**: Pure C17 game model, value types, rule functions, deterministic state transitions, and invariant checks.
* **Application**: Match setup, turn orchestration, bot orchestration, input-command handling, repository ports, and output snapshots.
* **Infrastructure**: PostgreSQL queries, seeded content loading, random seed source, persistence adapters, and any future socket adapter.
* **Client**: NCurses rendering and keyboard input only. It must not calculate combat outcomes, mutate match state directly, or query PostgreSQL.
* **Shared**: Defer protocol structs until v0.2 networking unless a type is genuinely needed by both client and server.

### Architectural Guardrails

* Domain headers must not include `libpq-fe.h`, `ncurses.h`, POSIX socket headers, or application service headers.
* Application services may call domain functions and application ports, but must not issue SQL or render terminal panels.
* Infrastructure adapters must convert database rows into application/domain data structures before returning data.
* Client code receives read-only snapshots or copied view models from application services.
* All match mutations go through explicit application commands such as start match, kick backlog, play card, equip card, request help, resolve bot turn, and end turn.
* Every command result should include both updated state and log events so the UI does not need to infer what happened.
* Allocation ownership must be written into each public header: creator allocates, caller frees, borrowed views are marked `const`, and adapter-returned lists have matching free functions.

### Refined Architecture Stories

#### A1. Layered Build Targets

As a developer,  
I want separate build targets for domain, application, infrastructure, and client modules,  
So that forbidden dependencies fail early instead of spreading through the codebase.

**Acceptance Criteria**
* Given the CMake project is configured, when domain sources are compiled, then they only link against the C standard library.
* Given application sources are compiled, when they include headers, then they may include domain and application port headers but not PostgreSQL or NCurses headers.
* Given infrastructure sources are compiled, when PostgreSQL support is enabled, then only the infrastructure target links `libpq`.
* Given client sources are compiled, when NCurses support is enabled, then only the client target links NCurses.
* *Verification*: Build target review plus a dependency smoke test that fails if forbidden headers are included in domain/application.

**Design Notes**
* Suggested targets: `dtd_domain`, `dtd_application`, `dtd_infrastructure_db`, `dtd_client_ncurses`, and `dtd_tests`.
* Keep the first CMake setup small, but preserve target boundaries from day one.

#### A2. Domain Model Boundary

As a developer,  
I want pure domain structures for cards, decks, players, matches, turns, and rule results,  
So that game rules can be tested without PostgreSQL, NCurses, or future networking.

**Acceptance Criteria**
* Given a domain test creates a match from in-memory card and class definitions, when turns are resolved, then no database or UI dependency is required.
* Given a player stat changes, when invariants are checked, then Level cannot fall below 1 and cannot exceed 10.
* Given Power is recalculated, when equipment and temporary modifiers are applied, then the formula is deterministic and side-effect free.
* Given a rule function returns a result, when application receives it, then the result includes enough event data to describe the outcome in the log.
* *Verification*: Pure unit tests for match creation, Power calculation, Level bounds, and combat resolution.

**Design Notes**
* Domain rule functions should prefer explicit inputs and output structs over hidden global state.
* Do not put SQL IDs at the center of rule logic. A card may carry a stable definition id for lookup, but rules should operate on card properties and rule keys.

#### A3. Application Ports For Content Loading

As a developer,  
I want repository ports declared at the application boundary,  
So that the game service can load cards and classes without depending on PostgreSQL.

**Acceptance Criteria**
* Given the application starts a local match, when it needs card and class definitions, then it calls a content repository port.
* Given tests run without PostgreSQL, when a fake repository is provided, then the same match setup use case can execute.
* Given infrastructure implements the port, when database rows are fetched, then `libpq` types do not escape the infrastructure adapter.
* Given repository calls fail, when the application receives the error, then it returns a startup failure instead of constructing an empty match.
* *Verification*: Application test using a fake content repository and infrastructure test for PostgreSQL row mapping.

**Design Notes**
* Prefer an application port such as `content_repository` over a domain-level `db_connection`.
* The port should return content definitions, not database connection handles.
* This refines the earlier `domain/repositories/card_repository.h` suggestion: keep pure data definitions accessible to domain/application, but keep connection lifecycle and SQL details in infrastructure.

#### A4. Match Service Command Boundary

As a player,  
I want each UI action to map to a small application command,  
So that validation and state mutation remain server-authoritative even in the local prototype.

**Acceptance Criteria**
* Given the NCurses UI captures a key press, when the player selects an action, then the UI sends a command to the application service instead of mutating match state directly.
* Given a command is invalid for the current phase, when the application handles it, then it returns an error result and leaves match state unchanged.
* Given a command succeeds, when the application handles it, then it returns a state snapshot and ordered log events.
* Given bot turns are resolved, when application invokes bot logic, then bot commands pass through the same validation path as human commands.
* *Verification*: Command tests for valid action, invalid phase, state unchanged on failure, and bot command parity.

**Design Notes**
* Useful first commands: `START_LOCAL_MATCH`, `KICK_BACKLOG`, `EQUIP_CARD`, `PLAY_CARD`, `REQUEST_HELP`, `RESOLVE_COMBAT`, `END_TURN`, and `RESOLVE_BOT_TURN`.
* This command boundary becomes the natural network protocol boundary in v0.2.

#### A5. Snapshot-Based UI Boundary

As a developer,  
I want the NCurses client to render snapshots instead of owning game state,  
So that the UI remains replaceable and cannot drift from authoritative rules.

**Acceptance Criteria**
* Given the match state changes, when the application returns a snapshot, then the UI renders only data present in that snapshot.
* Given the UI displays a hand, when the player selects an item, then the UI sends the stable card instance/index supplied by the snapshot.
* Given combat is active, when the UI displays Power and rewards, then those values come from the application snapshot rather than local recalculation.
* Given the terminal is resized or redrawn, when rendering repeats, then no domain mutation occurs.
* *Verification*: UI smoke test using a static snapshot and application tests proving snapshots reflect state after commands.

**Design Notes**
* Snapshot fields should be compact: active player, phase, player summaries, visible encounter, hand view, equipment view, available actions, and recent log entries.
* The UI can format text, but it should not decide game legality.

#### A6. Deterministic Randomness Boundary

As a developer,  
I want randomness isolated behind an explicit seedable component,  
So that shuffles, bot choices, and simulations are reproducible.

**Acceptance Criteria**
* Given a match starts with seed `S`, when decks are shuffled and bots make choices, then repeated runs produce the same ordered events.
* Given domain rules need a random value, when they execute, then the value is passed in or produced by an injected RNG owned by application state.
* Given tests provide a fixed RNG sequence, when edge cases are simulated, then outcomes are stable.
* Given the UI starts a casual local game, when no seed is supplied, then application creates a seed and records it in the match log.
* *Verification*: Full-match simulation with fixed seed and identical event transcript.

**Design Notes**
* Avoid calls to `rand()` inside rule functions.
* Store the active seed and RNG state in the match/application state so bugs can be replayed.

#### A7. Error And Event Result Shape

As a developer,  
I want command results to use explicit status codes and event logs,  
So that the prototype is debuggable without mixing UI text into rules.

**Acceptance Criteria**
* Given a command succeeds, when the application returns, then the result includes status success, updated snapshot, and zero or more domain events.
* Given a command fails, when the application returns, then the result includes a typed error and does not require the UI to inspect internal state.
* Given a combat or curse resolves, when events are emitted, then each event has a stable type and structured payload.
* Given the UI renders logs, when it receives events, then it may format them into player-facing text without changing their meaning.
* *Verification*: Command result tests for success, invalid action, repository failure, and event ordering.

**Design Notes**
* Early event types: `MATCH_STARTED`, `TURN_STARTED`, `CARD_DRAWN`, `CURSE_RESOLVED`, `COMBAT_STARTED`, `COMBAT_WON`, `COMBAT_LOST`, `CARD_EQUIPPED`, `BOT_ACTION`, and `MATCH_ENDED`.
* Event payloads can be simple structs in v0.1; JSONB persistence can be added later by infrastructure.

#### A8. Memory Ownership Contract

As a C17 developer,  
I want every public interface to state allocation and ownership rules,  
So that the prototype avoids leaks, double frees, and dangling pointers as modules split apart.

**Acceptance Criteria**
* Given a create/init function allocates memory, when the caller is done, then a matching destroy/free function exists.
* Given a function returns borrowed state, when the pointer is exposed, then it is `const` and documented as invalid after the next mutation.
* Given infrastructure returns loaded content arrays, when application consumes them, then ownership transfer and cleanup are explicit.
* Given tests run under a leak checker where available, when match simulations complete, then no reachable allocations remain from match/deck/player lifecycle.
* *Verification*: Header review checklist plus lifecycle tests for match creation/destruction and repository result cleanup.

**Design Notes**
* Prefer opaque structs for long-lived services and clear value structs for small domain data.
* Avoid returning pointers into resizable internal buffers unless the lifetime is very clearly constrained.

### Architecture Deferred From v0.1

* TCP server process and packet routing.
* Shared binary protocol structs.
* Authentication, matchmaking, rankings, and account persistence.
* PostgreSQL match-event persistence beyond optional adapter tests.
* Threading and connection pooling.
* Reconnect support and client/server state reconciliation.

---

## 🛠️ Epic 1: Project Scaffolding & CMake Build
*   **Outcome**: Compilation environment configured with CMake, wrapped in a Makefile, and integrated with CTest.
*   **Scope**: Project folder structure (`domain/`, `application/`, `infrastructure/`, `client/`, `shared/`), CMake configuration, Makefile wrapper, and dummy test case.
*   **Out of scope**: Network server/client sockets (deferred to v0.2).
*   **Dependencies**: Local C toolchain, CMake.
*   **Risks**: Cross-platform differences in GCC versions or flags.

### User Story
As a developer,  
I want a clean C17 build system and folder hierarchy,  
So that I can compile files cleanly and execute unit tests reliably.

### Acceptance Criteria
*   Given a clean workspace, when I run `make build`, then the project compiles with `-std=c17` and flags `-Wall -Wextra -Werror -pedantic`.
*   Given compiled binaries, when I run `make test`, then the unit tests execute via CTest and output status.
*   *Verification*: Run `make build` and `make test` from terminal.

### Implementation Notes
*   **Suggested layer**: Root level `CMakeLists.txt` and `Makefile`.
*   **Data impact**: None.
*   **Protocol impact**: None.
*   **Test impact**: Introduce initial test runner.

---

## 🗄️ Epic 2: Clean Architecture PostgreSQL Repository
*   **Outcome**: Data-driven cards and classes retrieved dynamically from a local PostgreSQL database.
*   **Scope**: Application-layer content repository port (`application/ports/`), infrastructure database adapter using `libpq` (`infrastructure/db/`), row-to-domain mapping, and schema loading.
*   **Out of scope**: Connection pooling, dynamic cloud deployments.
*   **Dependencies**: PostgreSQL client library (`libpq`), configured local PostgreSQL database initialized with the walkthrough SQL scripts.
*   **Risks**: DB connections blocking or failing due to local configuration errors.

### User Story
As a player,  
I want my game classes and cards to load from the PostgreSQL database,  
So that the card rules, stats, and metadata are data-driven rather than hardcoded.

### Acceptance Criteria
*   Given an initialized PostgreSQL database with seeded card definitions, when the prototype starts, then the infrastructure adapter connects via `libpq` and the application service receives card types and cards through the content repository port.
*   Given active classes in the database, when a player selects a class, then the application service receives its description and base power bonuses without exposing database connection details.
*   *Verification*: Database fetch tests comparing loaded in-memory data to table records.

### Implementation Notes
*   **Suggested layer**: `application/ports/content_repository.h`, `infrastructure/db/postgresql_content_repository.c`.
*   **Data impact**: Direct queries on `card_definitions`, `classes`, and `card_types`.
*   **Protocol impact**: None.
*   **Test impact**: Mock tests and local database retrieval validation.

---

## 🎴 Epic 3: In-Memory Card & Deck Engine
*   **Outcome**: In-memory management of cards, including drawing, shuffling, and discarding.
*   **Scope**: Card structure representations, Deck buffers, shuffling algorithm (Fisher-Yates), discard piles, draw queues, and configured deck quantities from loaded content.
*   **Out of scope**: Distributed card synchronization over networking (deferred to v0.2).
*   **Dependencies**: Database repository data fetch (Epic 2).
*   **Risks**: Memory leaks on dynamic card allocations.

### User Story
As a game engine,  
I want to manage card decks, shuffle them, and handle draws/discards,  
So that the card game rules can progress randomly and fairly.

### Acceptance Criteria
*   Given a deck built from configured card quantities, when I call `deck_shuffle()`, then the cards are randomly ordered using a seed.
*   Given a deck, when a player draws a card, then the deck size decreases by 1 and the card is added to the player's hand.
*   Given an empty deck, when a draw is requested, then the discard pile is shuffled back into the draw deck.
*   *Verification*: CTest unit testing verifying shuffle randomness and card counts.

### Implementation Notes
*   **Suggested layer**: `domain/deck.c`, `domain/card.c`.
*   **Data impact**: Loads data into structures representing cards.
*   **Protocol impact**: None.
*   **Test impact**: Shuffling and draw-count state assertions.

---

## 🔄 Epic 4: Turn Loop & Stats Engine
*   **Outcome**: Deterministic game engine handling the turn phases, card battles, stats, and rule effects.
*   **Scope**: Core turn steps (Start Turn -> Backlog Draw -> Battle/Resolution -> Play cards/Equipment -> End Turn), player stats (Level, Power, Influence), hardcoded callback resolvers for card rules.
*   **Out of scope**: Multiplayer networking, complex trading mechanics.
*   **Dependencies**: Card engine (Epic 3), DB integration (Epic 2).
*   **Risks**: Complex gameplay edge cases causing invalid states (e.g. negative levels or power overflows).

### User Story
As a player,  
I want to take turns, play equipment cards, fight monsters, and face curses,  
So that I can level up to Level 10 and try to win the game.

### Acceptance Criteria
*   Given the start of a turn, when the player "kicks open the backlog" (draws an encounter), then it resolves immediately if it is a Curse, or triggers combat if it is a Monster.
*   Given a combat phase, when the player's Power is equal to or greater than the monster's Power, then the player wins, gains the configured reward levels, and draws the configured Treasure cards.
*   Given a combat phase, when the player's Power is lower than the monster's, then the player loses and suffers the "Bad Stuff" listed on the card.
*   Given a Curse (e.g., "Context Window Exceeded"), when drawn, then the engine executes its callback (e.g. discarding half of the player's hand).
*   *Verification*: Unit tests simulating sequential mock matches and asserting player stats.

### Implementation Notes
*   **Suggested layer**: `domain/game_rules.c`, `domain/player.c`, `application/game_service.c`.
*   **Data impact**: Reads card rules metadata.
*   **Protocol impact**: None.
*   **Test impact**: Automated gameplay turn scripts asserting Level and Power tracking.

---

## 🤖 Epic 5: Automated Mock Opponent Bots
*   **Outcome**: Automated computer-controlled bots to play alongside the player locally.
*   **Scope**: Basic AI decision state machine (e.g., bot decides to equip items, help or sabotage the player, or fight monsters using simple thresholds).
*   **Out of scope**: Advanced neural network or LLM integration (pure rule-based decisions).
*   **Dependencies**: Turn Loop engine (Epic 4).
*   **Risks**: Bots getting stuck in infinite choice loops or blocking turn transitions.

### User Story
As a solo player,  
I want computer-controlled bots to take turns and interact during my combat,  
So that I can test the multiplayer aspects of helping/sabotaging without networking code.

### Acceptance Criteria
*   Given a bot's turn, when the bot kicks open the backlog, then the bot automatically resolves combat or suffers bad stuff.
*   Given the player's combat, when the bot holds a sabotage card, then there is a probability the bot plays it to increase the monster's power.
*   Given a game state, when a bot reaches Level 10, then the game declares the bot the winner and halts.
*   *Verification*: Simulation test verifying that a bot-driven match completes from start to finish.

### Implementation Notes
*   **Suggested layer**: `application/bot_ai.c`.
*   **Data impact**: Fetches default player metrics.
*   **Protocol impact**: None.
*   **Test impact**: Full simulation test suite.

---

## 📺 Epic 6: NCurses Multi-Panel CLI Layout
*   **Outcome**: Immersive and structured multi-panel terminal display using the NCurses library.
*   **Scope**: NCurses initialization, panel rendering (Header stats panel, Battle Arena panel, player hand inventory panel, bots overview panel, game log/feed panel), and keyboard menu inputs.
*   **Out of scope**: GUI/web interface (console NCurses layout only).
*   **Dependencies**: Turn Loop engine (Epic 4), NCurses package.
*   **Risks**: Terminal resize crashes, incorrect panel drawing overlap.

### User Story
As a player,  
I want a structured multi-window terminal screen that shows my stats, hand, combat, logs, and bot states simultaneously,  
So that I can play the game easily with visual updates instead of scrolling terminal text.

### Acceptance Criteria
*   Given a game start, when the NCurses UI loads, then it displays panels for Stats, Hand, Battle Area, Log Feed, and Bot Status.
*   Given a turn update, when stats or hand sizes change, then the respective panels refresh instantly to show current values.
*   Given menu prompts, when the user naviges with arrow keys or numbers, then the selected action resolves in the game engine.
*   *Verification*: Manual interactive playtest verifying UI responsiveness and crash-free resizing.

### Implementation Notes
*   **Suggested layer**: `client/ncurses_ui.c`.
*   **Data impact**: Reads game stats and log payloads.
*   **Protocol impact**: None.
*   **Test impact**: Manual visualization verification checks.
