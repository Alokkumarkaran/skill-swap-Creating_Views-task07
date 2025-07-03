
USE SkillSwapDB;

CREATE TABLE IF NOT EXISTS Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    role ENUM('learner', 'educator', 'admin'),
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200),
    description TEXT,
    educator_id INT,
    price DECIMAL(10,2),
    FOREIGN KEY (educator_id) REFERENCES Users(user_id)
);

CREATE TABLE IF NOT EXISTS Enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    course_id INT,
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

CREATE TABLE IF NOT EXISTS Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    course_id INT,
    amount DECIMAL(10,2),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);



INSERT INTO Users (name, email, role) VALUES
('Alok Kumar', 'alok@example.com', 'learner'),
('Priya Sharma', 'priya@example.com', 'educator'),
('Ravi Mehta', 'ravi@example.com', 'learner');

INSERT INTO Courses (title, description, educator_id, price) VALUES
('Python Basics', 'Learn Python from scratch', 2, 499.00),
('Web Dev Pro', 'Fullstack Development', 2, 699.00);

INSERT INTO Enrollments (user_id, course_id) VALUES
(1, 1),
(3, 2);

INSERT INTO Payments (user_id, course_id, amount) VALUES
(1, 1, 499.00),
(3, 2, 699.00);



CREATE OR REPLACE VIEW active_enrollments_view AS
SELECT u.user_id, u.name AS user_name, c.title AS course_title, e.enrolled_at
FROM Users u
JOIN Enrollments e ON u.user_id = e.user_id
JOIN Courses c ON e.course_id = c.course_id;

CREATE OR REPLACE VIEW user_total_payments_view AS
SELECT u.user_id, u.name, SUM(p.amount) AS total_spent
FROM Users u
JOIN Payments p ON u.user_id = p.user_id
GROUP BY u.user_id;

CREATE OR REPLACE VIEW course_revenue_view AS
SELECT c.course_id, c.title, SUM(p.amount) AS total_revenue
FROM Courses c
JOIN Payments p ON c.course_id = p.course_id
GROUP BY c.course_id;

CREATE OR REPLACE VIEW educator_courses_view AS
SELECT u.user_id, u.name AS educator_name, c.title, c.price
FROM Users u
JOIN Courses c ON u.user_id = c.educator_id
WHERE u.role = 'educator';


SHOW FULL TABLES WHERE Table_type = 'VIEW';
