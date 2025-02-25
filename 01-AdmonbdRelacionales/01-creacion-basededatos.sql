-- Creación de una base de datos
create database paquitabd
on primary 
(
   Name=paquitabdData, filename='/var/opt/mssql/data/datanueva/paquitabd.mdf'
   ,size = 50MB -- El tamaño minimo es 512kb, el predeterminado es 1MB
   ,Filegrowth=25% -- El default es 10%, -- El minimo es de 64kb
   ,maxsize = 400MB 
)
log on
(
   Name=paquitabdLog, filename='/var/opt/mssql/data/lognueva/paquitabd_log.ldf',
   size = 25MB,
   Filegrowth=25%
)

-- Crear un archivo adicional
alter database paquitabd
ADD FILE 
(
  NAME='PaquitaDataNDF', 
  FILENAME = '/var/opt/mssql/data/datanueva/paquitabd2.ndf',
  SIZE = 25MB, 
  MAXSIZE=500MB, 
  FILEGROWTH=10MB  -- El minimo es de 64kb
)TO FILEGROUP[PRIMARY]; 


-- Creación de un FileGroup Adicional
Alter DATABASE paquitabd
ADD FILEGROUP SECUNDARIO
GO

-- CREACIÓN DE UN ARCHIVO ASOCIAO AL FILEGROUP
ALTER DATABASE paquitabd
ADD FILE (
   NAME='paquitabd_parte1',
   FILENAME='/var/opt/mssql/data/datanueva/paquitabd_SECUNDARIO.ndf'	
)TO FILEGROUP SECUNDARIO


use paquitabd
go
-- crear una tabla en el grupo de archivos (filegroups) Secundario
create table ratadedospatas(
	id int not null identity(1,1),
	nombre nvarchar(100) not null, 
	constraint pk_ratadedospatas
	primary key (id), 
	constraint unico_nombre
	unique(nombre)
)ON Secundario; -- Especificamos el grupo de archivos

create table bichorastrero(
	id int not null identity(1,1),
	nombre nvarchar(100) not null, 
	constraint pk_animalrastrero
	primary key (id), 
	constraint unico_nombre2
	unique(nombre)
)

-- Modificar el Grupo Primario

use master

ALTER DATABASE paquitabd
MODIFY FILEGROUP [SECUNDARIO] DEFAULT

USE paquitabd

create table comparadocontigo(
	id int not null identity(1,1),
	nombredelanimal nvarchar(100) not null, 
	defectos nvarchar(max) not null,
	constraint pk_comparadocontigo
	primary key (id), 
	constraint unico_nombre3
	unique(nombredelanimal)
)

-- REVISION DEL ESTADO DE LA OPCIÓN DE AJUSTE AUTOMATO DEL TAMAÑO DE ARCHIVOS

SELECT DATABASEPROPERTYEX('paquitabd', 'ISAUTOSHRINK')

-- Cambia la opción de AutoShrink a true
ALTER DATABASE paquitabd
SET AUTO_SHRINK ON WITH NO_WAIT
go

-- REVISION DEL ESTADO DE LA OPCIÓN DE CREACIÓN DE ESTADISTICAS
SELECT DATABASEPROPERTYEX('paquitabd', 'IsAutoCreateStatistics')

ALTER DATABASE paquitabd
SET AUTO_CREATE_STATISTICS ON
Go

-- Consultar información de la base de datos
use master
go
SP_helpdb paquitabd
go

USE paquitabd
go
-- Consultar la información de grupos
SP_HELPFILEGROUP SECUNDARIO


