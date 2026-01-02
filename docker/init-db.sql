-- ═══════════════════════════════════════════════════════════════════════════════
-- Agents Squads - Database Schema
-- ═══════════════════════════════════════════════════════════════════════════════

-- Create schema
CREATE SCHEMA IF NOT EXISTS squads;

-- ─────────────────────────────────────────────────────────────────────────────────
-- Squads & Agents
-- ─────────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS squads.squads (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    mission TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS squads.agents (
    id SERIAL PRIMARY KEY,
    squad_id INTEGER REFERENCES squads.squads(id),
    name VARCHAR(100) NOT NULL,
    purpose TEXT,
    model VARCHAR(50) DEFAULT 'claude-sonnet-4',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(squad_id, name)
);

-- ─────────────────────────────────────────────────────────────────────────────────
-- Goals
-- ─────────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS squads.goals (
    id SERIAL PRIMARY KEY,
    squad_id INTEGER REFERENCES squads.squads(id),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(20) DEFAULT 'active', -- active, completed, cancelled
    priority INTEGER DEFAULT 1,          -- 0=P0, 1=P1, 2=P2
    progress INTEGER DEFAULT 0,          -- 0-100
    due_date DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    completed_at TIMESTAMP WITH TIME ZONE
);

-- ─────────────────────────────────────────────────────────────────────────────────
-- Memory
-- ─────────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS squads.memory (
    id SERIAL PRIMARY KEY,
    squad_id INTEGER REFERENCES squads.squads(id),
    agent_id INTEGER REFERENCES squads.agents(id),
    key VARCHAR(255) NOT NULL,
    value JSONB NOT NULL,
    embedding VECTOR(1536),  -- For semantic search (requires pgvector)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX IF NOT EXISTS idx_memory_squad ON squads.memory(squad_id);
CREATE INDEX IF NOT EXISTS idx_memory_key ON squads.memory(key);

-- ─────────────────────────────────────────────────────────────────────────────────
-- Executions
-- ─────────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS squads.executions (
    id SERIAL PRIMARY KEY,
    squad_id INTEGER REFERENCES squads.squads(id),
    agent_id INTEGER REFERENCES squads.agents(id),
    goal_id INTEGER REFERENCES squads.goals(id),
    status VARCHAR(20) DEFAULT 'running', -- running, completed, failed
    model VARCHAR(50),
    input_tokens INTEGER DEFAULT 0,
    output_tokens INTEGER DEFAULT 0,
    cost_usd NUMERIC(10, 4) DEFAULT 0,
    duration_ms INTEGER,
    error TEXT,
    started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    completed_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX IF NOT EXISTS idx_executions_squad ON squads.executions(squad_id);
CREATE INDEX IF NOT EXISTS idx_executions_started ON squads.executions(started_at);

-- ─────────────────────────────────────────────────────────────────────────────────
-- Dashboard Snapshots
-- ─────────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS squads.dashboard_snapshots (
    id SERIAL PRIMARY KEY,
    captured_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    total_squads INTEGER,
    total_agents INTEGER,
    total_commits INTEGER,
    total_prs_merged INTEGER,
    cost_usd NUMERIC(10, 4),
    squads_data JSONB,
    goals_data JSONB,
    metrics_data JSONB
);

-- ─────────────────────────────────────────────────────────────────────────────────
-- Cost Tracking
-- ─────────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS squads.costs (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    squad_id INTEGER REFERENCES squads.squads(id),
    model VARCHAR(50),
    input_tokens BIGINT DEFAULT 0,
    output_tokens BIGINT DEFAULT 0,
    cost_usd NUMERIC(10, 4) DEFAULT 0,
    executions INTEGER DEFAULT 0,
    UNIQUE(date, squad_id, model)
);

CREATE INDEX IF NOT EXISTS idx_costs_date ON squads.costs(date);

-- ─────────────────────────────────────────────────────────────────────────────────
-- Feedback
-- ─────────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS squads.feedback (
    id SERIAL PRIMARY KEY,
    execution_id INTEGER REFERENCES squads.executions(id),
    squad_id INTEGER REFERENCES squads.squads(id),
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ─────────────────────────────────────────────────────────────────────────────────
-- Views
-- ─────────────────────────────────────────────────────────────────────────────────

CREATE OR REPLACE VIEW squads.daily_costs AS
SELECT
    date,
    SUM(cost_usd) as total_cost,
    SUM(input_tokens) as total_input_tokens,
    SUM(output_tokens) as total_output_tokens,
    SUM(executions) as total_executions
FROM squads.costs
GROUP BY date
ORDER BY date DESC;

CREATE OR REPLACE VIEW squads.squad_summary AS
SELECT
    s.id,
    s.name,
    s.mission,
    COUNT(DISTINCT a.id) as agent_count,
    COUNT(DISTINCT g.id) FILTER (WHERE g.status = 'active') as active_goals,
    COALESCE(SUM(c.cost_usd), 0) as total_cost
FROM squads.squads s
LEFT JOIN squads.agents a ON a.squad_id = s.id
LEFT JOIN squads.goals g ON g.squad_id = s.id
LEFT JOIN squads.costs c ON c.squad_id = s.id
GROUP BY s.id, s.name, s.mission;
