drop table Configuracoes
drop table GrupoConfiguracoes 

create table GrupoConfiguracoes (
	gruconfid int IDENTITY(1,1) NOT NULL,
	gruconfnome varchar(255) NOT NULL,
	configdescricao text,	
)

ALTER TABLE GrupoConfiguracoes
ADD CONSTRAINT PK_GrupoConfiguracoes PRIMARY KEY (gruconfid);

ALTER TABLE GrupoConfiguracoes
ADD CONSTRAINT UC_GrupoConfiguracoes_Nome UNIQUE (gruconfnome);

CREATE TABLE Configuracoes (	
	configid int IDENTITY(1,1),
	gruconfid int NOT NULL,
	confignome varchar(255) NOT NULL,
	configdescricao text,
	configvalor text
)

ALTER TABLE Configuracoes
ADD CONSTRAINT PK_Configuracoes PRIMARY KEY (configid);


ALTER TABLE Configuracoes
ADD CONSTRAINT UC_Configuracoes_Nome UNIQUE (confignome);


ALTER TABLE Configuracoes
ADD CONSTRAINT FK_GrupoConfiguracoes
FOREIGN KEY (gruconfid) REFERENCES GrupoConfiguracoes(gruconfid);