/* ===============================
   DATABASE
================================ */
CREATE DATABASE jb_online;
USE jb_online;

/* ===============================
   DDL - CREATE TABLE
================================ */

CREATE TABLE penjual (
    id_penjual VARCHAR(10) PRIMARY KEY,
    nama_penjual VARCHAR(100),
    alamat_penjual TEXT,
    nohp_penjual VARCHAR(15),
    username_penjual VARCHAR(50)
);

CREATE TABLE pembeli (
    id_pembeli VARCHAR(10) PRIMARY KEY,
    nama_pembeli VARCHAR(100),
    alamat_pembeli TEXT,
    nohp_pembeli VARCHAR(15),
    username_pembeli VARCHAR(50)
);

CREATE TABLE item (
    id_item VARCHAR(10) PRIMARY KEY,
    nama_item VARCHAR(100),
    harga_item INT,
    status_item VARCHAR(50),
    id_penjual VARCHAR(10),
    FOREIGN KEY (id_penjual) REFERENCES penjual(id_penjual)
);

CREATE TABLE pembelian (
    id_pembelian VARCHAR(10) PRIMARY KEY,
    id_pembeli VARCHAR(10),
    id_item VARCHAR(10),
    jumlah_item INT,
    status_pembelian VARCHAR(50),
    FOREIGN KEY (id_pembeli) REFERENCES pembeli(id_pembeli),
    FOREIGN KEY (id_item) REFERENCES item(id_item)
);

/* ===============================
   DML - INSERT DATA
================================ */

INSERT INTO penjual VALUES
('P001','Akbar','Jakarta','08123456789','msbayyy'),
('P002','Dika','Bandung','08234567890','ditzy');

INSERT INTO pembeli VALUES
('B001','Rina','Surabaya','08345678901','rina22'),
('B002','Andi','Malang','08456789012','andi_dev');

INSERT INTO item VALUES
('G001','100Rbx',13000,'Available','P001'),
('G002','300Rbx',39000,'Available','P001'),
('G003','230Rbx',30000,'Available','P002'),
('G004','150Rbx',25000,'Available','P002');

INSERT INTO pembelian VALUES
('TR001','B001','G001',1,'Selesai'),
('TR002','B001','G002',1,'Batal'),
('TR003','B002','G003',2,'Selesai');

/* ===============================
   UPDATE
================================ */

UPDATE penjual
SET username_penjual = 'msbayyy_new'
WHERE id_penjual = 'P001';

/* ===============================
   DELETE
================================ */

DELETE FROM pembelian
WHERE id_pembelian = 'TR002';

/* ===============================
   SELECT + WHERE
================================ */

SELECT id_item, nama_item, harga_item
FROM item
WHERE harga_item BETWEEN 13000 AND 30000;

/* ===============================
   ORDER BY
================================ */

SELECT id_item, nama_item, harga_item
FROM item
ORDER BY harga_item ASC;

/* ===============================
   JOIN
================================ */

SELECT 
    pb.id_pembelian,
    pj.nama_penjual,
    pm.username_pembeli,
    it.nama_item,
    pb.jumlah_item,
    pb.status_pembelian
FROM pembelian pb
JOIN pembeli pm ON pb.id_pembeli = pm.id_pembeli
JOIN item it ON pb.id_item = it.id_item
JOIN penjual pj ON it.id_penjual = pj.id_penjual;

/* ===============================
   SUBQUERY
================================ */

SELECT nama_item, harga_item
FROM item
WHERE harga_item > (
    SELECT AVG(harga_item) FROM item
);

/* ===============================
   AGGREGATE FUNCTION
================================ */

SELECT
    SUM(harga_item) AS total_harga,
    AVG(harga_item) AS rata_rata_harga,
    MAX(harga_item) AS harga_tertinggi
FROM item;

/* ===============================
   GROUP BY & HAVING
================================ */

SELECT id_penjual, COUNT(id_item) AS total_item
FROM item
GROUP BY id_penjual
HAVING COUNT(id_item) > 1;

/* ===============================
   VIEW
================================ */

CREATE VIEW view_transaksi AS
SELECT 
    pb.id_pembelian,
    pm.username_pembeli,
    it.nama_item,
    pb.jumlah_item,
    (it.harga_item * pb.jumlah_item) AS total_harga
FROM pembelian pb
JOIN pembeli pm ON pb.id_pembeli = pm.id_pembeli
JOIN item it ON pb.id_item = it.id_item;

/* ===============================
   TRIGGER
================================ */

DELIMITER //
CREATE TRIGGER before_insert_pembelian
BEFORE INSERT ON pembelian
FOR EACH ROW
BEGIN
    IF NEW.jumlah_item <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Jumlah item harus lebih dari 0';
    END IF;
END;
//
DELIMITER ;

/* ===============================
   STORED PROCEDURE
================================ */

DELIMITER //
CREATE PROCEDURE total_transaksi()
BEGIN
    SELECT COUNT(*) AS total_transaksi FROM pembelian;
END;
//
DELIMITER ;

/* ===============================
   TRANSACTION CONTROL
================================ */

START TRANSACTION;
INSERT INTO pembelian VALUES ('TR004','B002','G004',1,'Selesai');
COMMIT;

/* ===============================
   HAK AKSES USER
================================ */

CREATE USER 'user_jb'@'localhost' IDENTIFIED BY '12345';
GRANT SELECT, INSERT, UPDATE ON jb_online.* TO 'user_jb'@'localhost';
FLUSH PRIVILEGES;
