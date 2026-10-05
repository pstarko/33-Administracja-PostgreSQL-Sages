--Weryfikacja działania postgresa 

systemctl status postgresqln

--Uruchamianie, zatrzymywanie i restart PostgreSQL za pomocą systemctl 


--zatrzymanie klastra
systemctl stop postgresql

--start klastra
systemctl start postgresql

--Sprawdzenie otwartego portu nmapem: 
nmap localhost


--pokaż gdzie jest główny katalog

show data_directory

-- dostępne bazy danych
select oid, datname from pg_database;


-- plik konfiguracyjny postgresql.conf i pg_hba.conf
show config_file;


--sprawdzanie wielkości baz danych
select
	datname,
	pg_database_size(datname),
	pg_size_pretty(pg_database_size(datname))	
	from pg_database;


	
--Sprawdzanie przestrzeni tabel, w której mieści się baza danych 

select datname,spcname 
from pg_database d join pg_tablespace t on t.oid=d.dattablespace; 


--Sprawdzanie, kto jest właścicielem bazy danych

SELECT datname, pg_get_userbyid(datdba) FROM pg_database; 


SELECT datname,datdba::regrole FROM pg_database; 

--Sprawdzanie parametrów ustawionych indywidualnie dla bazy

select * from pg_db_role_setting; 

-- Tworzenie bazy danych

create database druga; 

create database trzecia with template=druga; 


create database czwarta tablespace=pg_default; 


create database piata owner=dzik; 

--Zmiana właściciela bazy danych 

alter database nowa owner to dzik; 


--Konfiguracja indywidualnych parametrów bazy danych 

alter database nowa set random_page_cost=1; 

select datname,setconfig from 
pg_db_role_setting s join pg_database d on s.setdatabase=d.oid;


--Konfiguracja parametrów:

--Sprawdzanie parametrów klastra 

select * from pg_settings; 

show archive_mode

select name,setting from pg_settings where name='log_line_prefix'; 

select * from pg_file_settings;

--Sprawdzanie dostępnych poziomów konfiguracji 

select distinct context from pg_settings; 


/*
Co oznaczają poszczególne wartości? 

	internal - Takie parametry to wartości ustalone wewnętrznie. 
				Nie można ich zmieniać bezpośrednio. Są to takie parametry, jak np. wersja oprogramowania PostgreSQL. 
	
	postmaster- Zmiana takich parametrów wymaga restartu. 
				Są to takie parametry, jak np. wielkość pamięci dostępnej dla klastra PostgreSQL 
	
	sighub - Zmiana wymaga tylko przeładowania konfiguracji klastra (choć może być też restart). 
	
	backend - Takie parametry można ustawić tylko w chwili nawiązywania połączenia z PostgreSQL. 
				Mogą też być zmieniane przez przeładowanie konfiguracji. 
	
	superuser - Parametry, które może ustawić tylko superuser klastra. 
					Do ich zmiany wymagane jest przeładowanie konfiguracji (choć może być też restart). 
	
	superuser-backend -Takie parametry można ustawić w chwili nawiązywania połączenia z PostgreSQL przez użytkownika lub dla klastra. 
					Zmiana takich parametrów dla klastra wymaga przeładowania konfiguracji. 
					Są to parametry umożliwiające np. logowanie wszystkich połączeń. 
	
	user - Te parametry mogą być zmieniane nawet przez zwykłego użytkownika na poziomie trwającej sesji. 
				Przez superużytkownika mogą być dodatkowo ustawiane na poziomie klastra,bazy danych, 
					użytkownika czy użytkownika w wybranej bazie. Zmiana takich parametrów dla całego klastra będzie wymagała przeładowania konfiguracji. 

*/

show work_mem; 

set work_mem='16MB'; 

select * from pg_settings where name='work_mem'; 

select pg_reload_conf()

show all;

-- resetowanie domyślnych ustawień
reset work_mem; 

alter database test_config set work_mem='123MB';


select datname,setconfig from pg_db_role_setting pdrs join pg_database pd 
on pdrs.setdatabase=pd.oid; 


create user dzik with password 'dzik'; 
alter user dzik set work_mem='40MB'; 

select usename, useconfig from pg_shadow; 


--Resetowanie ustawień dla bazy danych, użytkownika do domyślnych Wartości

alter role dzik reset work_mem; 
alter database test_config reset work_mem; 
alter role dzik in database test_config reset work_mem; 

--postgresql.conf vs postgresql.auto.conf 

/*

Parametry zmieniane poprzez "alter system" będą gromadzone w osobnym pliku konfiguracyjnym tj. "postgresql.auto.conf" 
znajdującym się obok "postgresql.conf' 

Parametry ustawiane poprzez "alter system" są wprowadzane do "postgresql.auto.conf', a nie aktualizowane w "postgresql.conf'. 
*/









