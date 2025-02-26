-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;
-- Staff Management Queries

-- 1. List all staff members by role
-- TODO: Write a query to list all staff members by role
SELECT 
    position AS role,
    first_name,
    last_name,
    staff_id
FROM staff
ORDER BY position;
-- 2. Find trainers with one or more personal training session in the next 30 days
-- TODO: Write a query to find trainers with one or more personal training session in the next 30 days
SELECT 
    s.staff_id AS trainer_id,
    s.first_name || ' ' || s.last_name AS trainer_name, -- Concatenate first_name and last_name
    COUNT(pts.session_id) AS session_count 
FROM staff s
JOIN personal_training_sessions pts 
ON s.staff_id = pts.staff_id
WHERE s.position = 'Trainer' AND pts.session_date BETWEEN DATE('now') AND DATE('now', '+30 days')
GROUP BY s.staff_id
ORDER BY session_count DESC; --Order by session count in descending order to get trainers with the most upcoming sessions