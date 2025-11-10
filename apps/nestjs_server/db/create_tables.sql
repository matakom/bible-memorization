-- =============================================
-- Database schema for Bible Memorization App
-- =============================================

-- =============================================
-- Users table
-- =============================================
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    daily_verse_streak INT NOT NULL DEFAULT 0,
    language VARCHAR(10) NOT NULL DEFAULT 'en',
    theme VARCHAR(20) NOT NULL DEFAULT 'light',
    registered_at TIMESTAMP NOT NULL DEFAULT NOW(),
    last_login_at TIMESTAMP
);

-- =============================================
-- Saved Verses table
-- =============================================
CREATE TABLE saved_verses (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    book VARCHAR(50) NOT NULL,
    chapter INT NOT NULL CHECK (chapter > 0),
    verse INT NOT NULL CHECK (verse > 0),
    translation VARCHAR(50) NOT NULL,
    next_review_date DATE,
    last_review_date DATE,
    difficulty SMALLINT DEFAULT 1 CHECK (difficulty BETWEEN 1 AND 5)
);

-- =============================================
-- Exercises table
-- =============================================
CREATE TABLE exercises (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    saved_verse_id INT NOT NULL REFERENCES saved_verses(id) ON DELETE CASCADE,
    duration_seconds INT NOT NULL CHECK (duration_seconds >= 0),
    performed_at TIMESTAMP NOT NULL DEFAULT NOW(),
    success BOOLEAN NOT NULL,
    exercise_type VARCHAR(50) NOT NULL
);

-- =============================================
-- Friendships table
-- =============================================
CREATE TABLE friendships (
    id SERIAL PRIMARY KEY,
    status VARCHAR(20) NOT NULL CHECK (status IN ('pending', 'accepted', 'rejected')),
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    friend_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_friendship UNIQUE (user_id, friend_id),
    CONSTRAINT no_self_friendship CHECK (user_id <> friend_id)
);

-- =============================================
-- Indexes for faster lookup
-- =============================================
CREATE INDEX idx_saved_verses_user_id ON saved_verses(user_id);
CREATE INDEX idx_exercises_user_id ON exercises(user_id);
CREATE INDEX idx_exercises_saved_verse_id ON exercises(saved_verse_id);
CREATE INDEX idx_friendships_user_id ON friendships(user_id);
CREATE INDEX idx_friendships_friend_id ON friendships(friend_id);
