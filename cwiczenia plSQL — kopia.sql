
/*zad1*/
begin
  dbms_output.put_line('pracujesz na koncie uzytkownika '||user||', dzisiejsza data: '||to_char(sysdate,'MONTH'));
end;


/*zad2*/
  declare
    z_imie varchar2(10):='Tomasz';
z_nazwisko varchar2(15):='Nowak';
    z_pensja float:=2890.58;
  begin
    dbms_output.put_line('Osoba: '||initcap(z_imie)||' '||initcap(z_nazwisko)||' pensja: '||z_pensja);
  end;

/*zad3a*/

declare
z_liczba number;
  begin
select count(*)
  into z_liczba
  from PRACOWNICY
    where to_char(DATA_ZATRUDNIENIA,'YYYY')='1999';
end;

/*zad3b*/

declare
z_liczba number;
  begin
select count(*)
  into z_liczba
  from PRACOWNICY
    where to_char(DATA_ZATRUDNIENIA,'YYYY')='1999';
  if mod(z_liczba,2)=0 then dbms_output.put_line('W 1999 roku została zatrudniona parzysta liczba pracowników')
    else dbms_output.put_line('W 1999 roku została zatrudniona nieparzysta liczba pracowników')
    end if;
end;

/*zad4*/

declare
z_id pracownicy.id_pracownika%type:=2;
z_imie PRACOWNICY.imie1%TYPE;
z_nazwisko PRACOWNICY.nazwisko%TYPE;
z_pensja float;
  begin
  select imie1, NAZWISKO,12*PENSJA+DODATEK
    into z_imie,z_nazwisko,z_pensja
    from PRACOWNICY
    where id_pracownika=z_id;
  DBMS_OUTPUT.put_line('Imie: ' || z_imie || ' nazwisko: ' || z_nazwisko || ', płeć: '
|| z_pensja);
end;

/*zad5*/
declare
  z_imie PRACOWNICY.imie%TYPE;
  z_nazwisko Pracownicy.nazwisko%type;
  z_pensja pracownicy.pensja%type;

  cursor k_pracownicy is

SELECT INITCAP(imie), INITCAP(nazwisko), PENSJA
 FROM PRACOWNICY
 ORDER BY 2,1;
BEGIN
OPEN k_pracownicy;
LOOP
 FETCH k_pracownicy INTO z_imie, z_nazwisko, z_pensja;
 EXIT WHEN k_pracownicy%NOTFOUND;
 DBMS_OUTPUT.put_line('Imię: ' || z_imie || ', nazwisko: ' || z_nazwisko||' '||z_pensja);
END LOOP;
CLOSE k_pracownicy;
end;

/*zad6*/

