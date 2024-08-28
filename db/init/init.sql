CREATE TABLE department_master (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(255) NOT NULL,
    manager_id INT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE position_master (
    position_id SERIAL PRIMARY KEY,
    position_name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE group_master (
    group_id SERIAL PRIMARY KEY,
    group_name VARCHAR(255) NOT NULL,
    group_description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TYPE blood_type_enum AS ENUM ('A', 'B', 'O', 'AB');

CREATE TABLE employee (
    employee_id SERIAL PRIMARY KEY,
    department_id INT NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    first_name VARCHAR(30) NOT NULL,
    last_name_kana VARCHAR(30),
    first_name_kana VARCHAR(30),
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    birthday DATE NOT NULL,
    blood_type blood_type_enum,
    joined_date DATE NOT NULL,
    resigned_date DATE,
    vacation_days INT NOT NULL DEFAULT 0,
    profile_image TEXT,
    is_admin BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES department_master(department_id)
);

CREATE INDEX idx_employee_email ON employee (email);

ALTER TABLE department_master
ADD FOREIGN KEY (manager_id)
REFERENCES employee (employee_id);

CREATE TABLE attendance (
    attendance_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,
    approver_id INT,
    work_date DATE NOT NULL,
    start_datetime TIMESTAMP,
    end_datetime TIMESTAMP,
    rest_time DECIMAL,
    working_hours DECIMAL,
    is_approved BOOLEAN,
    status INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
    FOREIGN KEY (approver_id) REFERENCES employee(employee_id)
);

CREATE TABLE schedule (
    schedule_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,
    date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);

CREATE INDEX idx_schedule_employee_id ON schedule (employee_id);

CREATE TYPE target_type_enum AS ENUM ('ALL', 'GROUP', 'POSITION', 'PERSON');

CREATE TABLE notice (
    notice_id SERIAL PRIMARY KEY,
    content VARCHAR(255) NOT NULL,
    target target_type_enum DEFAULT 'PERSON',
    group_id INT,
    position_id INT,
    employee_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (group_id) REFERENCES group_master(group_id),
    FOREIGN KEY (position_id) REFERENCES position_master(position_id),
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);

CREATE TABLE salary (
    salary_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,
    salary INT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);

CREATE TABLE post (
    post_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,
    content VARCHAR(255) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);

CREATE TABLE comment (
    comment_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,
    post_id INT NOT NULL,
    comment VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
    FOREIGN KEY (post_id) REFERENCES post(post_id)
);

CREATE TABLE post_like (
    post_like_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,
    post_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
    FOREIGN KEY (post_id) REFERENCES post(post_id)
);

CREATE TABLE employee_group (
    employee_id INT NOT NULL,
    group_id INT NOT NULL,
    assignment_date DATE NOT NULL,
    end_date DATE,
    status INT DEFAULT 1,
    memo VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
    FOREIGN KEY (group_id) REFERENCES group_master(group_id)
);

CREATE INDEX idx_employee_group_employee_id ON employee_group (employee_id);
CREATE INDEX idx_employee_group_group_id ON employee_group (group_id);

CREATE TABLE employee_position (
    employee_id INT NOT NULL,
    position_id INT NOT NULL,
    assignment_date DATE NOT NULL,
    end_date DATE,
    status INT DEFAULT 1,
    memo VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
    FOREIGN KEY (position_id) REFERENCES position_master(position_id)
);

CREATE INDEX idx_employee_position_employee_id ON employee_position (employee_id);
CREATE INDEX idx_employee_position_position_id ON employee_position (position_id);



-- テストデータの挿入
INSERT INTO department_master (department_name, manager_id, created_at, updated_at)
VALUES
    ('Software Engineering', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Quality Assurance', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Product Management', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Human Resources', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('IT Support', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO position_master (position_name, created_at, updated_at)
VALUES
    ('GM', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('EM', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('PM', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('L', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('CF', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO group_master (group_name, group_description, created_at, updated_at)
VALUES
    ('1G', 'First Group', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('2G', 'Second Group', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('3G', 'Third Group', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('4G', 'Fourth Group', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('5G', 'Fifth Group', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- テストデータの挿入
INSERT INTO employee (
    department_id, last_name, first_name, last_name_kana, first_name_kana,
    email, password, birthday, blood_type, joined_date, resigned_date,
    vacation_days, profile_image, is_admin, created_at, updated_at
) VALUES
    -- 管理者 (GM 部署)
    (1, '田中', '太郎', 'タナカ', 'タロウ', 'taro.tanaka@example.com', 'password1', '1980-01-15', 'A', '2010-03-01', NULL, 15, NULL, TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (1, '鈴木', '次郎', 'スズキ', 'ジロウ', 'jiro.suzuki@example.com', 'password2', '1985-07-22', 'B', '2012-08-15', NULL, 15, NULL, TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    -- 非管理者 (EM 部署)
    (2, '佐藤', '三郎', 'サトウ', 'サブロウ', 'saburo.sato@example.com', 'password3', '1990-03-05', 'O', '2015-06-01', NULL, 10, NULL, FALSE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    -- 非管理者 (PM 部署)
    (3, '高橋', '花子', 'タカハシ', 'ハナコ', 'hanako.takahashi@example.com', 'password4', '1988-11-30', 'AB', '2016-12-01', NULL, 10, NULL, FALSE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    -- 非管理者 (L 部署)
    (4, '渡辺', '一郎', 'ワタナベ', 'イチロウ', 'ichiro.watanabe@example.com', 'password5', '1992-05-17', 'A', '2018-09-01', NULL, 10, NULL, FALSE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    -- 非管理者 (CF 部署)
    (5, '伊藤', '美咲', 'イトウ', 'ミサキ', 'misaki.ito@example.com', 'password6', '1995-02-20', 'B', '2019-01-01', NULL, 10, NULL, FALSE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    -- 役職なし
    (5, '山本', '健二', 'ヤマモト', 'ケンジ', 'kenji.yamamoto@example.com', 'password7', '1983-08-10', 'O', '2014-11-01', NULL, 15, NULL, FALSE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
