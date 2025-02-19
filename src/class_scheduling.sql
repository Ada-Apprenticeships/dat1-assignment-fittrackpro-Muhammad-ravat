-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;
-- Class Scheduling Queries

-- 1. List all classes with their instructors
-- TODO: Write a query to list all classes with their instructors
SELECT 
    c.class_id,
    c.name AS class_name,
    s.first_name || ' ' || s.last_name AS instructor_name --Retrieve first and last name of instructor and combine to get full name
FROM classes c
JOIN class_schedule cls
ON c.class_id = cls.class_id
JOIN staff s
ON cls.staff_id = s.staff_id;
-- 2. Find available classes for a specific date
-- TODO: Write a query to find available classes for a specific date
SELECT 
    cls.class_id,
    c.name,
    cls.start_time,
    cls.end_time,
    (c.capacity - COUNT(ca.member_id)) AS available_spots --Calculate available spots by subtracting the number of registered members from the class capacity
FROM class_schedule cls
JOIN classes c
ON cls.class_id = c.class_id 
LEFT JOIN class_attendance ca 
ON cls.schedule_id = ca.schedule_id
WHERE date(cls.start_time) = '2025-02-01' --Filter classes by specific date
GROUP BY cls.schedule_id 
HAVING available_spots > 0;  --makes sure that only classes with available spots are returned
-- 3. Register a member for a class
-- TODO: Write a query to register a member for a class
INSERT INTO class_attendance (schedule_id, member_id, attendance_status)
SELECT cls.schedule_id, 11, 'Registered'
FROM class_schedule cls
WHERE cls.class_id = 3 AND date(cls.start_time) = '2025-02-01'
LIMIT 1;
-- 4. Cancel a class registration
-- TODO: Write a query to cancel a class registration
DELETE FROM class_attendance
WHERE schedule_id = 7 AND member_id = 2;
-- 5. List top 3 most popular classes  (5 was changed to 3 as readme says 3)
-- TODO: Write a query to list top 3 most popular classes
SELECT 
    c.class_id,   ---Retrieve the top 3 classes with the highest registration count by joining classes, class_schedule, and class_attendance tables
    c.name AS class_name,
    COUNT(ca.member_id) AS registration_count
FROM classes c
JOIN class_schedule cls
ON c.class_id = cls.class_id
JOIN class_attendance ca
ON cls.schedule_id = ca.schedule_id
GROUP BY c.class_id
ORDER BY registration_count DESC
LIMIT 3;
-- 6. Calculate average number of classes per member
-- TODO: Write a query to calculate average number of classes per member
SELECT COUNT(*) / (SELECT COUNT(DISTINCT member_id) FROM members) AS avg_classes_per_member
FROM class_attendance;