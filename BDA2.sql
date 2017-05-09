-- Database: bda2

--DROP DATABASE bda2;

CREATE DATABASE bda2
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'en_US.UTF-8'
       LC_CTYPE = 'en_US.UTF-8'
       CONNECTION LIMIT = -1;

CREATE EXTENSION postgis;

CREATE TABLE pais (
	sigla char(3) unique not null,
	nome varchar(50) not null,	
	primary key (sigla)
);

SELECT AddGeometryColumn('pais','geom','4326','MULTIPOLYGON',2);


CREATE TABLE pessoa (
	cod serial,
	nome varchar(150) not null,
	nascimento date not null,
	pais_nascimento char(3) references pais(sigla)
	on update cascade
	on delete no action,
	primary key (cod)
);

CREATE TABLE cidade (
	gid serial,
	nome varchar (40) not null,
	country varchar(12),
	population float8,
	"capital" varchar(1),
	primary key (gid)
);

SELECT AddGeometryColumn('cidade','geom','4326','POINT',2);

CREATE TABLE  copa(
	ano int unique not null,
	inicio date not null, 
	fim date not null,
	cidade int not null references cidade(gid),
	primary key (ano)
);

CREATE TABLE jogo(
	id serial,
	ano int not null references copa(ano)
	on update cascade
	on delete no action,
	estadio varchar (100) not null,
	dia date not null,
	hora time not null,
	primary key (id)
);
CREATE TABLE sede(
	ano int unique not null references copa(ano)
	on update cascade
	on delete no action,
	sigla char(3) not null references pais(sigla)
	on update cascade
	on delete no action,
	primary key (ano)
);

CREATE TABLE jogador(
	selecao char(3) not null references pais(sigla)
	on update cascade
	on delete no action,
	
	ano int not null references copa(ano)
	on update cascade
	on delete no action,
	
	cod int references pessoa(cod)
	on update cascade
	on delete no action,
	
	primary key (cod, ano, selecao)
);
CREATE TABLE equipe (
	sigla char(3) not null references pais(sigla)
	on update cascade
	on delete no action,

	ano int not null references copa(ano)
	on update cascade
	on delete no action,

	treinador int not null references pessoa(cod)
	on update cascade
	on delete no action,

	primary key (sigla,ano)
);

CREATE TABLE eqJogo(
	jogo int references jogo(id),
	pais1 char(3) references pais(sigla),
	gols1 int,
	pais2 char(3) references pais(sigla),
	gols2 int,
	
	primary key (jogo)

);


INSERT INTO pessoa (nome, nascimento, pais_nascimento) values 
('Son Goku', '05 Aug 1989', 'JPN'),
('Himura Kenshin', '12 Apr 1990', 'JPN'),
('Okumura Rin', '25 Dec 1995', 'JPN'),
('Ludwig Beilschmidt', '18 Jan 1971', 'GMN'),
('Johann Sebatian Bach', '21 Mar 1685', 'GMN'),
('Mauricio de Souza', '27 Oct 1935', 'BRA'),
('Jose de Alencar', '12 Dec 1877', 'BRA'),
('Barack Obama', '05 Jun 1988', 'USA'),
('Jake Long', '22 Nov 1996', 'USA'),
('Van Gogh', '29 Jul 1890', 'NED'),
('Victor Hugo', '22 May 1885', 'FRA'),
('Jean Valjean', '20 Apr 1888', 'FRA'),
('Kurosaki Tasuku', '13 Jul 1993', 'JPN'),
('Harry Potter','31 Jul 1980', 'UKI'),
('Ronald Weasley','3 Sep 1979', 'UKI'),
('Peter Pan','04 Dec 1960', 'UKI'),
('Hercules','24 Oct 1988', 'GRE'),
('Tutankhamun','2 Feb 1993', 'EGY'),
('Ezio Auditore','03 May 1990', 'ITA');

INSERT INTO copa (ano, inicio, fim, cidade) values
(2022,'10 Jun 2022','11 Jul 2022','183'),
(2018,'12 Jun 2018','13 Jul 2014','1'),
(2014,'12 Jun 2014','13 Jul 2014','256'),
(2010,'8 Jun 2010','9 Jul 2010','263'),
(2006,'30 May 2006','30 Jun 2006','13');

INSERT INTO sede (ano, sigla) values
(2022, 'QAT'),
(2018, 'RUS'),
(2014, 'BRA'),
(2010, 'SAF'),
(2006, 'GMN');

INSERT INTO equipe (sigla, ano, treinador) values
('JPN',2018,1),
('JPN',2014,2),
('GMN',2018,4),
('GMN',2014,5),
('RUS',2018,8),
('RUS',2022,8),
('FRA',2018,11),
('FRA',2014,10),
('NED',2018,10),
('BRA',2014,7),
('BRA',2018,6);

INSERT INTO jogador (selecao, ano, cod) values
('JPN',2018,3),
('JPN',2018,13),
('JPN',2014,3),
('JPN',2014,13),
('GMN',2018,5),
('GMN',2018,19),
('GMN',2014,4),
('GMN',2014,19),
('RUS',2018,16),
('RUS',2014,16),
('FRA',2014,10),
('FRA',2018,17),
('FRA',2018,14),
('NED',2018,15),
('NED',2018,9),
('BRA',2014,18),
('BRA',2018,7);

INSERT INTO jogo (ano, estadio, dia, hora) values 
(2014, 'Mineirao', '8 Jul 2014', '14:00'),
(2014, 'Mane Garrincha', '9 Jul 2014', '15:00'),
(2014, 'Maracana', '10 Jul 2014', '16:00'),
(2018, 'Moscow Stadium', '2 Jul 2018', '14:30'),
(2018, 'Saint Petersburg Stadium', '3 Jul 2018', '15:30'),
(2018, 'Moscow Stadium', '4 Jul 2018', '17:30'),
(2018, 'Saint Petersburg Stadium', '4 Jul 2018', '14:30');


INSERT INTO eqJogo(jogo, pais1, gols1, pais2, gols2) values
(1,'BRA',1,'GMN',7),
(2,'JPN',1,'FRA',2),
(3,'FRA',0,'GMN',1),
(4,'BRA',0,'GMN',8),
(5,'JPN',1,'FRA',0),
(6,'JPN',Null,'GMN',null);


select * from pais;
select * from pessoa;
select * from equipe;
select * from jogador;
select * from jogo;
select * from eqJogo;
select * from copa;
select * from sede;

CREATE VIEW query1 AS
SELECT c.gid, c.nome, c.geom
FROM cidade as c, pais as p
where st_contains (p.geom,c.geom) and p.nome = 'Japan';

CREATE VIEW query2 AS
SELECT p1.nome, p1.sigla, p1.geom
from pais as p1, pais as p2
where st_touches (p1.geom, p2.geom) and p2.nome = 'Germany' and p1.nome <> 'Germany';

CREATE VIEW query3 AS
SELECT c2.nome, c2.gid, c2.geom
from cidade as c1, cidade as c2
where st_dwithin(c1.geom, c2.geom, 2000000, true) and c1.nome = 'Vancouver' and c1.nome <> c2.nome

CREATE VIEW query4 AS
SELECT p1.nome as pais,  p1.sigla, st_area(p1.geom), count(c1.nome),p1.geom
from pais as p1, cidade as c1
where st_contains (p1.geom,c1.geom) and (p1.nome = 'Myanmar' or p1.nome = 'Greece')
group by (p1.sigla);

CREATE VIEW query5 AS
SELECT c.ano, p.nome as pais, ci.nome as cidade, ci.gid, ci.geom
from pais p, copa c, sede s, cidade ci
where p.sigla = s.sigla and c.ano = s.ano and st_contains (p.geom,ci.geom)
order by c.ano asc;


select * from query1;
select * from query2;
select * from query3;
select * from query4;
select * from query5;
