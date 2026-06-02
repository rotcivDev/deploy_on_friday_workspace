CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- PLAYERS
-- =====================================================

CREATE TABLE players (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    last_login_at TIMESTAMP
);

-- =====================================================
-- CLASSES
-- =====================================================

CREATE TABLE classes (
    id SERIAL PRIMARY KEY,

    name VARCHAR(100) UNIQUE NOT NULL,

    description TEXT NOT NULL,

    base_power_bonus INTEGER NOT NULL DEFAULT 0
);

-- =====================================================
-- PLAYER CLASS
-- =====================================================

CREATE TABLE player_classes (
    player_id UUID PRIMARY KEY REFERENCES players(id),
    class_id INTEGER NOT NULL REFERENCES classes(id)
);

-- =====================================================
-- CARD TYPES
-- =====================================================

CREATE TABLE card_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

-- Examples:
--
-- MONSTER
-- TREASURE
-- CURSE
-- EVENT
-- EQUIPMENT
-- PVP
-- AI
--

-- =====================================================
-- CARD DEFINITIONS
-- =====================================================

CREATE TABLE card_definitions (
    id SERIAL PRIMARY KEY,

    card_type_id INTEGER NOT NULL REFERENCES card_types(id),

    name VARCHAR(150) NOT NULL,

    description TEXT NOT NULL,

    power_bonus INTEGER DEFAULT 0,

    monster_power INTEGER DEFAULT 0,

    reward_levels INTEGER DEFAULT 0,

    reward_treasures INTEGER DEFAULT 0,

    rarity VARCHAR(20) DEFAULT 'COMMON',

    expansion VARCHAR(100) DEFAULT 'CORE',

    created_at TIMESTAMP DEFAULT NOW()
);

-- =====================================================
-- DECKS
-- =====================================================

CREATE TABLE decks (
    id SERIAL PRIMARY KEY,

    name VARCHAR(100) UNIQUE NOT NULL,

    description TEXT
);

-- =====================================================
-- DECK CARDS
-- =====================================================

CREATE TABLE deck_cards (
    deck_id INTEGER REFERENCES decks(id),
    card_definition_id INTEGER REFERENCES card_definitions(id),

    quantity INTEGER NOT NULL DEFAULT 1,

    PRIMARY KEY(deck_id, card_definition_id)
);

-- =====================================================
-- MATCHES
-- =====================================================

CREATE TABLE matches (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    status VARCHAR(30) NOT NULL,

    created_at TIMESTAMP DEFAULT NOW(),

    started_at TIMESTAMP,
    finished_at TIMESTAMP,

    winner_player_id UUID REFERENCES players(id)
);

-- =====================================================
-- MATCH PLAYERS
-- =====================================================

CREATE TABLE match_players (
    match_id UUID REFERENCES matches(id),

    player_id UUID REFERENCES players(id),

    final_level INTEGER DEFAULT 1,

    final_power INTEGER DEFAULT 0,

    placement INTEGER,

    PRIMARY KEY(match_id, player_id)
);

-- =====================================================
-- GAME EVENTS
-- =====================================================

CREATE TABLE game_events (
    id BIGSERIAL PRIMARY KEY,

    match_id UUID NOT NULL REFERENCES matches(id),

    event_type VARCHAR(100) NOT NULL,

    payload JSONB NOT NULL,

    created_at TIMESTAMP DEFAULT NOW()
);

-- =====================================================
-- ACHIEVEMENTS
-- =====================================================

CREATE TABLE achievements (
    id SERIAL PRIMARY KEY,

    name VARCHAR(100) UNIQUE NOT NULL,

    description TEXT NOT NULL
);

-- =====================================================
-- PLAYER ACHIEVEMENTS
-- =====================================================

CREATE TABLE player_achievements (
    player_id UUID REFERENCES players(id),

    achievement_id INTEGER REFERENCES achievements(id),

    unlocked_at TIMESTAMP DEFAULT NOW(),

    PRIMARY KEY(player_id, achievement_id)
);

-- =====================================================
-- RANKINGS
-- =====================================================

CREATE TABLE rankings (
    player_id UUID PRIMARY KEY REFERENCES players(id),

    wins INTEGER DEFAULT 0,

    losses INTEGER DEFAULT 0,

    matches_played INTEGER DEFAULT 0,

    highest_level INTEGER DEFAULT 1,

    current_rating INTEGER DEFAULT 1000
);

-- =====================================================
-- INVENTORY
-- =====================================================

CREATE TABLE player_cards (
    player_id UUID REFERENCES players(id),

    card_definition_id INTEGER REFERENCES card_definitions(id),

    quantity INTEGER DEFAULT 1,

    PRIMARY KEY(player_id, card_definition_id)
);

CREATE INDEX idx_events_match
ON game_events(match_id);

CREATE INDEX idx_events_payload
ON game_events
USING GIN(payload);
