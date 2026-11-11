CREATE DATABASE library_design_lab;
USE library_design_lab;

CREATE TABLE categories (
    category_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(80) NOT NULL UNIQUE
) ENGINE=InnoDB;


CREATE TABLE books (
    book_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    category_id INT UNSIGNED NOT NULL,
    title VARCHAR(200) NOT NULL,
    edition VARCHAR(30) NOT NULL,
    isbn VARCHAR(13) UNIQUE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    INDEX ix_books_title (title)
) ENGINE=InnoDB;

SELECT title, edition, isbn
FROM books;

SELECT book_id, title
FROM books
WHERE isbn IS NULL;

CREATE TABLE authors (
    author_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(150) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE book_authors (
    book_id INT UNSIGNED NOT NULL,
    author_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
) ENGINE=InnoDB;


CREATE TABLE book_copies (
    copy_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    book_id INT UNSIGNED NOT NULL,
    barcode VARCHAR(30) NOT NULL UNIQUE,
    copy_state ENUM('IN_SERVICE', 'REPAIR', 'LOST')
        NOT NULL DEFAULT 'IN_SERVICE',
    FOREIGN KEY (book_id) REFERENCES books(book_id)
) ENGINE=InnoDB;


CREATE TABLE members (
    member_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    card_no VARCHAR(30) NOT NULL UNIQUE,
    full_name VARCHAR(150) NOT NULL,
    member_status ENUM('ACTIVE', 'INACTIVE')
        NOT NULL DEFAULT 'ACTIVE'
) ENGINE=InnoDB;



CREATE TABLE loans (
    loan_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    copy_id INT UNSIGNED NOT NULL,
    member_id INT UNSIGNED NOT NULL,
    issued_on DATE NOT NULL,
    due_on DATE NOT NULL,
    returned_on DATE NULL,
    open_copy_id INT UNSIGNED GENERATED ALWAYS AS
        (CASE WHEN returned_on IS NULL THEN copy_id END) STORED,
    UNIQUE KEY uq_loans_open_copy (open_copy_id),
    INDEX ix_loans_member_open (member_id, returned_on),
    INDEX ix_loans_open_due (returned_on, due_on),
    FOREIGN KEY (copy_id) REFERENCES book_copies(copy_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    CONSTRAINT ck_loans_due CHECK (due_on >= issued_on),
    CONSTRAINT ck_loans_return
        CHECK (returned_on IS NULL OR returned_on >= issued_on)
) ENGINE=InnoDB;


