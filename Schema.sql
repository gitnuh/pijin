-- ============================================================
-- SCHEMA: Smart Study Flashcards App (SQLite Version)
-- Features:
-- 1. User login & preference setup
-- 2. Manual flashcard entry
-- 3. Upload PDFs, images (OCR), audio (Speech-to-Text)
-- 4. AI-assisted flashcard & mnemonic generation
-- 5. Deck tagging with hashtags
-- 6. Study sessions / collaborative study rooms
-- ============================================================

PRAGMA foreign_keys = ON;

-- ========================
-- 1. USERS & PREFERENCES
-- ========================

CREATE TABLE users (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_login DATETIME
);

CREATE TABLE user_preferences (
    preference_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    theme TEXT DEFAULT 'light',
    language TEXT DEFAULT 'English',
    study_mode TEXT DEFAULT 'spaced_repetition',
    notifications_enabled INTEGER DEFAULT 1,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ========================
-- 2. FLASHCARD DECKS
-- ========================

CREATE TABLE decks (
    deck_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ========================
-- 3. FLASHCARDS
-- ========================

CREATE TABLE flashcards (
    card_id INTEGER PRIMARY KEY AUTOINCREMENT,
    deck_id INTEGER NOT NULL,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    mnemonic TEXT,
    is_ai_generated INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (deck_id) REFERENCES decks(deck_id) ON DELETE CASCADE
);

-- ========================
-- 4. FILE UPLOADS (PDFs / Images / Audio)
-- ========================

CREATE TABLE uploads (
    upload_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    file_type TEXT CHECK (file_type IN ('pdf', 'image', 'audio')),
    file_path TEXT NOT NULL,
    ocr_text TEXT,
    transcription TEXT,
    processed INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ========================
-- 5. AI-GENERATED CONTENT LINK
-- ========================

CREATE TABLE ai_generated_links (
    ai_id INTEGER PRIMARY KEY AUTOINCREMENT,
    upload_id INTEGER,
    flashcard_id INTEGER,
    generated_by TEXT DEFAULT 'AI Model v1',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (upload_id) REFERENCES uploads(upload_id) ON DELETE CASCADE,
    FOREIGN KEY (flashcard_id) REFERENCES flashcards(card_id) ON DELETE CASCADE
);

-- ========================
-- 6. TAGGING SYSTEM (Deck Hashtags)
-- ========================

CREATE TABLE tags (
    tag_id INTEGER PRIMARY KEY AUTOINCREMENT,
    tag_name TEXT NOT NULL UNIQUE
);

CREATE TABLE deck_tags (
    deck_id INTEGER NOT NULL,
    tag_id INTEGER NOT NULL,
    PRIMARY KEY (deck_id, tag_id),
    FOREIGN KEY (deck_id) REFERENCES decks(deck_id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(tag_id) ON DELETE CASCADE
);

-- ========================
-- 7. STUDY ROOMS & SESSIONS
-- ========================

CREATE TABLE study_rooms (
    room_id INTEGER PRIMARY KEY AUTOINCREMENT,
    room_name TEXT NOT NULL,
    created_by INTEGER,
    is_private INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE SET NULL
);

CREATE TABLE study_room_members (
    room_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    joined_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    role TEXT DEFAULT 'member',
    PRIMARY KEY (room_id, user_id),
    FOREIGN KEY (room_id) REFERENCES study_rooms(room_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE study_sessions (
    session_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    deck_id INTEGER,
    started_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    ended_at DATETIME,
    cards_reviewed INTEGER DEFAULT 0,
    correct_answers INTEGER DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (deck_id) REFERENCES decks(deck_id) ON DELETE CASCADE
);


-- ========================
-- END OF SCHEMA
-- ========================
