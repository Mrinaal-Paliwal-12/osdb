-- create table test1(
--     name_arr text[]
-- );
-- insert into test1 values(
--     array['mukul','himanshi']
-- );

-- select count(name_arr) from 
-- test1 where 'himanshi' = any(name_arr);
-- 
-- Json---

-- create table test6(
--     dname text,
--     spc text[]
-- );
-- insert into test6 values(

--     'shanmukh',array['mhut']

-- );
-- select dname from test6 where 'mhut' = any(spc);
-- create type componame as (
--     fname varchar(20),
--     lname varchar(20)
-- );
-- create table test2(
--     pname  componame
-- );
-- insert into test2 values(
--     ('mrinaal','paliwal')
-- );
-- select (pname).fname from test2 where (pname).lname='paliwal';

create database hospital;
-- \c hospital;



---------------Inquiry Table------------
create type ctype as enum('customer','patient'); 
create table inquiry(
custname varchar(20),
cust_tye ctype,
pno int UNIQUE,
inqdate date
);
insert into inquiry values(
    'Kunal','patient',811,'2022-09-01'
);
---------------End Inquiry Table------------



---------------Patient Table------------
create type fullname as (
    fname text,
    lname text
);
create table patient(
    pid serial PRIMARY key,
    pname fullname,
    r_date date,
    pno int UNIQUE
);
insert into patient (pname,r_date,pno) values(
    ('Gaurav','Bane'),'2022-09-02',711
);
---------------End Patient Table------------




---------------Staff Table------------
create type st_type as enum('Nurse','Ward Boy');

create table staff(
    st_id serial PRIMARY key,
    sname text,
    staff_type st_type
);

insert into staff (sname,staff_type) values(
    'Rahul' , 'Ward Boy'
);
---------------End Staff Table------------




---------------doctor Table------------
create table doctor(
    did serial PRIMARY key,
    dname fullname,
    specialization text,
    st_id int
);
alter table doctor add CONSTRAINT fk_doc_staff
FOREIGN key (st_id) REFERENCES staff(st_id);

insert into doctor (dname,specialization,st_id) values(
    ('Sangeetha','Sirsat'),'Cardialogy',1
);

---------------End doctor Table------------



---------------Treatment Table------------
create table treatment(
    tr_id serial,
    pid int,
    did int,
    disease_diagnosed text,
    prescription text,
    tdate date
);
alter table treatment add CONSTRAINT fk_tr_pid
FOREIGN key (pid) REFERENCES patient(pid);
alter table treatment add CONSTRAINT fk_tr_did
FOREIGN key (did) REFERENCES doctor(did);

insert into treatment(pid,did,disease_diagnosed,prescription,tdate) values(
    1,2,'Cancer','Chemo','2022-09-19'
);

select * from any_table;
---------------End Treatment Table------------



---------------Room Table------------
create table room(
    rid serial primary key,
    room_no int,
    r_allotted date,
    pid int,
    st_id int
);
alter table room add CONSTRAINT fk_room_staff
FOREIGN key (st_id) REFERENCES staff(st_id);
alter table room add CONSTRAINT fk_room_pid
FOREIGN key (pid) REFERENCES patient(pid);

insert into room(room_no,r_allotted,pid,st_id)
values(
    201,'2022-09-01',2,3
);
--------------End Room Table--------------



---------------Bill Table------------
create type b_type as enum('E-Banking','Cash');
create table bill(
    bid serial PRIMARY key,
    p_type b_type,
    pid int,
    bdate date,
    amount int,
    final_amount int GENERATED ALWAYS AS ((amount*118)/100) stored
);
alter table bill add constraint fk_b_pid 
FOREIGN key (pid) REFERENCES patient(pid);

insert into bill(p_type,pid,bdate,amount) 
values(
    'Cash',3,'2022-09-05',300
);
-----------------------------------------------


----Retrieve the patients registered in a particular day(Friday).----
SELECT * from patient where EXTRACT(dow FROM r_date)=5;
---------------------------------------------------------------



---Fetch the details of patients diagnosed with high fever from 1-9-2022 to 15-09-2022.--
select p.pname , p.pno , t.disease_diagnosed,t.tdate
from treatment t inner join patient p 
on t.pid = p.pid 
where t.disease_diagnosed = 'high fever' and 
    t.tdate BETWEEN '2022-09-01' and '2022-09-22';
------------------------------------------------------------------------------------------



----------------------Get the details of patients admitted during April 2022 to August 2022----------------------
select p.pname ,  p.pno , r.room_no , r.r_allotted,
s.sname from room r inner join patient p ON
r.pid = p.pid inner join staff s on 
s.st_id = r.st_id
where r.r_allotted between '2022-04-01' and '2022-08-31';
---------------------------------------------------------------------------------------------------------------


----------------------Fetch the details of doctors specialized in “Neurology”----------------------
select d.dname , d.specialization , s.sname from doctor d inner join staff s on d.st_id = s.st_id
where d.specialization = 'Neurology';
---------------------------------------------------------------------------------------------------


-------------------------------------Get the doctor’s details to whom a ward boy ‘Ajit’ has been assigned------
select d.dname , d.specialization , s.sname from doctor d inner join staff s on d.st_id = s.st_id
where s.sname = 'Ajit';
---------------------------------------------------------------------------------------------------------------


----------------Get the nurses details under Dr. Aruna------------------------------------------------------------------------------------------
select s.sname , s.staff_type , d.dname as "Under Doctor" from staff s inner join doctor d on d.st_id = s.st_id where (d.dname).fname = 'Aruna';
------------------------------------------------------------------------------------------------------------------------------------------------


----------------Get the details of patients under the care of a particular nurse----------------
select p.pname , t.disease_diagnosed , r.room_no, r.r_allotted , s.sname , s.staff_type
from room r inner join patient p on r.pid = p.pid 
inner join treatment t on t.pid = p.pid 
inner join staff s on r.st_id = s.st_id where s.sname = 'Shafiya'; 
------------------------------------------------------------------------------------------------


----------------Get the total amount collected in the month of August 2022 by cash payment------
select sum(final_amount) from bill where p_type = 'Cash' group by p_type ;
--------------------------------------------------------------------------------


----------------Get the average amount collected by E-banking--------------------------------
select avg(final_amount) from bill where p_type = 'E-Banking' group by p_type ;
------------------------------------------------------------------------------------------------


------------Get the details of call received from existing patients on 15-09-2022. -----------------------
select a.pname as "Existing Patient", a.pno , 
b.inqdate , a.r_date from patient a inner join inquiry b on a.pno = b.pno where b.inqdate = '2022-09-15';
----------------------------------------------------------------------------------------------------------