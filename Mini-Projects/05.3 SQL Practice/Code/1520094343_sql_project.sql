/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

SELECT *
FROM country_club.Facilities
WHERE membercost > 0
LIMIT 0 , 30

5 rows show up, so 5.

/* Q2: How many facilities do not charge a fee to members? */

SELECT *
FROM country_club.Facilities
WHERE membercost = 0
LIMIT 0 , 30

4 rows show up, so 4.

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT name, membercost, monthlymaintenance
FROM country_club.Facilities
WHERE membercost > 0
AND membercost < (.2 * monthlymaintenance)
LIMIT 0 , 30

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

SELECT *
FROM country_club.Facilities
WHERE facid IN (1,5)
LIMIT 0 , 30

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT name, monthlymaintenance,
CASE 	WHEN monthlymaintenance > 100 THEN 'expensive'
	ELSE 'cheap' END AS list
FROM country_club.Facilities
LIMIT 0 , 30

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

SELECT firstname, surname
FROM country_club.Members
ORDER BY joindate DESC

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT CASE WHEN bookings.facid = 0 THEN 'Tennis Court 1'
	WHEN bookings.facid = 1 THEN 'Tennis Court 2'
ELSE NULL END AS Court,
CONCAT(members.firstname, ' ', members.surname) as member_name
FROM country_club.Members members
JOIN  country_club.Bookings bookings
ON members.memid = bookings.memid
AND facid IN (0, 1)
GROUP BY 1, 2
ORDER BY 2

/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT facilities.name,
CONCAT(members.firstname, ' ', members.surname) as member_name,
CASE WHEN facilities.membercost > facilities.guestcost THEN facilities.membercost
	ELSE facilities.guestcost END AS cost

FROM country_club.Bookings bookings
LEFT JOIN  country_club.Facilities facilities
ON facilities.facid = bookings.facid
LEFT JOIN  country_club.Members members
ON members.memid = bookings.memid

WHERE bookings.starttime LIKE '2012-09-04%'
AND (facilities.membercost > 30 OR  facilities.guestcost >30)
ORDER BY 3 DESC

/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT facilities.name,
CONCAT(members.firstname, ' ', members.surname) as member_name,
CASE WHEN facilities.membercost > facilities.guestcost THEN facilities.membercost
	ELSE facilities.guestcost END AS cost

FROM 
(SELECT *
FROM country_club.Bookings
WHERE starttime LIKE '2012-09-04%') bookings
JOIN  country_club.Facilities facilities
ON facilities.facid = bookings.facid
JOIN  country_club.Members members
ON members.memid = bookings.memid

WHERE (facilities.membercost > 30 OR  facilities.guestcost >30)


/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT *
FROM 
(
SELECT facilities.name,
SUM(CASE WHEN bookings.memid = 0 THEN bookings.slotS * facilities.guEstcost
	ELSE bookings.slotS * facilities.membercost END) AS revenue

FROM country_club.Bookings bookings
LEFT JOIN country_club.Facilities facilities
ON facilities.facid = bookings.facid
GROUP BY facilities.name
    ) a
WHERE revenue < 1000
ORDER BY revenue
