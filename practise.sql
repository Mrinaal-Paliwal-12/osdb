create table student(
	sid int PRIMARY KEY,
	sname VARCHAR(25) not null,
	dept varchar(20)
);

create table attendence(
	sid int not null,
	att_date DATE not null
);

alter table attendence add constraint fk_attendence_student_sid foreign key (sid) references student(sid); 

create sequence seqsid start 1 INCREMENT 1; 

insert into student values(nextval('seqsid'),'Aniket','MCA');
insert into attendence values(1,'2022-09-17');

select count(s.sname) as "Total MCA Attendence" from attendence a inner join student s on a.sid = s.sid where s.dept = 'MCA';


select s.dept as "Department", count(s.dept) as "Total Present" from attendence a inner join student s on a.sid = s.sid group by (s.dept);



select s.sname , s.dept from attendence a inner join student s on a.sid = s.sid where a.att_date = '2022-09-17';




select s.sname , count(s.sname) from attendence a inner join student s on a.sid = s.sid group by(s.sname)  order by count(s.sname) desc limit 1; 

select count(s.sname) from attendence a inner join student s on a.sid = s.sid group by(s.sname)  order by count(s.sname) desc limit 1; 


select s.sname , count(s.sname) 
from attendence a inner join student s on a.sid = s.sid 
group by(s.sname) 
having count(s.sname)=(
	select count(s.sname)
	from attendence a 
	inner join student s 
	on a.sid = s.sid 
	group by(s.sname)  
	order by count(s.sname) desc limit 1
)
order by count(s.sname);

/*
Students with highest attendence
*/
select s.sname , count(s.sname) from attendence a inner join student s on a.sid = s.sid group by (s.sname) having count(s.sname)=(
select count(s.sname) from attendence a inner join student s on a.sid = s.sid group by (s.sname) order by count(s.sname) desc limit 1
);

drop table attendence;

attendence -> sid,entrytime,exittime

create table attendence(
	sid int,
	entrytime TIMESTAMP,
	exittime TIMESTAMP
);
alter table attendence add constraint fk_attendence_student_sid foreign key (sid) references student(sid); 

insert into attendence values(
	2 , '2022-09-18 12:00:00','2022-09-18 15:00:00'
);

/*
Students on campus on 17 sept 11:45
*/
select s.sname from attendence a inner join student s on a.sid = s.sid where a.entrytime <='2022-09-17 11:45:00' and a.exittime >='2022-09-17 11:45:00';

/*
Hours attended by aniket on 17th Sept
*/
select a.exittime-a.entrytime from attendence a 
inner join student s on a.sid = s.sid 
where s.sname='Aniket' 
and a.entrytime >= '2022-09-17 00:00:00' 
and a.exittime <= '2022-09-17 23:59:59';
 
 
 


