USE library_design_lab;

INSERT INTO categories (category_id, category_name) VALUES
    (1, 'Computer Science'),
    (2, 'Literature'),
    (3, 'History'),
    (4, 'Science');

INSERT INTO books (book_id, category_id, title, edition, isbn) VALUES
    (1, 1, 'Practical MySQL',      '1st Edition', '9780000000019'),
    (2, 1, 'Practical MySQL',      '2nd Edition', '9780000000026'),
    (3, 1, 'Learning Python',      '1st Edition', '9780000000033'),
    (4, 2, 'Stories by the River', '1st Edition', '9780000000040'),
    (5, 3, 'History of Bengal',    '1st Edition', '9780000000057'),
    (6, 4, 'Exploring the Stars',  '1st Edition', NULL);

INSERT INTO authors (author_id, author_name) VALUES
    (1, 'Farhan Ahmed'),
    (2, 'Nusrat Jahan'),
    (3, 'Sadia Rahman'),
    (4, 'Mahmud Hasan'),
    (5, 'Tanjila Akter');

INSERT INTO book_authors (book_id, author_id) VALUES
    (1, 1), (1, 2),
    (2, 1), (2, 2),
    (3, 2),
    (4, 3),
    (5, 4),
    (6, 5);

INSERT INTO book_copies (copy_id, book_id, barcode, copy_state) VALUES
    (1, 1, 'LIB-0001', 'IN_SERVICE'),
    (2, 1, 'LIB-0002', 'IN_SERVICE'),
    (3, 2, 'LIB-0003', 'IN_SERVICE'),
    (4, 2, 'LIB-0004', 'REPAIR'),
    (5, 3, 'LIB-0005', 'IN_SERVICE'),
    (6, 4, 'LIB-0006', 'IN_SERVICE'),
    (7, 5, 'LIB-0007', 'LOST'),
    (8, 5, 'LIB-0008', 'IN_SERVICE'),
    (9, 6, 'LIB-0009', 'IN_SERVICE');

INSERT INTO members (member_id, card_no, full_name, member_status) VALUES
    (1, 'MEM-001', 'Arafat Hossain', 'ACTIVE'),
    (2, 'MEM-002', 'Samia Islam',    'ACTIVE'),
    (3, 'MEM-003', 'Tanvir Ahmed',   'ACTIVE'),
    (4, 'MEM-004', 'Mim Akter',      'INACTIVE'),
    (5, 'MEM-005', 'Rafi Karim',     'ACTIVE');

SET @seed_date = CURRENT_DATE();

INSERT INTO loans (loan_id, copy_id, member_id, issued_on, due_on, returned_on) VALUES
    -- Returned on time
    (1, 1, 1, @seed_date - INTERVAL 35 DAY, @seed_date - INTERVAL 21 DAY,
              @seed_date - INTERVAL 23 DAY),
    -- Open and overdue
    (2, 1, 2, @seed_date - INTERVAL 18 DAY, @seed_date - INTERVAL 4 DAY, NULL),
    -- Open and due in 9 days
    (3, 3, 1, @seed_date - INTERVAL 5 DAY, @seed_date + INTERVAL 9 DAY, NULL),
    -- Open and due today
    (4, 5, 2, @seed_date - INTERVAL 14 DAY, @seed_date, NULL),
    -- Returned late
    (5, 6, 3, @seed_date - INTERVAL 30 DAY, @seed_date - INTERVAL 16 DAY,
              @seed_date - INTERVAL 12 DAY),
    -- Past loan for a currently inactive member
    (6, 8, 4, @seed_date - INTERVAL 45 DAY, @seed_date - INTERVAL 31 DAY,
              @seed_date - INTERVAL 33 DAY);


SELECT card_no, full_name
FROM members
WHERE member_status = 'ACTIVE'
ORDER BY full_name ASC;

SELECT copy_id, book_id, copy_state
FROM book_copies
WHERE barcode = 'BC-002';

SELECT barcode
FROM book_copies
WHERE copy_state = 'REPAIR';

SELECT COUNT(*) AS total_copies
FROM book_copies;

INSERT INTO members
(card_no, full_name, member_status)
VALUES
('M-003', 'Sadia Akter', 'ACTIVE');

UPDATE members
SET full_name = 'Sadia Rahman'
WHERE card_no = 'M-003';

SELECT *
FROM members
WHERE card_no = 'M-003';

SELECT * FROM categories;
SELECT * FROM books;
SELECT * FROM authors;
SELECT * FROM book_authors;
SELECT * FROM book_copies;
SELECT * FROM members;
SELECT * FROM loans;





              