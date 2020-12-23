
#tworzenie tabel forward engineer
CREATE TABLE IF NOT EXISTS `olszaks`.`gatunek_filmowy` (
  `nazwa` VARCHAR(45) NOT NULL,
  `opis` TEXT(200) NULL,
  PRIMARY KEY (`nazwa`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `olszaks`.`dziedzina`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `olszaks`.`dziedzina` (
  `idDziedziny` INT NOT NULL AUTO_INCREMENT,
  `dziedzina` VARCHAR(45) NOT NULL,
  `opis` TEXT(200) NULL,
  PRIMARY KEY (`idDziedziny`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `olszaks`.`Film`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `olszaks`.`Film` (
  `idFilmu` INT NOT NULL AUTO_INCREMENT,
  `tytuł` VARCHAR(45) NOT NULL,
  `idZastosowania` INT NULL,
  `gatunek` VARCHAR(45) NOT NULL,
  `rodzaj` ENUM('animowany', 'dokumentalny', 'fabularny') NULL,
  PRIMARY KEY (`idFilmu`),
  INDEX `fk_Film_gatunek1_idx` (`gatunek` ASC) VISIBLE,
  INDEX `fk_Film_dziedzina1_idx` (`idZastosowania` ASC) VISIBLE,
  CONSTRAINT `fk_Film_gatunek1`
    FOREIGN KEY (`gatunek`)
    REFERENCES `olszaks`.`gatunek_filmowy` (`nazwa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Film_dziedzina1`
    FOREIGN KEY (`idZastosowania`)
    REFERENCES `olszaks`.`dziedzina` (`idDziedziny`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `olszaks`.`inne_multimedia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `olszaks`.`inne_multimedia` (
  `idInne_multimedia` INT NOT NULL AUTO_INCREMENT,
  `rodzaj` VARCHAR(45) NOT NULL,
  `tytuł` VARCHAR(45) NULL,
  `autor` VARCHAR(50) NULL,
  PRIMARY KEY (`idInne_multimedia`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `olszaks`.`specjalizacja`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `olszaks`.`specjalizacja` (
  `idSpecjalizacji` INT(2) NOT NULL,
  `nazwa` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idSpecjalizacji`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `olszaks`.`tworca`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `olszaks`.`tworca` (
  `idTworcy` INT NOT NULL,
  `imie` VARCHAR(45) NOT NULL,
  `nazwisko` VARCHAR(45) NOT NULL,
  `specjalizacja` INT(2) NOT NULL,
  PRIMARY KEY (`idTworcy`),
  INDEX `fk_tworca_specjalizacja1_idx` (`specjalizacja` ASC) VISIBLE,
  CONSTRAINT `fk_tworca_specjalizacja1`
    FOREIGN KEY (`specjalizacja`)
    REFERENCES `olszaks`.`specjalizacja` (`idSpecjalizacji`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `olszaks`.`tworca_filmowy`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `olszaks`.`tworca_filmowy` (
  `idFilmu` INT NOT NULL,
  `idTworcy` INT NOT NULL,
  PRIMARY KEY (`idFilmu`, `idTworcy`),
  INDEX `fk_Film_has_autor_autor1_idx` (`idTworcy` ASC) VISIBLE,
  CONSTRAINT `fk_Film_has_autor_autor1`
    FOREIGN KEY (`idTworcy`)
    REFERENCES `olszaks`.`tworca` (`idTworcy`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_autorzy_filmowi_Film1`
    FOREIGN KEY (`idFilmu`)
    REFERENCES `olszaks`.`Film` (`idFilmu`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `olszaks`.`zastosowania_multimediow`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `olszaks`.`zastosowania_multimediow` (
  `idInne_multimedia` INT NOT NULL,
  `idDziedziny` INT NOT NULL,
  PRIMARY KEY (`idInne_multimedia`, `idDziedziny`),
  INDEX `fk_inne_multimedia_has_dziedzina_dziedzina1_idx` (`idDziedziny` ASC) VISIBLE,
  INDEX `fk_inne_multimedia_has_dziedzina_inne_multimedia1_idx` (`idInne_multimedia` ASC) VISIBLE,
  CONSTRAINT `fk_inne_multimedia_has_dziedzina_inne_multimedia1`
    FOREIGN KEY (`idInne_multimedia`)
    REFERENCES `olszaks`.`inne_multimedia` (`idInne_multimedia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_inne_multimedia_has_dziedzina_dziedzina1`
    FOREIGN KEY (`idDziedziny`)
    REFERENCES `olszaks`.`dziedzina` (`idDziedziny`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

# wstawianie wartosci + trigery, funkcje, procedury
INSERT INTO gatunek_filmowy VALUES ('AKCJI', 'Dostarcza rozrywki poprzez pokazywanie poscigow samochodowych, strzelanin, bijatyk i innych scen kaskaderskich o duzym ladunku napiecia i emocji.');
INSERT INTO gatunek_filmowy VALUES ('KOMEDIA', 'Gatunek filmowy przedstawiający smieszne i humorystyczne sytuacje i postaci, mający najczesciej szczesliwe zakonczenie.'),
('DRAMAT','Film przewaznie fabularny ktorego sturktura ma za zadanie poruszyc widza'),
('HORROR','Celem filmu jest wywolanie u widza klimatu grozy');

DELIMITER $$
CREATE TRIGGER film_before_insert
BEFORE INSERT ON Film
FOR EACH ROW
BEGIN
	 IF(new.gatunek NOT IN(SELECT nazwa FROM gatunek_filmowy))
     THEN
     INSERT INTO gatunek_filmowy VALUES(new.gatunek,'...');
     END IF;
END $$
DELIMITER ;

INSERT INTO dziedzina(idDziedziny, dziedzina) VALUES (default, 'rozrywka'), (default, 'edukacja'), (default, 'biznes');
INSERT INTO dziedzina VALUES (default, 'medycyna','Lekarze w ramach szkolenia mają mozliwosc uczestniczenia w wirtualnych 
operacjach, co pozwala zobrazowac im wplyw chorob przenoszonych na ludzkie cialo przez bakterie i wirusy.');
INSERT INTO dziedzina VALUES (default, 'reklama', 'wiele prodoktow multimedialnych jast wykożystywanych w celach reklamowych');
INSERT INTO Film VALUES (default, 'Transporter 2', 1, 'AKCJI', 'fabularny','2005-08-03');
 INSERT INTO Film VALUES(default, 'Zielona mila',1, 'dramat', 'fabularny','1999-12-09');
 INSERT INTO Film VALUES(default, 'Jak rozpętalem drugą wojne swiatowa',1,'komedia', 'fabularny','1970-04-02');
 INSERT INTO Film VALUES(default, 'Bylo sobie zycie-Kubki smakowe',2, default, 'animowany', default);
INSERT INTO Film VALUES (default, 'Titanic', 1,'KATASTROFICZNY','fabularny','1997-12-19');
RENAME TABLE Film TO film;

ALTER TABLE specjalizacja MODIFY idSpecjalizacji INT(2)  AUTO_INCREMENT;
desc specjalizacja;
ALTER TABLE tworca ADD FOREIGN KEY (specjalizacja) REFERENCES specjalizacja(idSpecjalizacji);
INSERT INTO specjalizacja VALUES (default, 'scenarzysta'),(default, 'rezyser'),(default, 'aktor'),
(default, 'charakteryzator'),(default, 'kompozytor_muzyki'),(default, 'montazysta');

INSERT INTO tworca VALUES
(default,'Jason', 'Statham', 3, 'brytyjska'),(default,'Alexandre ', 'Azaria', 5, 'francuska'),
(default,'Corey', 'Yuen', 2, 'chinska'),(default,'Luc', 'Besson', 1, 'Francuska'),
(default,'Walter', 'Mariot', 6, 'Francuska'),(default,'Christine Lucas', 'Navarro', 6, 'Francuska');
SELECT * FROM specjalizacja;
SELECT * FROM tworca;
SELECT * FROM film;
INSERT INTO tworca_filmowy VALUES (1,1),(1,2),(1,3),(1,4),(1,5),(1,6);
INSERT INTO tworca VALUES
(default,'Thomas', ' Newman', 5, 'amerykanska'),(default,'Frank', 'Darabont', 1, 'francuska'),
(default,'Tom', 'Hanks', 3, 'amerykańska'),(default,'Richard', 'Francis-Bruce', 6, 'Australijska');

INSERT INTO tworca_filmowy VALUES (2,7),(2,8),(2,9),(2,10);

DELIMITER //
CREATE TRIGGER tworca_filmowy_before_delete
BEFORE DELETE ON tworca_filmowy
FOR EACH ROW
BEGIN 
SIGNAL sqlstate '45000' 
SET message_text='W danej tabeli jest zablokowane usuwanie wartosci';
END //
DELIMITER ;


DELIMITER //
CREATE FUNCTION obsada_filmu( nazwa_filmu VARCHAR(45))
RETURNS VARCHAR(255)
BEGIN
DECLARE obsada VARCHAR(255);
SELECT GROUP_CONCAT(tworca.imie," ", tworca.nazwisko," - ",specjalizacja.nazwa SEPARATOR ", ") AS obsada INTO obsada  
FROM film, tworca_filmowy, tworca, specjalizacja 
WHERE tworca_filmowy.idFilmu=film.idFilmu 
AND tworca_filmowy.idTworcy=tworca.idTworcy 
AND tworca.specjalizacja=specjalizacja.idSpecjalizacji 
AND film.tytul=nazwa_filmu
GROUP BY tytul;
RETURN obsada;
END//

SELECT obsada_filmu('Transporter 2'); 

DELIMITER //
CREATE PROCEDURE dodaj_opis_dziedzina ( in nazwa_dziedziny VARCHAR(45), tekst TEXT(200))
BEGIN
	DECLARE zmienna INT;
   IF nazwa_dziedziny NOT IN (SELECT dziedzina FROM dziedzina )
   THEN SIGNAL SQLSTATE '45000' SET message_text='wybrana dziedzina nie istnieje';
   ELSE 
   SELECT idDziedziny INTO zmienna FROM dziedzina WHERE dziedzina=nazwa_dziedziny;
   UPDATE dziedzina SET opis=tekst WHERE idDziedziny=zmienna;
   END IF;
END//
SELECT * FROM dziedzina;
CALL dodaj_opis_dziedzina ('rozrywka', 'Multimedia wykozystuje sie zwlascza w filmach, w ktorych sa animacja');
   
   
	




















