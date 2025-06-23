create database db
use db

CREATE TABLE Employee (
SSN int primary key identity (1,1) ,
BD date, 
Gender char(1), 
Fname varchar(50), 
Lname varchar(50), 
superid int, 
DNum int
foreign key (superid) references Employee (SSN)
);


CREATE TABLE Department(
DNum int primary key identity (1,1), 
SSN int, 
DName varchar(50), 
hiredate date,
foreign key (SSN) references Employee (SSN)
);

alter table Employee 
add foreign key (DNum) references Department (DNum)

CREATE TABLE Locations(
DNum int, 
location varchar (100),
foreign key (DNum) references Department (DNum)
);

CREATE TABLE Project(
PNum int primary key identity (1,1), 
Pname varchar (50), 
city varchar (50), 
location varchar (100), 
DNum int,
foreign key (DNum) references Department (DNum)
);


CREATE TABLE work(
SSN int, 
Pnum int, 
hours int, 
primary key (SSN , Pnum),
foreign key (SSN) references Employee (SSN),
foreign key (Pnum) references Project (Pnum)
);

CREATE TABLE Dependent(
Depname varchar, 
Gender char (1), 
BD date, 
SSN int,
primary key (Depname, SSN),
foreign key (SSN) references Employee (SSN)
);