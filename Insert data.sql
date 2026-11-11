USE hospital_db;

INSERT INTO roles (code) VALUES
('ADMIN'),
('DOCTOR'),
('RECEPTIONIST');

INSERT INTO users
(role_id, username, password_hash, is_active)
VALUES
(1, 'admin', 'admin_hash_123', TRUE),
(2, 'doctor1', 'doctor_hash_123', TRUE),
(3, 'receptionist', 'reception_hash_123', TRUE);

INSERT INTO departments (name) VALUES
('Cardiology'),
('Neurology'),
('Orthopedics');

INSERT INTO departments (name)
VALUES
('Physiotherapy ');

SELECT * FROM departments;

INSERT INTO doctors
(user_id, department_id, name, specialization, fee, is_active)
VALUES
(1, 1, 'Dr. Rahim Ahmed', 'Heart Specialist', 1000.00, TRUE),
(2, 2, 'Dr. Karim Hasan', 'Brain Specialist', 1200.00, TRUE),
(3, 3, 'Dr. Sakib Khan', 'Bone Specialist', 800.00, TRUE);

SELECT * FROM doctors;

INSERT INTO users
(role_id, username, password_hash, is_active)
VALUES
(2, 'doctor2', 'doctor_hash_456', TRUE),
(2, 'doctor3', 'doctor_hash_789', TRUE);


INSERT INTO patients
(patient_no, full_name, dob, phone, address, emergency_phone)
VALUES
('P001', 'Rahim Uddin', '1995-05-10', '01711111111', 'Dhaka', '01811111111'),
('P002', 'Karim Ahmed', '1990-08-15', '01722222222', 'Khulna', '01822222222'),
('P003', 'Nusrat Jahan', '2000-02-20', '01733333333', 'Rajshahi', '01833333333');

INSERT INTO patients
(patient_no, full_name, dob, phone, address, emergency_phone)
VALUES
('P004', 'Nustar Jahan Apola', '2001-04-18', '01700000001', 'India', '01800000001');

SELECT * FROM patients;

INSERT INTO doctor_slots
(doctor_id, starts_at, ends_at, is_open)
VALUES
(16, '2026-11-11 10:00:00', '2026-11-11 10:30:00', TRUE),
(17, '2026-11-11 11:00:00', '2026-11-11 11:30:00', TRUE),
(18, '2026-11-11 12:00:00', '2026-11-11 12:30:00', TRUE);


INSERT INTO appointments
(slot_id, patient_id, status)
VALUES
(22, 1, 'booked'),
(23, 2, 'checked_in'),
(24, 3, 'booked');

SELECT * FROM roles;
SELECT * FROM users;
SELECT * FROM departments;
SELECT * FROM doctors;
SELECT * FROM patients;
SELECT * FROM doctor_slots;
SELECT * FROM appointments;


SET @slot_start = TIMESTAMP(
    UTC_DATE() + INTERVAL 1 DAY,
    '11:00:00'
);
INSERT INTO doctor_slots (doctor_id, starts_at, ends_at)
VALUES (
    1,
    @slot_start,
    DATE_ADD(@slot_start, INTERVAL 30 MINUTE)
);
SELECT *
FROM doctor_slots
WHERE doctor_id = 1
ORDER BY starts_at DESC;

-- 7
SET @slot_id = (
    SELECT id
    FROM doctor_slots
    WHERE doctor_id = 1
      AND starts_at = @slot_start
);

INSERT INTO appointments (slot_id, patient_id, status)
VALUES (@slot_id, 2, 'booked');

SET @appointment_id = LAST_INSERT_ID();

-- 8
UPDATE appointments
SET status = 'cancelled'
WHERE id = @appointment_id
  AND status = 'booked';

SELECT id, slot_id, patient_id, status
FROM appointments
WHERE id = @appointment_id;








