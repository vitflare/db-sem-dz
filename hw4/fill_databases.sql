-- Populate City table
INSERT INTO City (name, region) VALUES
('New York', 'New York State'),
('Los Angeles', 'California'),
('Chicago', 'Illinois'),
('Houston', 'Texas'),
('Philadelphia', 'Pennsylvania');

-- Populate Station table
INSERT INTO Station (name, tracks_count, city_id) VALUES
('Grand Central Terminal', 44, 1),
('Union Station', 26, 2),
('Chicago Union Station', 24, 3),
('Houston Station', 6, 4),
('30th Street Station', 13, 5);

-- Populate Train table
INSERT INTO Train (train_nr, length) VALUES
('NE101', 8),
('WC202', 10),
('MW303', 6),
('SW404', 7),
('EC505', 9);

-- Populate Connected table
INSERT INTO Connected (station_id, train_id, departure, arrival, is_start, is_end) VALUES
(1, 1, '08:00:00', NULL, true, false),
(3, 1, '14:30:00', '14:15:00', false, false),
(5, 1, NULL, '20:45:00', false, true),
(2, 2, '09:15:00', NULL, true, false),
(4, 2, '15:45:00', '15:30:00', false, false),
(3, 2, NULL, '22:00:00', false, true),
(3, 3, '10:30:00', NULL, true, false),
(4, 3, '16:00:00', '15:45:00', false, false),
(2, 3, NULL, '21:30:00', false, true),
(4, 4, '11:45:00', NULL, true, false),
(5, 4, '18:15:00', '18:00:00', false, false),
(1, 4, NULL, '23:45:00', false, true),
(5, 5, '07:30:00', NULL, true, false),
(1, 5, '13:00:00', '12:45:00', false, false),
(2, 5, NULL, '19:15:00', false, true);