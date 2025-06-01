-- Create modules table
CREATE TABLE modules (
    module_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    status VARCHAR(20) CHECK (status IN ('active', 'inactive', 'error', 'maintenance')) NOT NULL DEFAULT 'inactive',
    ip_port VARCHAR(21) NOT NULL,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create images table
CREATE TABLE images (
    module_id UUID PRIMARY KEY,
    image_file BYTEA,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create users table
CREATE TABLE users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role VARCHAR(20) CHECK (role IN ('user', 'admin', 'developer', 'moderator')) NOT NULL DEFAULT 'user',
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(512) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create settings table
CREATE TABLE settings (
    s_key VARCHAR(255) PRIMARY KEY,
    s_value TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_modules_updated_at BEFORE UPDATE ON modules
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_images_updated_at BEFORE UPDATE ON images
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_settings_updated_at BEFORE UPDATE ON settings
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert admin user (password hash is SHA-256 of password 'admin')
INSERT INTO users (role, first_name, last_name, email, password_hash) VALUES
('admin', 'Admin', 'User', 'admin@topp.com', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918');

-- Insert default settings
INSERT INTO settings (setting_key, setting_value) VALUES
('app_name', 'TOPP Backend'),
('version', '1.0.0'),
('max_connections', '100'),
('debug_mode', 'false'),
('maintenance_mode', 'false'),
('uuid_salt', '51Ewpl3lZkEVv8zg'),
('default_language', 'en'),
('timezone', 'UTC');

-- Create indexes for better performance
CREATE INDEX idx_modules_name ON modules(name);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_lname ON users(last_name);
CREATE INDEX idx_settings_key ON settings(s_key);