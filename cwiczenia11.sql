
/*zadanie 1*/
CREATE OR REPLACE TRIGGER t_kursy_nazwa
BEFORE INSERT ON KURSY
FOR EACH ROW
BEGIN
:new.NAZWA:=upper(:new.NAZWA);
END;
/
INSERT INTO KURSY VALUES (20,'podstawy programu excel',20);

/*zadanie 2a*/

CREATE SEQUENCE kurs_wstawianie_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER t_kursy_wstawianie
BEFORE INSERT ON KURSY
FOR EACH ROW
BEGIN
:new.ID_KURSU:=kurs_wstawianie_seq.NEXTVAL;
END;

  /*zadanie 2b*/
alter trigger t_kursy_wstawianie DISABLE ;

/*zadanie 3*/

CREATE OR REPLACE TRIGGER t_kursy_godziny
BEFORE INSERT OR UPDATE ON KURSY
FOR EACH ROW
BEGIN
IF :new.LICZBA_GODZIN<5 THEN
RAISE_APPLICATION_ERROR(-20000, 'Zbyt mala liczba godzin kursu');
END IF;
END;
/

/*zadanie 4a*/

select trigger_type, TRIGGER_BODY

  from user_triggers

 where trigger_name = 'T_KURSY_GODZINY';

/*zadanie 4b*/

select trigger_name

  from user_triggers

 where status = 'ENABLED';

/*zadanie 5*/

CREATE TABLE kursy_archiwum AS
SELECT * FROM KURSY WHERE 1=2;
select * from kursy_archiwum;

CREATE OR REPLACE TRIGGER t_kursy_usuwanie_archiwum
BEFORE DELETE ON KURSY
FOR EACH ROW
BEGIN
INSERT INTO kursy_archiwum VALUES
(:old.ID_KURSU, :old.NAZWA, :old.LICZBA_GODZIN);
END;
/

/*zadanie 6*/
CREATE SEQUENCE wydarzenia_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE wydarzenia
(id NUMBER CONSTRAINT wydarzenia_PK PRIMARY KEY,
nazwa VARCHAR2(15) NOT NULL,
id_wiersza NUMBER NOT NULL,
data DATE NOT NULL,
uzytkownik VARCHAR2(30) NOT NULL
constraint check_nazwa check (nazwa in ('INSERT','UPDATE','DELETE')));

CREATE OR REPLACE TRIGGER t_kursy_wydarzenia
BEFORE INSERT OR UPDATE OR DELETE ON KURSY
FOR EACH ROW
BEGIN
IF inserting THEN
INSERT INTO wydarzenia VALUES (wydarzenia_seq .NEXTVAL, 'INSERT', :new.ID_KURSU,
SYSDATE, USER);
ELSIF updating THEN
INSERT INTO wydarzenia VALUES (wydarzenia_seq .NEXTVAL, 'UPDATE', :new.ID_KURSU,
SYSDATE, USER);
ELSIF deleting THEN
INSERT INTO wydarzenia VALUES (wydarzenia_seq .NEXTVAL, 'DELETE', :old.ID_KURSU,
SYSDATE, USER);
END IF;
END;
/


/*zadanie 7*/

CREATE SEQUENCE zmiana_pensji_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE ZMIANY_PENSJI (
id_zmiany NUMBER NOT NULL,
pensja_stara NUMBER,
pensja_nowa NUMBER,
id_pracownika number,
data DATE NOT NULL);

CREATE OR REPLACE TRIGGER rejestracja_zmian_cen_egz
AFTER UPDATE OF pensja ON PRACOWNICY
FOR EACH ROW
BEGIN
INSERT INTO ZMIANY_PENSJI (id_zmiany, pensja_stara,
pensja_nowa,id_pracownika, data)
VALUES (wydarzenia_seq .NEXTVAL,:old.pensja, :new.PENSJA, :old.ID_PRACOWNIKA, SYSDATE);
END;
/


/*Do domu*/
/*Zad 1*/
alter table
   PRACOWNICY
DISABLE constraint
   PRAC_CH;

CREATE OR REPLACE TRIGGER pracownicy_plec
BEFORE INSERT or update ON PRACOWNICY
FOR EACH ROW
BEGIN
IF :new.plec in ('K','k','M','m') THEN
:new.plec:=upper(:new.plec);
else
RAISE_APPLICATION_ERROR(-20000, 'niewlasciwa plec');
END IF;
END;
/


/*Zad 2*/

create or replace trigger pracownicy_pesel
  before insert or update on PRACOWNICY
  for each row
  begin
    if MOD(substr(new.PESEL,10,1),2)!=0 then
    RAISE_APPLICATION_ERROR(-20000, 'niezgodna plec z peselem');
      end if;
end;

INSERT INTO PRACOWNICY VALUES(
56,'KRZYSZTOF','MIARECKI','M',TO_DATE('06/11/1987','DD/MM/YYYY'),'87110812826',
TO_DATE('11/10/2001','DD/MM/YYYY'),'KIEROWCA',1300,NULL,11,1,3);


/*Zad 3*/

create table PLACOWKI_LICZBA_OSOB(
id NUMBER CONSTRAINT PLO_PK PRIMARY KEY,
  nazwa_placowki varchar2(30),
  liczba_osob number
);

create or replace trigger PLACOWKI_OSOBY_STATYSTYKA
  before insert or delete or update on pracownicy