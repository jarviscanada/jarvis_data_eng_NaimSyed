# Introduction
This is a project to demonstrate basic knowledge of CRUD operations using SQL. 


# SQL Queries

###### Table Setup (DDL)
```
CREATE TABLE cd.members (
  memid int NOT NULL, 
  surname varchar(200) NOT NULL, 
  firstname varchar(200) NOT NULL, 
  address varchar(300) NOT NULL, 
  zipcode int NOT NULL, 
  telephone varchar(20) NOT NULL, 
  recommendedby int, 
  joindate timestamp NOT NULL, 
  CONSTRAINT members_pk PRIMARY KEY (memid), 
  CONSTRAINT fk_members_recommendedby FOREIGN KEY (recommendedby) REFERENCES cd.members(memid) ON DELETE 
  SET 
    NULL
);

CREATE TABLE cd.facilities (
  facid int NOT NULL, 
  name varchar(100) NOT NULL, 
  membercost numeric NOT NULL, 
  guestcost numeric NOT NULL, 
  initialoutlay numeric NOT NULL, 
  monthlymaintenance numeric NOT NULL, 
  CONSTRAINT facilities_pk PRIMARY KEY (facid)
); 

CREATE TABLE cd.facilities (
  facid int NOT NULL, 
  name varchar(100) NOT NULL, 
  membercost numeric NOT NULL, 
  guestcost numeric NOT NULL, 
  initialoutlay numeric NOT NULL, 
  monthlymaintenance numeric NOT NULL, 
  CONSTRAINT facilities_pk PRIMARY KEY (facid)
);

CREATE TABLE cd.bookings (
  bookid int NOT NULL, 
  facid int NOT NULL, 
  memid int NOT NULL, 
  starttime timestamp NOT NULL, 
  slots int NOT NULL, 
  CONSTRAINT bookings_pk PRIMARY KEY (bookid), 
  CONSTRAINT fk_bookings_facid FOREIGN KEY (facid) REFERENCES cd.facilities(facid), 
  CONSTRAINT fk_bookings_memid FOREIGN KEY (memid) REFERENCES cd.members(memid)
);
```


##### SECTION 1: Modifying Data
###### 1. Insert Data
link: https://pgexercises.com/questions/updates/insert.html

```
INSERT INTO cd.facilities
VALUES (9,'Spa', 20, 30, 100000, 80);
```

###### 2. Insert Calculated Data
https://pgexercises.com/questions/updates/insert3.html  

```
INSERT INTO cd.facilities
VALUES
  (
    (
      SELECT
        max(facid)
      FROM
        cd.facilities
    )+ 1,
    'Spa',
    20,
    30,
    100000,
    800
  );
```

###### 3. Update Existing Data

link: https://pgexercises.com/questions/updates/update.html

```
UPDATE
  cd.facilities
SET
  initialoutlay = 10000
WHERE
  name = 'Tennis Court 2';
```

###### 4. Update Rows

Link: https://pgexercises.com/questions/updates/updatecalculated.html

```
update
  cd.facilities
set
  membercost = (
    select
      membercost * 1.1
    from
      cd.facilities
    where
      facid = 0
  ),
  guestcost = (
    select
      guestcost * 1.1
    from
      cd.facilities
    where
      facid = 0
  )
where
  facid = 1;
```

###### 5. Delete All Bookings

Link: https://pgexercises.com/questions/updates/delete.html

```
DELETE FROM 
  cd.bookings;
```

###### 6. Delete a Member

Link: https://pgexercises.com/questions/updates/deletewh.html

```
DELETE FROM
  cd.members
WHERE
  memid = 37;
```

##### SECTION 2: Query Basics

###### 1. Where Conditions
Link: https://pgexercises.com/questions/basic/where2.html

```
SELECT
  facid,
  name,
  membercost,
  monthlymaintenance
FROM
  cd.facilities
WHERE
  membercost < (monthlymaintenance * 1 / 50)
  and membercost > 0
```

###### 2. String Search
Link: https://pgexercises.com/questions/basic/where3.html

```
SELECT
  *
FROM
  cd.facilities
WHERE
  name LIKE '%Tennis%';
```

###### 3. Matching against multiple possible values
Link: https://pgexercises.com/questions/basic/where4.html 

```
SELECT
  *
FROM
  cd.facilities
WHERE
  facid IN (1, 5);
```

###### 4. Working with Dates

Link: https://pgexercises.com/questions/basic/date.html 

```
SELECT 
  memid, 
  surname, 
  firstname, 
  joindate 
FROM 
  cd.members 
WHERE 
  joindate > '2012-09-01';
```

###### 5.Combining Multiple Query Results

Link: https://pgexercises.com/questions/basic/union.html 

```
SELECT
  surname
FROM
  cd.members
UNION
SELECT
  name
FROM
  cd.facilities;
```

##### SECTION 3: JOIN

######1. Inner Joins with Conditions 
Link:https://pgexercises.com/questions/joins/simplejoin.html 

```
SELECT
  b.starttime
FROM
  cd.bookings as b
  JOIN cd.members as m ON b.memid = m.memid
WHERE
  m.surname = 'Farrell'
  and m.firstname = 'David';
```

###### 2. Inner Joins with Conditions 2
Link: https://pgexercises.com/questions/joins/simplejoin2.html 

```
SELECT
  b.starttime,
  f.name
FROM
  cd.bookings as b
  JOIN cd.facilities as f ON b.facid = f.facid
WHERE
  b.starttime >= '2012-09-21'
  and b.starttime < '2012-09-22'
  and name LIKE 'Tennis%'
ORDER BY
  b.starttime
```

###### 3. Self Left Join 
Link: https://pgexercises.com/questions/joins/self2.html

```
SELECT
  a.firstname as memfname,
  a.surname as memsname,
  b.firstname as recfname,
  b.surname as recsname
FROM
  cd.members as a
  LEFT JOIN cd.members as b ON b.memid = a.recommendedby
ORDER BY
  a.surname,
  a.firstname;
```

###### 4. Self Join
Link: https://pgexercises.com/questions/joins/self.html

```
SELECT
  DISTINCT a.firstname,
  a.surname
FROM
  cd.members as a
  JOIN cd.members as b ON a.memid = b.recommendedby
ORDER BY
  a.surname,
  a.firstname;
```

###### 5. Self Subquery
Link: https://pgexercises.com/questions/joins/sub.html

```
SELECT
  DISTINCT CONCAT(firstname, ' ', surname) as member,
  (
    SELECT
      CONCAT(firstname, ' ', surname) as recommender
    FROM
      cd.members as b
    WHERE
      b.memid = a.recommendedby
  )
FROM
  cd.members as a;
```

##### SECTION 4: Aggregation

###### 1. Count Group By
Link: https://pgexercises.com/questions/aggregates/count3.html

```
SELECT
  recommendedby,
  count(memid)
FROM
  cd.members
WHERE
  recommendedby IS NOT NULL
GROUP BY
  recommendedby
ORDER BY
  recommendedby;
```

###### 2. Sum Group By
Link: https://pgexercises.com/questions/aggregates/fachours.html 

```
SELECT
  facid,
  SUM(slots) as Total_Slots
FROM
  cd.bookings
GROUP BY
  facid
ORDER BY
  facid;
```

###### 3. SUM Group By in Date Range
Link: https://pgexercises.com/questions/aggregates/fachoursbymonth.html

```
SELECT 
  facid, 
  SUM(slots) as Total_Slots 
FROM 
  cd.bookings 
WHERE 
  starttime > '2012-09-01' 
  and starttime < '2012-10-01' 
GROUP BY 
  facid 
ORDER BY 
  Total_Slots;
```

###### 4. List the total slots booked per facility per month
Link: https://pgexercises.com/questions/aggregates/fachoursbymonth2.html

```
SELECT
  facid,
  EXTRACT(
    month
    from
      starttime
  ) as Month,
  SUM(slots) as Total_Slots
FROM
  cd.bookings
WHERE
  starttime > '2012-01-01'
  and starttime < '2013-01-01'
GROUP BY
  facid,
  Month
ORDER BY
  facid,
  Month;
```

###### 5. Count of members who have made at least one booking
Link: https://pgexercises.com/questions/aggregates/members1.html

```
SELECT
  COUNT(DISTINCT m.memid)
FROM
  cd.members as m
  JOIN cd.bookings as b ON m.memid = b.memid;
```

###### 6. List each member's first booking after September 1st 2012
Link: https://pgexercises.com/questions/aggregates/nbooking.html

```
SELECT 
  m.surname, 
  m.firstname, 
  m.memid, 
  MIN(b.starttime) as starttime 
FROM 
  cd.members as m 
  JOIN cd.bookings as b ON m.memid = b.memid 
WHERE 
  b.starttime > '2012-09-01' 
GROUP BY 
  m.surname, 
  m.firstname, 
  m.memid 
ORDER BY 
  m.memid;
```

###### 7. Window Functions
Link: https://pgexercises.com/questions/aggregates/countmembers.html 

```
SELECT
  count(*) OVER(),
  firstname,
  surname
FROM
  cd.members
ORDER BY
  joindate;
```

###### 8. Window Functions - Row Number 
Link: https://pgexercises.com/questions/aggregates/nummembers.html

```
SELECT
  ROW_NUMBER() OVER(),
  firstname,
  surname
FROM
  cd.members
ORDER BY
  joindate;
```

###### 9. Window Functions - Rank
Link: https://pgexercises.com/questions/aggregates/fachours4.html

```
select
  facid,
  total
from
  (
    select
      facid,
      sum(slots) total,
      rank() over (
        order by
          sum(slots) desc
      ) rank
    from
      cd.bookings
    group by
      facid
  ) as ranked
where
  rank = 1;
```

##### SECTION 5: String
###### 1. Concatenate
Link: https://pgexercises.com/questions/string/concat.html 

```
SELECT
  CONCAT(Surname, ', ', Firstname)
FROM
  cd.members;
```

###### 2. Formatted Strings
Link: https://pgexercises.com/questions/string/reg.html 

```
SELECT
  memid,
  telephone
FROM
  cd.members
WHERE
  telephone LIKE '(%)%';
```

###### 3. Substring
Link: https://pgexercises.com/questions/string/substr.html

```
SELECT
  SUBSTR(surname, 1, 1) as letter,
  count(*)
FROM
  cd.members
GROUP BY
  letter
ORDER BY
  letter;
```


