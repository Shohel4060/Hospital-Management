USE library_design_lab;

-- 09. প্রতিটি বইয়ের নাম ও ক্যাটাগরি দেখাও।
SELECT b.title, c.category_name
FROM books AS b
JOIN categories AS c ON c.category_id = b.category_id
ORDER BY b.title;


-- 10. প্রতিটি বইয়ের সঙ্গে তার লেখকের নাম দেখাও।
-- একাধিক লেখক থাকলে প্রত্যেকের জন্য আলাদা row দেখাও।
SELECT b.title, a.author_name
FROM books AS b
LEFT JOIN book_authors AS ba ON ba.book_id = b.book_id
LEFT JOIN authors AS a ON a.author_id = ba.author_id
ORDER BY b.title, a.author_name;


-- 11. প্রতিটি বইয়ের মোট কপি সংখ্যা দেখাও।
-- কোনো বইয়ের কপি না থাকলে ০ দেখাও।
SELECT b.title, COUNT(bc.copy_id) AS total_copies
FROM books AS b
LEFT JOIN book_copies AS bc ON bc.book_id = b.book_id
GROUP BY b.book_id, b.title
ORDER BY b.title;


-- 12. প্রতিটি সদস্যের বর্তমানে খোলা ধার কয়টি, তা দেখাও।
-- কোনো সদস্যের খোলা ধার না থাকলে ০ দেখাও।
SELECT m.card_no, m.full_name,
       COUNT(l.loan_id) AS open_loans
FROM members AS m
LEFT JOIN loans AS l
    ON l.member_id = m.member_id
   AND l.returned_on IS NULL
GROUP BY m.member_id, m.card_no, m.full_name
ORDER BY m.card_no;


-- 13. বর্তমানে ধার দেওয়া যাবে এমন কপিগুলোর বইয়ের নাম ও barcode দেখাও।
-- কপিটি IN_SERVICE হতে হবে এবং তার কোনো খোলা ধার থাকা যাবে না।
SELECT b.title, bc.barcode
FROM book_copies AS bc
JOIN books AS b ON b.book_id = bc.book_id
WHERE bc.copy_state = 'IN_SERVICE'
  AND NOT EXISTS (
      SELECT 1
      FROM loans AS l
      WHERE l.copy_id = bc.copy_id
        AND l.returned_on IS NULL
  )
ORDER BY bc.barcode;


-- 14. M-001 সদস্যের ধার নেওয়ার ইতিহাস দেখাও।
-- বইয়ের নাম, barcode, ইস্যুর তারিখ, জমার শেষ তারিখ ও ফেরতের তারিখ দেখাও।
-- সর্বশেষ ইস্যু আগে দেখাও।
SELECT b.title, bc.barcode,
       l.issued_on, l.due_on, l.returned_on
FROM loans AS l
JOIN members AS m ON m.member_id = l.member_id
JOIN book_copies AS bc ON bc.copy_id = l.copy_id
JOIN books AS b ON b.book_id = bc.book_id
WHERE m.card_no = 'M-001'
ORDER BY l.issued_on DESC, l.loan_id DESC;


-- 15. মেয়াদ পেরোনো খোলা ধারগুলোর সদস্যের নাম, barcode,
-- জমার শেষ তারিখ ও কত দিন দেরি হয়েছে তা দেখাও।
SELECT m.full_name, bc.barcode, l.due_on,
       DATEDIFF(CURRENT_DATE, l.due_on) AS days_late
FROM loans AS l
JOIN members AS m ON m.member_id = l.member_id
JOIN book_copies AS bc ON bc.copy_id = l.copy_id
WHERE l.returned_on IS NULL
  AND l.due_on < CURRENT_DATE
ORDER BY days_late DESC, l.loan_id;


-- 16. BC-001 কপিটির খোলা ধার ফেরত নাও।
-- নির্দিষ্ট loan_id ধরে returned_on আপডেট করো।
-- এরপর যাচাই করো ধার রেকর্ডটি আছে, ফেরতের তারিখ বসেছে
-- এবং কপিটি আবার ধার দেওয়া যাবে।

-- প্রথমে খোলা ধারের ID বের করো।
SET @loan_id = (
    SELECT l.loan_id
    FROM loans AS l
    JOIN book_copies AS bc ON bc.copy_id = l.copy_id
    WHERE bc.barcode = 'BC-001'
      AND l.returned_on IS NULL
);

-- ফেরতের তারিখ বসাও।
UPDATE loans
SET returned_on = CURRENT_DATE
WHERE loan_id = @loan_id
  AND returned_on IS NULL;

-- ধার রেকর্ড, ফেরতের তারিখ ও কপির অবস্থা যাচাই করো।
SELECT l.loan_id, bc.barcode, l.returned_on,
       CASE
           WHEN bc.copy_state = 'IN_SERVICE'
            AND NOT EXISTS (
                SELECT 1
                FROM loans AS open_loan
                WHERE open_loan.copy_id = bc.copy_id
                  AND open_loan.returned_on IS NULL
            )
           THEN 'AVAILABLE'
           ELSE 'UNAVAILABLE'
       END AS availability
FROM loans AS l
JOIN book_copies AS bc ON bc.copy_id = l.copy_idS
WHERE l.loan_id = @loan_id;




