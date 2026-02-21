-- ============================================================
--  BZ Framework - Database Schema
--  Executa acest fisier in phpMyAdmin sau MySQL CLI
-- ============================================================

CREATE DATABASE IF NOT EXISTS `bz_server` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `bz_server`;

-- ============================================================
-- JUCATORI (licente/identifiers)
-- ============================================================
CREATE TABLE IF NOT EXISTS `players` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `license` VARCHAR(100) NOT NULL UNIQUE,
  `steam` VARCHAR(100) DEFAULT NULL,
  `discord` VARCHAR(100) DEFAULT NULL,
  `name` VARCHAR(100) DEFAULT NULL,
  `banned` TINYINT(1) DEFAULT 0,
  `ban_reason` TEXT DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `last_seen` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- PERSONAJE
-- ============================================================
CREATE TABLE IF NOT EXISTS `characters` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `license` VARCHAR(100) NOT NULL,
  `slot` INT(1) DEFAULT 1,
  `firstname` VARCHAR(50) NOT NULL,
  `lastname` VARCHAR(50) NOT NULL,
  `dateofbirth` VARCHAR(20) DEFAULT NULL,
  `sex` VARCHAR(10) DEFAULT 'male',
  `nationality` VARCHAR(50) DEFAULT 'Romanian',
  `job` VARCHAR(50) DEFAULT 'unemployed',
  `job_grade` INT(3) DEFAULT 0,
  `gang` VARCHAR(50) DEFAULT 'none',
  `gang_grade` INT(3) DEFAULT 0,
  `cash` INT(11) DEFAULT 5000,
  `bank` INT(11) DEFAULT 10000,
  `black_money` INT(11) DEFAULT 0,
  `coords` TEXT DEFAULT NULL,
  `heading` FLOAT DEFAULT 0,
  `health` INT(3) DEFAULT 200,
  `armor` INT(3) DEFAULT 0,
  `metadata` LONGTEXT DEFAULT NULL,
  `appearance` LONGTEXT DEFAULT NULL,
  `is_dead` TINYINT(1) DEFAULT 0,
  `jail_time` INT(11) DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `last_played` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `license` (`license`),
  KEY `job` (`job`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- INVENTAR PERSONAJE
-- ============================================================
CREATE TABLE IF NOT EXISTS `character_inventory` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `char_id` INT(11) NOT NULL,
  `item` VARCHAR(100) NOT NULL,
  `count` INT(11) DEFAULT 1,
  `slot` INT(3) DEFAULT 1,
  `metadata` LONGTEXT DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `char_id` (`char_id`),
  KEY `item` (`item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- VEHICULE PERSONAJE
-- ============================================================
CREATE TABLE IF NOT EXISTS `character_vehicles` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `char_id` INT(11) NOT NULL,
  `plate` VARCHAR(12) NOT NULL UNIQUE,
  `model` VARCHAR(100) NOT NULL,
  `mods` LONGTEXT DEFAULT NULL,
  `fuel` INT(3) DEFAULT 100,
  `body` FLOAT DEFAULT 1000.0,
  `engine` FLOAT DEFAULT 1000.0,
  `garage` VARCHAR(50) DEFAULT 'pillboxgarage',
  `parked` TINYINT(1) DEFAULT 1,
  `coords` TEXT DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `char_id` (`char_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- STASH-URI (depozite)
-- ============================================================
CREATE TABLE IF NOT EXISTS `stashes` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `stash_id` VARCHAR(100) NOT NULL,
  `label` VARCHAR(100) DEFAULT NULL,
  `item` VARCHAR(100) NOT NULL,
  `count` INT(11) DEFAULT 1,
  `slot` INT(3) DEFAULT 1,
  `metadata` LONGTEXT DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `stash_id` (`stash_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- TRANZACTII BANCA
-- ============================================================
CREATE TABLE IF NOT EXISTS `bank_transactions` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `char_id` INT(11) NOT NULL,
  `type` ENUM('deposit','withdraw','transfer','payment') NOT NULL,
  `amount` INT(11) NOT NULL,
  `description` VARCHAR(200) DEFAULT NULL,
  `from_char` INT(11) DEFAULT NULL,
  `to_char` INT(11) DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `char_id` (`char_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- PROPRIETATI
-- ============================================================
CREATE TABLE IF NOT EXISTS `properties` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `char_id` INT(11) DEFAULT NULL,
  `property_id` VARCHAR(50) NOT NULL,
  `label` VARCHAR(100) DEFAULT NULL,
  `price` INT(11) DEFAULT 0,
  `owned` TINYINT(1) DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- INREGISTRARI SOFER TIR (trucking)
-- ============================================================
CREATE TABLE IF NOT EXISTS `trucker_jobs` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `char_id` INT(11) NOT NULL,
  `pickup` VARCHAR(100) DEFAULT NULL,
  `delivery` VARCHAR(100) DEFAULT NULL,
  `cargo` VARCHAR(100) DEFAULT NULL,
  `pay` INT(11) DEFAULT 0,
  `completed` TINYINT(1) DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- LOGS ADMIN
-- ============================================================
CREATE TABLE IF NOT EXISTS `admin_logs` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `admin_license` VARCHAR(100) DEFAULT NULL,
  `admin_name` VARCHAR(100) DEFAULT NULL,
  `action` VARCHAR(100) DEFAULT NULL,
  `target` VARCHAR(200) DEFAULT NULL,
  `reason` TEXT DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- DATE IMPLICITE
-- ============================================================

-- Adauga un admin implicit (schimba license-ul cu al tau)
-- INSERT INTO players (license, name) VALUES ('license:LICENTA_TA_STEAM', 'Admin');
