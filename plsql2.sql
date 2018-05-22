
/*zadanie 1*/
declare sumaPensji NUMBER;
BEGIN
  select sum(PENSJA) into sumaPensji
    from PRACOWNICY
      where PLEC='M';
  DBMS_OUTPUT.put_line(sumaPensji);
end;
/*zadanie 2a*/

   CREATE OR REPLACE FUNCTION f_plec_suma_pensji
(p_pl pracownicy.PLEC%TYPE) RETURN NUMBER IS
 sumaPensji NUMBER;
BEGIN
  select sum(PENSJA) into sumaPensji
    from PRACOWNICY
  where PLEC=p_pl;
 RETURN sumaPensji;
EXCEPTION
 WHEN NO_DATA_FOUND THEN
 RAISE_APPLICATION_ERROR(-20001, 'Nie ma osob o danej plci');
END;
/*wywolanie*/

/*2b*/
DECLARE
 sumaPensji NUMBER;

BEGIN
 sumaPensji:=f_plec_suma_pensji('L');
 if sumaPensji is null then
    DBMS_OUTPUT.put_line('Blad, nie ma osob o danej plci');
   else
   DBMS_OUTPUT.put_line(sumaPensji);
 end if;

END;

SELECT line, text
FROM USER_SOURCE
WHERE name='f_plec_suma_pensji'
ORDER BY line;

/*3*/
DECLARE
z_imie PRACOWNICY.imie%TYPE;
z_nazwisko pracownicy.nazwisko%TYPE;
  z_wiek number;
CURSOR k_pracownicy IS
SELECT INITCAP(imie), INITCAP(nazwisko),trunc(months_between(sysdate,DATA_URODZENIA)/12,0)
 FROM PRACOWNICY
 ORDER BY 2,1;
BEGIN
OPEN k_pracownicy;
FETCH k_pracownicy INTO z_imie, z_nazwisko,z_wiek;
WHILE k_pracownicy%FOUND LOOP
DBMS_OUTPUT.put_line('Imię: ' || z_imie || ', nazwisko: ' || z_nazwisko|| ' wiek ' || z_wiek);
FETCH k_pracownicy INTO z_imie, z_nazwisko, z_wiek;
END LOOP;
CLOSE k_pracownicy;
END;


CREATE OR REPLACE PROCEDURE p_pracownicy_placowka
(p_nazwa PLACOWKI.NAZWA%TYPE )is
z_nazwisko PRACOWNICY.NAZWISKO%TYPE;
  z_imie PRACOWNICY.imie%TYPE;
  z_wiek number;
CURSOR k_pracownicy IS
SELECT INITCAP(imie), INITCAP(nazwisko),trunc(months_between(sysdate,DATA_URODZENIA)/12,0)
 FROM PRACOWNICY p join PLACOWKI pl on p.ID_PLACOWKI=pl.ID_PLACOWKI
  where nazwa=p_nazwa
 ORDER BY 2,1;
BEGIN
OPEN k_pracownicy;
FETCH k_pracownicy INTO z_imie,z_nazwisko,z_wiek;
WHILE k_pracownicy%FOUND LOOP
FETCH k_pracownicy INTO z_imie, z_nazwisko, z_wiek;
DBMS_OUTPUT.put_line('nazwisko: ' || z_nazwisko || ', imie: ' || z_imie|| ' wiek ' || z_wiek);
END LOOP;
CLOSE k_pracownicy;
END;
/

DECLARE
BEGIN
 p_pracownicy_placowka('COS');
  END;

