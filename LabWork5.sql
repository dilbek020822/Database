CREATE TABLE employees (
    employee_id integer,
    first_name  text,
    last_name   text,
    age         integer CHECK (age BETWEEN 18 AND 65),
    salary      numeric CHECK (salary > 0)
);
CREATE TABLE products_catalog (
    product_id     integer,
    product_name   text,
    regular_price  numeric,
    discount_price numeric,
    CONSTRAINT valid_discount CHECK (
        regular_price > 0 AND discount_price > 0 AND discount_price < regular_price)
);
CREATE TABLE bookings (
    booking_id      integer,
    check_in_date   date,
    check_out_date  date,
    num_guests      integer CHECK (num_guests BETWEEN 1 AND 10),
    CONSTRAINT valid_dates CHECK (check_out_date > check_in_date)
);
INSERT INTO employees VALUES (1,'Anna','Smith',30,5000), (2,'Bob','Jones',45,7000);
INSERT INTO products_catalog VALUES (1,'Laptop',1000,800), (2,'Mouse',50,40);
INSERT INTO bookings VALUES (1,'2026-10-01','2026-10-05',2), (2,'2026-11-01','2026-11-03',1);
CREATE TABLE customers (
    customer_id      integer NOT NULL,
    email            text    NOT NULL,
    phone            text,
    registration_date date   NOT NULL
);
CREATE TABLE inventory (
    item_id      integer   NOT NULL,
    item_name    text      NOT NULL,
    quantity     integer   NOT NULL CHECK (quantity >= 0),
    unit_price   numeric   NOT NULL CHECK (unit_price > 0),
    last_updated timestamp NOT NULL
);
INSERT INTO customers VALUES (1,'a@mail.com','12345','2026-10-01'), (2,'b@mail.com',NULL,'2026-10-02');
INSERT INTO inventory VALUES (1,'Widget',10,9.99,NOW()), (2,'Gadget',0,19.99,NOW());
CREATE TABLE users (
    user_id    integer,
    username   text,
    email      text,
    created_at timestamp,
    CONSTRAINT unique_username UNIQUE (username),
    CONSTRAINT unique_email    UNIQUE (email)
);
CREATE TABLE course_enrollments (
    enrollment_id integer,
    student_id    integer,
    course_code   text,
    semester      text,
    UNIQUE (student_id, course_code, semester)
);
INSERT INTO users VALUES (1,'alice','a@x.com',NOW()), (2,'bob','b@x.com',NOW());
INSERT INTO course_enrollments VALUES (1,101,'CS101','Fall2026'), (2,101,'CS102','Fall2026');
CREATE TABLE departments (
    dept_id   integer PRIMARY KEY,
    dept_name text NOT NULL,
    location  text
);
INSERT INTO departments VALUES (1,'IT','Building A'), (2,'HR','Building B'), (3,'Finance','Building C');
CREATE TABLE student_courses (
    student_id      integer,
    course_id       integer,
    enrollment_date date,
    grade           text,
    PRIMARY KEY (student_id, course_id)
);
INSERT INTO student_courses VALUES (1,101,'2026-09-01','A'), (1,102,'2026-09-01','B');
CREATE TABLE employees_dept (
    emp_id    integer PRIMARY KEY,
    emp_name  text NOT NULL,
    dept_id   integer REFERENCES departments,
    hire_date date
);
INSERT INTO employees_dept VALUES (1,'John',1,'2026-01-15'), (2,'Jane',2,'2026-02-01');
CREATE TABLE authors (
    author_id   integer PRIMARY KEY,
    author_name text NOT NULL,
    country     text
);
CREATE TABLE publishers (
    publisher_id   integer PRIMARY KEY,
    publisher_name text NOT NULL,
    city           text
);
CREATE TABLE books (
    book_id          integer PRIMARY KEY,
    title            text NOT NULL,
    author_id        integer REFERENCES authors,
    publisher_id     integer REFERENCES publishers,
    publication_year integer,
    isbn             text UNIQUE
);
INSERT INTO authors VALUES (1,'Tolkien','UK'), (2,'Orwell','UK');
INSERT INTO publishers VALUES (1,'Penguin','London'), (2,'Harper','NY');
INSERT INTO books VALUES (1,'LOTR',1,1,1954,'111'), (2,'1984',2,2,1949,'222');
CREATE TABLE categories (
    category_id   integer PRIMARY KEY,
    category_name text NOT NULL
);
CREATE TABLE products_fk (
    product_id   integer PRIMARY KEY,
    product_name text NOT NULL,
    category_id  integer REFERENCES categories ON DELETE RESTRICT
);
CREATE TABLE orders (
    order_id   integer PRIMARY KEY,
    order_date date NOT NULL
);
CREATE TABLE order_items (
    item_id    integer PRIMARY KEY,
    order_id   integer REFERENCES orders ON DELETE CASCADE,
    product_id integer REFERENCES products_fk,
    quantity   integer CHECK (quantity > 0)
);
INSERT INTO categories VALUES (1,'Books'),(2,'Electronics');
INSERT INTO products_fk VALUES (1,'LOTR',1),(2,'Laptop',2);
INSERT INTO orders VALUES (1,'2026-10-01');
INSERT INTO order_items VALUES (1,1,1,2),(2,1,2,1);
DELETE FROM orders WHERE order_id=1;
CREATE TABLE customers_ec (
    customer_id      integer PRIMARY KEY,
    name             text NOT NULL,
    email            text NOT NULL UNIQUE,
    phone            text,
    registration_date date NOT NULL
);
CREATE TABLE products_ec (
    product_id      integer PRIMARY KEY,
    name            text NOT NULL,
    description     text,
    price           numeric CHECK (price >= 0),
    stock_quantity  integer CHECK (stock_quantity >= 0)
);
CREATE TABLE orders_ec (
    order_id     integer PRIMARY KEY,
    customer_id  integer NOT NULL REFERENCES customers_ec ON DELETE RESTRICT,
    order_date   date NOT NULL,
    total_amount numeric CHECK (total_amount >= 0),
    status       text CHECK (status IN ('pending','processing','shipped','delivered','cancelled'))
);
CREATE TABLE order_details_ec (
    order_detail_id integer PRIMARY KEY,
    order_id        integer NOT NULL REFERENCES orders_ec ON DELETE CASCADE,
    product_id      integer NOT NULL REFERENCES products_ec,
    quantity        integer CHECK (quantity > 0),
    unit_price      numeric CHECK (unit_price >= 0)
);
INSERT INTO customers_ec VALUES
 (1,'Ivan','ivan@x.com','111','2026-01-01'),(2,'Oleg','oleg@x.com','222','2026-01-02'),
 (3,'Maria','maria@x.com','333','2026-01-03'),(4,'Anna','anna@x.com','444','2026-01-04'),
 (5,'Petr','petr@x.com','555','2026-01-05');
INSERT INTO products_ec VALUES
 (1,'Phone','Smartphone',500,10),(2,'Case','Cover',10,50),(3,'Laptop','Notebook',1000,5),
 (4,'Mouse','Wireless',25,30),(5,'Keyboard','Mech',75,20);
INSERT INTO orders_ec VALUES
 (1,1,'2026-09-01',510,'shipped'),(2,2,'2026-09-02',1000,'delivered'),
 (3,3,'2026-09-03',35,'processing'),(4,4,'2026-09-04',75,'pending'),(5,5,'2026-09-05',500,'cancelled');
INSERT INTO order_details_ec VALUES
 (1,1,1,1,500),(2,1,2,1,10),(3,2,3,1,1000),(4,3,4,1,25),(5,3,2,1,10);
