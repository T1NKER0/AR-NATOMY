-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema arnatomy
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema arnatomy
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `arnatomy` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `arnatomy` ;

-- -----------------------------------------------------
-- Table `arnatomy`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `arnatomy`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(50) NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `hash` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `username` (`username` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 165
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `arnatomy`.`assessments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `arnatomy`.`assessments` (
  `assessment_id` INT NOT NULL AUTO_INCREMENT,
  `assessmentName` VARCHAR(255) NULL DEFAULT NULL,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `userstudent` VARCHAR(50) NOT NULL,
  `grade` DECIMAL(5,2) NOT NULL,
  `dateTaken` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`assessment_id`),
  UNIQUE INDEX `idx_grade` (`grade` ASC) VISIBLE,
  INDEX `fk_userstudent_assessments` (`userstudent` ASC) VISIBLE,
  CONSTRAINT `fk_userstudent_assessments`
    FOREIGN KEY (`userstudent`)
    REFERENCES `arnatomy`.`users` (`username`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `arnatomy`.`grades`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `arnatomy`.`grades` (
  `grade_id` INT NOT NULL AUTO_INCREMENT,
  `assessment_id` INT NOT NULL,
  `grade` DECIMAL(5,2) NOT NULL,
  `userstudent` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`grade_id`),
  INDEX `fk_assessment_grades` (`assessment_id` ASC) VISIBLE,
  INDEX `fk_userstudent_grades` (`userstudent` ASC) VISIBLE,
  INDEX `fk_grade_assessments` (`grade` ASC) VISIBLE,
  CONSTRAINT `fk_grade_assessments`
    FOREIGN KEY (`grade`)
    REFERENCES `arnatomy`.`assessments` (`grade`),
  CONSTRAINT `fk_userstudent_grades`
    FOREIGN KEY (`userstudent`)
    REFERENCES `arnatomy`.`users` (`username`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `arnatomy`.`menuelement`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `arnatomy`.`menuelement` (
  `menuID` INT NOT NULL,
  `title` VARCHAR(40) NOT NULL,
  `Description` MEDIUMTEXT NOT NULL,
  PRIMARY KEY (`menuID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `arnatomy`.`role`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `arnatomy`.`role` (
  `RoleId` VARCHAR(20) NOT NULL,
  `Name` VARCHAR(20) NOT NULL,
  `Description` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`RoleId`),
  UNIQUE INDEX `role_name` (`Name` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `arnatomy`.`roleuser`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `arnatomy`.`roleuser` (
  `UserName` VARCHAR(20) NOT NULL,
  `RoleId` VARCHAR(20) NOT NULL,
  `dateAssign` DATE NOT NULL,
  PRIMARY KEY (`UserName`, `RoleId`),
  INDEX `role_id` (`RoleId` ASC) VISIBLE,
  CONSTRAINT `fk_roleuser`
    FOREIGN KEY (`RoleId`)
    REFERENCES `arnatomy`.`role` (`RoleId`)
    ON DELETE CASCADE,
  CONSTRAINT `fk_userrole`
    FOREIGN KEY (`UserName`)
    REFERENCES `arnatomy`.`users` (`username`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `arnatomy`.`webpage`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `arnatomy`.`webpage` (
  `pageURL` VARCHAR(40) NOT NULL,
  `pageTitle` VARCHAR(40) NOT NULL,
  `Description` MEDIUMTEXT NOT NULL,
  `menuID` INT NULL DEFAULT NULL,
  PRIMARY KEY (`pageURL`),
  INDEX `fk_menuID` (`menuID` ASC) VISIBLE,
  CONSTRAINT `fk_menuID`
    FOREIGN KEY (`menuID`)
    REFERENCES `arnatomy`.`menuelement` (`menuID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `arnatomy`.`rolewebpage`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `arnatomy`.`rolewebpage` (
  `RoleId` VARCHAR(20) NOT NULL,
  `pageURL` VARCHAR(255) NOT NULL,
  `dateAssign` DATE NOT NULL,
  PRIMARY KEY (`RoleId`, `pageURL`),
  INDEX `fk_pageURL` (`pageURL` ASC) VISIBLE,
  CONSTRAINT `fk_pageURL`
    FOREIGN KEY (`pageURL`)
    REFERENCES `arnatomy`.`webpage` (`pageURL`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `arnatomy`.`webpageprevious`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `arnatomy`.`webpageprevious` (
  `currentpageURL` VARCHAR(40) NOT NULL,
  `previouspageURL` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`currentpageURL`, `previouspageURL`),
  INDEX `fk_previouspage` (`previouspageURL` ASC) VISIBLE,
  CONSTRAINT `fk_currentpage`
    FOREIGN KEY (`currentpageURL`)
    REFERENCES `arnatomy`.`webpage` (`pageURL`),
  CONSTRAINT `fk_previouspage`
    FOREIGN KEY (`previouspageURL`)
    REFERENCES `arnatomy`.`webpage` (`pageURL`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
