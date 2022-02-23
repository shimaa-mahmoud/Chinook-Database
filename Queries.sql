/*using the chinook database*/
-- Which countries have the most Invoices?
SELECT billingcountry,
       Count(total)
FROM   invoice
GROUP  BY 1
ORDER  BY 2 DESC;

-- Which city has the best customers?
--the city we made the most money
SELECT billingcity,
       Sum(total)
FROM   invoice
GROUP  BY 1
ORDER  BY 2 DESC;

-- Who is the best customer?
-- The customer who has spent the most money will be declared the best customer
SELECT c.customerid,
       c.firstname,
       c.lastname,
       Sum(total)
FROM   invoice i
       INNER JOIN customer c using(customerid)
GROUP  BY 1,
          2,
          3
ORDER  BY 4 DESC;

/* Use your query to return the email, first name, last name, and Genre of all Rock Music listeners
(Rock & Roll would be considered a different category for this exercise).
Return your list ordered alphabetically by email address starting with A */
SELECT DISTINCT( c.email ),
               c.firstname,
               c.lastname,
               g.NAME
FROM   genre g
       INNER JOIN track t
               ON t.genreid = g.genreid
                  AND g.NAME = "rock"
       INNER JOIN invoiceline il using(trackid)
       INNER JOIN invoice i using(invoiceid)
       INNER JOIN customer c using(customerid)
ORDER  BY c.email

-- Who is writing the rock music?
/*Let's invite the artists who have written the most rock music in our dataset*/
SELECT Ar.NAME,
       Count(*)
FROM   genre g
       INNER JOIN track t
               ON t.genreid = g.genreid
                  AND g.NAME = "rock"
       INNER JOIN album Al using(albumid)
       INNER JOIN artist Ar using(artistid)
GROUP  BY 1
ORDER  BY 2 DESC

-----------------------------------------
-- find which artist has earned the most according to the InvoiceLines?
SELECT AR.NAME,
       Sum(IL.unitprice * IL.quantity)AS total
FROM   artist AR
       JOIN album AL
         ON AR.artistid = AL.artistid
       JOIN track T
         ON AL.albumid = T.albumid
       JOIN invoiceline IL
         ON T.trackid = IL.trackid
GROUP  BY 1
ORDER  BY 2 DESC

-- find which playlist type make more money
SELECT p.NAME,
       Sum(IL.unitprice * IL.quantity) AS total_usd
FROM   playlist p
       JOIN playlisttrack pt
         ON pt.playlistid = p.playlistid
       JOIN track T
         ON T.trackid = pt.trackid
       JOIN invoiceline IL
         ON T.trackid = IL.trackid
GROUP  BY 1
ORDER  BY 2 DESC

-- find which playlist genere of the "Music" playlist make more money
SELECT g.NAME,
       Sum(IL.unitprice * IL.quantity)AS total_usd
FROM   playlist p
       JOIN playlisttrack pt
         ON pt.playlistid = p.playlistid
       JOIN track T
         ON T.trackid = pt.trackid
       JOIN genre g
         ON g.genreid = T.genreid
       JOIN invoiceline IL
         ON T.trackid = IL.trackid
GROUP  BY 1
HAVING p.NAME = "Music"
ORDER  BY 2 DESC

-- most purchased Drame Playlist
SELECT a.albumid,
       a.title,
       g.NAME,
       Sum(IL.unitprice * IL.quantity) AS total_usd,
	   count(*) AS number_purchased
FROM   album a
       JOIN track T
         ON T.albumid = a.albumid
       JOIN genre g
         ON g.genreid = T.genreid
       JOIN invoiceline IL
         ON T.trackid = IL.trackid
GROUP  BY 1,
          2,
          3
HAVING g.NAME = "Drama"
ORDER  BY 4 DESC

-- find out most frequent customers and the total amount spent on the shop
SELECT billingcountry,
       firstname,
       lastname,
       Count(total) AS number_visited,
       Sum(total)   AS total_spent
FROM   customer c
       JOIN invoice i
         ON i.customerid = c.customerid
GROUP  BY 1,
          2,
          3
ORDER  BY 4 DESC,
          5 DESC;

-- find out who reports to whom
SELECT e.firstname
       || ' '
       || e.lastname AS employee,
       m.firstname
       || ' '
       || m.lastname AS manager
FROM   employee e
       LEFT JOIN employee m
              ON m.employeeid = e.reportsto
ORDER  BY manager

-- find the employee that has the most reports and their manager
SELECT e.firstname
       || ' '
       || e.lastname AS employee,
       m.firstname
       || ' '
       || m.lastname AS manager,
       Count(*)      AS Num_reports
FROM   employee e
       LEFT JOIN employee m
              ON m.employeeid = e.reportsto
       JOIN customer c
         ON c.supportrepid = E.employeeid
GROUP  BY 1,
          2
ORDER  BY 3 DESC;
