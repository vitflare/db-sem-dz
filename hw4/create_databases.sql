-- Create City table
CREATE TABLE City (
    city_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NULL
);

-- Create Station table
CREATE TABLE Station (
    station_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    tracks_count INTEGER NOT NULL,
    city_id INTEGER NOT NULL,
    FOREIGN KEY (city_id) REFERENCES City(city_id)
);

-- Create Train table
CREATE TABLE Train (
    train_id SERIAL PRIMARY KEY,
    train_nr VARCHAR(20) NOT NULL,
    length INTEGER NOT NULL
);

-- Create Connected table (for many-to-many relationship between Station and Train)
CREATE TABLE Connected (
    station_id INTEGER NOT NULL,
    train_id INTEGER NOT NULL,
    departure TIME,
    arrival TIME,
    is_start BOOLEAN NOT NULL,
    is_end BOOLEAN NOT NULL,
    PRIMARY KEY (station_id, train_id),
    FOREIGN KEY (station_id) REFERENCES Station(station_id),
    FOREIGN KEY (train_id) REFERENCES Train(train_id)
);