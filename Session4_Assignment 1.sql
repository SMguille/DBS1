set schema 'goodreads_v3';

-- 1. What is the first and last name of the author with id 23?
-- Francis Blair
    SELECT authors.firstname, authors.lastname
    FROM authors
    WHERE id = 23;

-- 2. What book has the id 24358527?
-- Angles of Attack (Frontlines,  #3)
    SELECT *
    FROM books
    WHERE id = 24358527;

-- 3. How many profiles are there?
-- 793
    SELECT COUNT(*)
    FROM profile;

-- 4. How many profiles have the first name 'Abram'?
-- 2
    SELECT COUNT(*)
    FROM profile
    WHERE firstname = 'Abram';
-- 5. Create a list of book titles and their page count, order by the book with the highest page count first

    SELECT title, books.pagecount
    FROM books
    ORDER BY pagecount DESC;

-- 6. Create a list of book titles and their page count,
-- order by the book with the highest page count first, but remove books without a page count.

    SELECT title, books.pagecount
    FROM books
    WHERE pagecount IS NOT NULL
    ORDER BY pagecount DESC;

-- 7. Show the books published in 2017.

    SELECT *
    FROM books
    WHERE yearpublished = 2017;

-- 8. How many books do not have an ISBN number?
-- 0
    SELECT COUNT(*)
    FROM books
    WHERE isbn IS NULL;
-- 9. How many authors have a middle name?
-- 47
    SELECT COUNT(*)
    FROM authors
    WHERE middlenames IS NOT NULL;

-- 10. What is the most common firstname for a profile?
-- Honor
    SELECT firstname, COUNT(*)
    FROM profile
    GROUP BY firstname
    ORDER BY count(*) DESC;

-- 11. Show an overview of author first name and last name and how many books they have written.
--     Order by highest count at the top.

SELECT authors.firstname, authors.lastname, COUNT(*)
FROM authors
    JOIN goodreads_v3.books b on authors.id = b.writtenbyid
group by authors.firstname, authors.lastname
ORDER BY COUNT(*) dESC;

-- 12. What is the title of the book with the highest page count
--Oathbringer (The Stormlight Archive,  #3)

    SELECT title, books.pagecount
    FROM books
    WHERE pagecount IS NOT NULL
    ORDER BY pagecount DESC;

-- 13. What is the title of the book with the fifth highest page count?
-- Words of Radiance (The Stormlight Archive,  #2)
    SELECT title, books.pagecount
    FROM books
    WHERE pagecount IS NOT NULL
    ORDER BY pagecount DESC
    LIMIT 5;

-- 14. List the firstnames of the profiles that does not have an unique firstname.

SELECT profile.firstname, COUNT(*)
FROM profile
group by profile.firstname
HAVING COUNT(*) > 1
ORDER BY COUNT(*) ASC;

-- 15. Who published 'Tricked (The Iron Druid Chronicles, #4)
-- Hint, you may not be able to get an exact match of the name above.
-- Kevin Hearne
    SELECT *
    FROM books, authors
    WHERE title LIKE '%Tricked%' AND authors.id = writtenbyid;

-- 16. What's the binding type of 'Fly by Night'?
-- Hardcover
    SELECT *
    FROM books, bindings
    WHERE title = 'Fly by Night' AND bindingid = bindings.id;

-- 17. What is the most popular binding type?
-- Kindle Edition
SELECT bindings.type, count(*)
From bindings
JOIN books ON bindings.id = books.bindingid
group by bindings.type
ORDER BY COUNT(*) DESC;

-- 18. How many books has the reader with the profile name 'Venom_Fate' read?
-- 187
SELECT profile.profilename, COUNT(*)
FROM profile
JOIN books_read USING (profilename)
WHERE profile.profilename ='Venom_Fate'
group by profile.profilename;

-- 19. How many books are written by Brandon Sanderson?
-- 41
SELECT firstname, lastname, COUNT(*)
FROM books, authors
    WHERE firstname = 'Brandon' AND lastname = 'Sanderson' AND books.writtenbyid = authors.id
group by firstname, lastname;

-- 20. How many readers have read the book 'Gullstruck Island'?
-- 168
SELECT title, COUNT(*)
FROM books
        JOIN books_read ON books.id = books_read.bookid
WHERE title = 'Gullstruck Island'
group BY title;

-- 21. How many books have the author Ray Porter co-authored?
-- 3
SELECT COUNT(*)
FROM authors
    JOIN coauthors ON authors.id = coauthors.author_id
    JOIN goodreads_v3.books b on b.id = coauthors.book_id
WHERE firstname = 'Ray' AND lastname = 'Porter';

-- 22. What type of binding does 'Dead Iron (Age of Steam,  #1)' have?
-- Paperback
    SELECT title, bindings.type
    FROM books
    join bindings ON books.bindingid = bindings.id
    WHERE title = 'Dead Iron (Age of Steam,  #1)';

-- 23. What are the names of the author and co-authors of the book which contains 'Wild Cards' in its title?
-- George Martin, Brian Bolland, Edward Bryant, Howard Waldrop, John Miller, Leanne Harper, Lewis Shiner, Melinda Snodgrass... (and 5 more)
    SELECT authors.firstname, authors.lastname
    FROM authors
        JOIN books ON authors.id = books.writtenbyid
    WHERE title LIKE '%Wild Cards%'
    UNION
    SELECT authors.firstname, authors.lastname
        FROM authors
        JOIN coauthors ON authors.id = coauthors.author_id
        JOIN books ON coauthors.book_id = books.id
    WHERE title LIKE '%Wild Cards%';


-- 24. What is the most popular binding type of Brandon Sandersons books?
-- Hardcover
SELECT bindings.type, count(*)
From bindings
JOIN books ON bindings.id = books.bindingid
JOIN goodreads_v3.authors a on books.writtenbyid = a.id
WHERE firstname = 'Brandon' AND lastname = 'Sanderson'
group by bindings.type
ORDER BY COUNT(*) DESC;

-- 25. For each profile, show how many books they have read.

SELECT profile.profilename, COUNT(*)
FROM profile
    JOIN goodreads_v3.books_read br on profile.profilename = br.profilename
group by profile.profilename;

-- 26. Show all the genres of the book 'Hand of Mars (Starship's Mage,  #2)'.

    SELECT title, genrename
    FROM books
    JOIN book_genre ON books.id = book_genre.book_id
    JOIN genres ON book_genre.genre_id = genres.id
    WHERE title = 'Hand of Mars (Starship''s Mage,  #2)';

-- 27. Show a list of both author and co-authors for the book with title 'Dark One'.

        SELECT authors.firstname, authors.lastname
    FROM authors
        JOIN books ON authors.id = books.writtenbyid
    WHERE title LIKE 'Dark One'
    UNION
    SELECT authors.firstname, authors.lastname
        FROM authors
        JOIN coauthors ON authors.id = coauthors.author_id
        JOIN books ON coauthors.book_id = books.id
    WHERE title LIKE 'Dark One';

-- 28. Which author has made the most announcements?
-- Guy,Kay
-- James,Patterson
-- Christopher,Moore
-- Myke,Cole
-- Jasper,Fforde
-- Andrew,Rowe
-- Bernie,Wrightson
-- Josh,Bazell
-- A.J.,Smith
-- Lewis,Shiner
-- Neil,Gaiman
-- Chris,Jackson
-- Hugh,Howey
-- Maria,Skibniewska
-- Sam,Sisavath

SELECT authors.firstname, authors.lastname, COUNT(*)
FROM authors
    JOin announcements ON authors.id = announcements.writtenbyid
group by authors.firstname, authors.lastname
HAVING COUNT(*) = (SELECT MAX(announcements_count)
                   FROM (SELECT COUNT(*) AS announcements_count
                   FROM announcements
                   GROUP BY writtenbyid) as max_announcements_count);

-- 29. Which author has the highest total of announcement likes?
-- A.J.,Smith
SELECT authors.firstname, authors.lastname, COUNT(*)
FROM authors
    JOIN announcements ON authors.id = announcements.writtenbyid
    JOIN announcementlikes ON announcements.id = announcementlikes.announcementid
group by authors.firstname, authors.lastname
LIMIT 1;

-- 30. A profiles favourite author is the author they have read most books of. Ignore co-authors. Use only "has read" books.
-- Pick a profile, and find that profiles favourite author's name
-- Profile name:bubbly_snowflake. Author: Brandon,Sanderson

SELECT authors.firstname, authors.lastname, COUNT(*)
FROM books_read, books, authors
    WHERE books_read.bookid = books.id
      AND books.writtenbyid = authors.id
      AND books_read.profilename = 'bubbly_snowflake'
group by authors.firstname, authors.lastname
ORDER BY COUNT(*) DESC;

-- 31. Which author is read the most?
-- Brandon Sanderson
SELECT authors.firstname, authors.lastname, COUNT(*)
FROM authors
    JOIN books ON authors.id = books.writtenbyid
    JOIN books_read ON books.id = books_read.bookid
group by authors.firstname, authors.lastname
ORDER BY COUNT(*) DESC;

-- 32. Which profile has liked the most comments?
-- heroanhart
SELECT announcementlikes.profilename, COUNT(*)
FROM announcementlikes
group by announcementlikes.profilename
ORDER BY COUNT(*) DESC;

-- 33. What is the title of the book which is read by most readers.
--A Darker Magic (Starship's Mage,  #10)
SELECT books.title, COUNT(*)
FROM books
 JOIN books_read ON books.id = books_read.bookid
group by books.title
ORDER BY COUNT(*) DESC;

-- 34. For the top-ten largest books (page count wise) show their title and binding type.
SELECT title, books.pagecount, bindings.type
    FROM books
    JOIN bindings ON books.bindingid = bindings.id
    WHERE pagecount IS NOT NULL
    ORDER BY pagecount DESC
LIMIT 10;

-- 35. Show a count of how many books there are in each genre

SELECT genres.genrename, COUNT(*)
FROM genres
    JOIN book_genre on genres.id = genre_id
    JOIN books b on book_genre.book_id = b.id
group by genres.genrename
ORDER BY COUNT(*) DESC;


-- 36. Show a list of publisher names and how many books they each have published

SELECT publishers.name, COUNT(*)
FROM publishers
    JOIN goodreads_v3.books b on publishers.id = b.publishedbyid
group by publishers.name
ORDER BY COUNT(*) DESC;

-- 37. Which book has the highest average rating?
-- "Red Seas Under Red Skies (Gentleman Bastard,  #2)",3.2874251497005988
SELECT books.title, AVG(books_read.rating)
FROM books
    JOIN books_read ON books.id = books_read.bookid
group by books.title
ORDER BY AVG(books_read.rating) DESC;


-- 38. What's the lowest rated book?
--"The Stranded (Wool,  #5)",2.7237569060773481

SELECT books.title, AVG(books_read.rating)
FROM books
    JOIN books_read ON books.id = books_read.bookid
group by books.title
ORDER BY AVG(books_read.rating) ASC;

-- 39. How many books have reader 'radiophobia' read in 2018?
-- 15
SELECT books_read.profilename, COUNT(*)
FROM books_read
WHERE profilename = 'radiophobia' AND EXTRACT(YEAR FROM datestarted) = 2018
group by books_read.profilename;

-- 40. Show a list of how many books reader 'radiophobia' have read each year.
SELECT EXTRACT(YEAR FROM datestarted) as year, COUNT(*)
FROM books_read
WHERE profilename = 'radiophobia'
group by Year;
-- 41. Show all authors (ignore coauthors) and the average rating of their books. Order by highest to lowest.

SELECT authors.firstname, authors.lastname, AVG(br.rating) as avg_rating
FROM authors
    JOIN books b on authors.id = b.writtenbyid
    JOIN books_read br on b.id = br.bookid
group by authors.firstname, authors.lastname
ORDER BY avg_rating desc;


-- 42. Is there any book, which hasn't been read?
-- "The Thorn of Emberlain (Gentleman Bastard,  #4)"
-- "The Ministry of Necessity (Gentleman Bastard,  #5)"
-- "The Winds of Winter (A Song of Ice and Fire,  #6)"
-- Lone Survivor:  The Eyewitness Account of Operation Redwing and the Lost Heroes of SEAL Team 10
-- "The Mage and the Master Spy (Gentleman Bastard,  #6)"
-- "Inherit the Night (Gentleman Bastard,  #7)"
-- "Nightblood (Warbreaker,  #2)"
-- "The Doors of Stone (The Kingkiller Chronicle,  #3)"
-- "The Apocalypse Guard (Apocalypse Guard,  #1)"

    SELECT books.title
    FROM books
    LEFT JOIN books_read br on books.id = br.bookid
    WHERE br.bookid IS NULL ;


-- 43. Which book has been read the most times?
-- "A Darker Magic (Starship's Mage,  #10)",381

SELECT books.title, COUNT(*)
FROM books
    JOIN goodreads_v3.books_read br on books.id = br.bookid
group by books.title
ORDER BY count(*) desc;

-- 44. Which reader has read the most books
--laugh_till_u_pee,198
SELECT profile.profilename, COUNT(*)
FROM profile
    JOIN goodreads_v3.books_read br on profile.profilename = br.profilename
group by profile.profilename
ORDER BY COUNT(*) DESC
LIMIT 1;

-- 45. Show how many pages in total each reader has read. Limit to top 10.

SELECT profile.profilename, SUM(b.pagecount)
FROM profile
    JOIN goodreads_v3.books_read br on profile.profilename = br.profilename
    JOIN goodreads_v3.books b on b.id = br.bookid
group by profile.profilename
ORDER BY SUM(b.pagecount) DESC
LIMIT 10;

-- 46. What's the lowest number of days to read 'Oathbringer (The Stormlight Archive,  #3)', and who did that?
--bill_nye_the_russian_spy,4
--delectableprove,4
--hobgoblin,4

    SELECT books_read.profilename, (datefinished - datestarted) as days
    FROM books_read
    JOIN goodreads_v3.books b on b.id = bookid
    WHERE title = 'Oathbringer (The Stormlight Archive,  #3)'
ORDER BY days ASC;

-- 47. Which Genre describes the most books?
-- fiction,448
    SELECT genres.genrename, COUNT(*)
FROM genres
    JOIN book_genre on genres.id = genre_id
    JOIN books b on book_genre.book_id = b.id
group by genres.genrename
ORDER BY COUNT(*) DESC
    LIMIT 1;
-- 48. Show how many pages each author has written (include co-authors) QUESTION - IS THIS CORRECT?? WHY CAN I ONLY SEE 3 CO-AUTHORS???

SELECT authors.firstname, authors.lastname, SUM(pagecount) as written_pages
FROM authors
    JOIN goodreads_v3.books b on authors.id = b.writtenbyid
WHERE pagecount IS NOT NULL
group by authors.firstname, authors.lastname
UNION
SELECT authors.firstname, authors.lastname, SUM(pagecount) as written_pages
FROM authors
    JOIN coauthors on authors.id = coauthors.author_id
    JOIN goodreads_v3.books b on coauthors.book_id = b.writtenbyid
WHERE pagecount IS NOT NULL
group by authors.firstname, authors.lastname
ORDER BY written_pages DESC;

-- 49. How many different first names are there in the profiles?
--696
    SELECT COUNT(DISTINCT firstname)
    FROM profile;

-- 50. For each first name, show a list of number of people with that first name.

SELECT DISTINCT firstname, COUNT(*)
FROM profile
group by firstname
ORDER BY COUNT(*) DESC;

-- 51. Which profile has liked the most announcements?
-- heroanhart,404
SELECT announcementlikes.profilename, COUNT(*)
FROM announcementlikes
group by announcementlikes.profilename
ORDER BY COUNT(*) DESC;

-- 52. Which profile has the longest list of "want to read"?
-- boeingranchers,205
    SELECT wants_to_read.profilename, COUNT(*)
    FROM wants_to_read
    GROUP BY profilename
    ORDER BY COUNT(*) DESC;

-- 53. Which profile has written the most reviews?
-- intagliated,112
SELECT books_read.profilename, COUNT(*)
FROM books_read
WHERE review IS NOT NULL
GROUP BY profilename
ORDER BY COUNT(*) desc;

-- 54. Which profile has given the overall lowest average rating?
-- happee,1.8888888888888889
SELECT books_read.profilename, AVG(rating) as avg_rating
FROM books_read
GROUP BY profilename
ORDER BY avg_rating ASC;

-- 55. Who has been stuck on reading their current book the longest?
-- titmouse,13760
SELECT currently_reading.profilename, (CURRENT_DATE - currently_reading.datestarted) as days_stuck
FROM currently_reading
ORDER BY days_stuck DESC;

-- 56. Produce a result of publishers with their adresses.
SELECT name, cityname, citypostcode, street, housenumber
FROM publishers
JOIN address ON publishers.id = address.publisherid;

-- 57. Display the title, binding type, and author first and last name for all books.

    SELECT books.title, bindings.type, authors.firstname, authors.lastname
    FROM books, bindings, authors
    WHERE books.bindingid = bindings.id AND books.writtenbyid = authors.id;

-- 58. Explain what the following SQL statement does.
SELECT profilename
FROM announcementlikes
WHERE announcementid IN (
    SELECT id
    FROM announcements
    WHERE writtenbyid = (
        SELECT id
        FROM authors WHERE firstname = 'Glynn' AND lastname = 'Stewart'
        )
    )
EXCEPT
SELECT p.profilename
FROM profile p join books_read br on p.profilename = br.profilename
join books b on br.bookid = b.id
WHERE writtenbyid = (
        SELECT id
        FROM authors WHERE firstname = 'Glynn' AND lastname = 'Stewart'
        );

--This SQL code selects profiles that have given a like on the announcements made by Glynn Stewart except from the profiles that haven't read or haven't finished reading his books

-- 59. For each profile, show the name of the author, whose announcements they have liked most.

WITH author_likes AS ( -- Get the number of likes for each author
    SELECT al.profilename, a.id AS author_id, a.firstname, a.lastname,
           COUNT(*) AS like_count
    FROM announcementlikes al
    JOIN announcements an ON al.announcementid = an.id
    JOIN authors a ON an.writtenbyid = a.id
    GROUP BY al.profilename, a.id, a.firstname, a.lastname
)
SELECT profilename, firstname, lastname, like_count
FROM author_likes
WHERE (profilename, like_count) IN ( -- Get the most liked author for each profile by filtering with profilename and like_count
    SELECT profilename, MAX(like_count)
    FROM author_likes
    GROUP BY profilename)
ORDER BY profilename, like_count DESC;

-- 60. Display the favourite author (The author whom they have read the most of) of all profiles.

WITH author_read_count AS ( -- Count how many books each profile has read by each author
    SELECT books_read.profilename, authors.firstname, authors.lastname, COUNT(*) AS books_read_count  --per user per author
    FROM authors
    JOIN books ON authors.id = books.writtenbyid
    JOIN books_read ON books.id = books_read.bookid
    GROUP BY books_read.profilename, authors.firstname, authors.lastname)

SELECT profilename, firstname, lastname, books_read_count
FROM author_read_count
WHERE (profilename, books_read_count) IN ( -- Get the most read author for each profile
    SELECT profilename, MAX(books_read_count)
    FROM author_read_count
    GROUP BY profilename)
ORDER BY profilename; -- Order the results by profile name, if a user has read the same amount of books from different authors, all of them would be displayed.

-- 61. What is each reader's most read genre?

WITH ReaderGenreCounts AS (
    SELECT pr.profilename, g.genrename, COUNT(*) AS genre_count, ROW_NUMBER() OVER (PARTITION BY pr.profilename ORDER BY COUNT(*) DESC) AS rn --this shows the users most read genres ordered from most to the least read
    FROM profile pr
    JOIN books_read br ON pr.profilename = br.profilename
    JOIN books b ON br.bookid = b.id
    JOIN book_genre bg ON b.id = bg.book_id
    JOIN genres g ON bg.genre_id = g.id
    GROUP BY pr.profilename, g.genrename
)
SELECT profilename, genrename --we only choose to show the profilename and genrename where the genrename ranked the first for that user
FROM ReaderGenreCounts
WHERE rn = 1;