-- 1.Show the members under the name "Jens S." who were born before 1970 that became members of thelibrary in 2013.
USE Library
SELECT *
FROM TMember
WHERE YEAR(dBirth) < 1970
AND YEAR(dNewMember) = 2013
AND cName = 'Jens S.'

-- 2.Show those books that have not been published by the publishing companies with ID 15 and 32, exceptif they were published before 2000.
SELECT *
FROM TBook
WHERE nPublishingCompanyID NOT IN (15, 32)
OR YEAR(nPublishingYear) < 2000

-- 3.Show the name and surname of the members who have a phone number, but no address.
SELECT cName, cSurname
FROM TMember
WHERE cPhoneNo IS NOT NULL
AND cAddress IS NULL

-- 4.Show the authors with surname "Byatt" whose name starts by an "A" (uppercase) and contains an "S"(uppercase).
SELECT *
FROM TAuthor
WHERE cSurname = 'Byatt'
AND cName LIKE 'A%S%'


-- NOTE TO USE SEARCH CASE SENSITIVE USE COLLATE  SQL_Latin1_General_Cp1_CS_AS
SELECT *
FROM TAuthor
WHERE cName LIKE 'A%s%' COLLATE  SQL_Latin1_General_Cp1_CS_AS

-- 5.Show the number of books published in 2007 by the publishing company with ID 32.
SELECT COUNT(*) "Number of Books Publishen in 2007 by c32"
FROM TBook
WHERE nPublishingCompanyID = 32
AND nPublishingYear = 2007

-- 6.For each day of the year 2014, show the number of books loaned by the member with CPR"0305393207";
SELECT dLoan, COUNT(*) "number of books"
FROM TLoan
WHERE cCPR = '0305393207'
GROUP BY dLoan

-- 7.Modify the previous clause so that only those days where the member was loaned more than one book
SELECT dLoan, COUNT(*) "number of books"
FROM TLoan
WHERE cCPR = '0305393207'
GROUP BY dLoan
HAVING COUNT(*) > 1

-- 8.Show all library members from the newest to the oldest. Those who became members on the same day will be sorted alphabetically (by surname and name) within that day.
SELECT *
FROM TMember
ORDER BY dNewMember DESC, cSurname, cName

-- 9.Show the title of all books published by the publishing company with ID 32 along with their theme or themes.
SELECT B.cTitle, T.cName
FROM TBook B, TBookTheme BT, TTheme T
WHERE B.nPublishingCompanyID = 32
AND B.nBookID = BT.nBookID
AND BT.nThemeID = T.nThemeID

-- 10.Show the name and surname of every author along with the number of books authored by them. but only for authors who have registered books on the database.
SELECT TAuthor.cName, TAuthor.cSurname, COUNT(TBook.nBookID) "number of books"
FROM TAuthor 
INNER JOIN TAuthorship ON TAuthor.nAuthorID = TAuthorship.nAuthorID
INNER JOIN TBook ON TAuthorship.nBookID = TBook.nBookID
GROUP BY TAuthor.cName, TAuthor.cSurname, TBook.nBookID
ORDER BY 3 DESC

-- 11.Show the name and surname of all the authors with published books along with the lowest publishing year for their books.
SELECT AU.cName, AU.cSurname, MIN(B.nPublishingYear) "lowest publishing year"
FROM TAuthor AU, TAuthorship AUSH, TBook B
WHERE AU.nAuthorID = AUSH.nAuthorID
AND AUSH.nBookID = B.nBookID
GROUP BY AU.cName, AU.cSurname, B.nBookID
ORDER BY 3

-- 12.For each signature and loan date, show the title of the corresponding books and the name and surname of the member who had them loaned.

SELECT L.cSignature, L.dLoan, B.cTitle, M.cName, M.cSurname
FROM TLoan L, TBookCopy BC, TBook B, TMember M
WHERE L.cSignature = BC.cSignature
AND BC.nBookID = B.nBookID
AND L.cCPR = M.cCPR
ORDER BY 2


-- 13.Repeat exercises 9 to 12 using the modern JOIN notation.
-- 9.Show the title of all books published by the publishing company with ID 32 along with their theme or themes.
SELECT TBook.cTitle, TTheme.cName
FROM TBook
INNER JOIN TBookTheme ON TBook.nBookID = TBookTheme.nBookID
INNER JOIN TTheme ON TBookTheme.nThemeID = TTheme.nThemeID
WHERE TBook.nPublishingCompanyID = 32


-- 10.Show the name and surname of every author along with the number of books authored by them. but only for authors who have registered books on the database.
SELECT TAuthor.cName, TAuthor.cSurname, COUNT(TBook.nBookID) "number of books"
FROM TAuthor
INNER JOIN TAuthorship ON TAuthor.nAuthorID = TAuthorship.nAuthorID
INNER JOIN TBook ON TAuthorship.nBookID = TBook.nBookID
GROUP BY TAuthor.cName, TAuthor.cSurname, TBook.nBookID
ORDER BY 3 DESC

-- 11.Show the name and surname of all the authors with published books along with the lowest publishing year for their books.
SELECT TAuthor.cName, TAuthor.cSurname, MIN(TBook.nPublishingYear) "lowest publishing year"
FROM TAuthor 
INNER JOIN TAuthorship ON TAuthor.nAuthorID = TAuthorship.nAuthorID
INNER JOIN TBook ON TAuthorship.nBookID = TBook.nBookID
GROUP BY TAuthor.cName, TAuthor.cSurname, TBook.nBookID
ORDER BY 3

-- 12.For each signature and loan date, show the title of the corresponding books and the name and surname of the member who had them loaned.
SELECT TLoan.cSignature, TLoan.dLoan, TBook.cTitle, TMember.cName, TMember.cSurname
FROM TLoan
INNER JOIN TBookCopy ON TLoan.cSignature = TBookCopy.cSignature
INNER JOIN TBook ON TBookCopy.nBookID = TBook.nBookID
INNER JOIN TMember ON TLoan.cCPR = TMember.cCPR  
ORDER BY 2

-- 14.Show all theme names along with the titles of their associated books. All themes must appear (even if there are no books for some particular themes). Sort by theme name.
SELECT TTheme.cName THEME, TBook.cTitle TITLE
FROM TBookTheme
INNER JOIN TBook ON TBookTheme.nBookID = TBook.nBookID
RIGHT JOIN TTheme ON TBookTheme.nThemeID = TTheme.nThemeID
ORDER BY TTheme.cName

-- OR
SELECT TTheme.cName THEME, TBook.cTitle TITLE
FROM TTheme
LEFT JOIN TBookTheme ON TTheme.nThemeID = TBookTheme.nThemeID
LEFT JOIN TBook ON TBookTheme.nBookID = TBook.nBookID
ORDER BY TTheme.cName

/* 15. Show the name and surname of all members who joined the library in 2013 along with the title
of the books they took on loan during that same year. All members must be shown, even if they did 
not take any book on loan during 2013. Sort by member surname and name.*/
SELECT TMember.cName, TMember.cSurname, TBook.cTitle
FROM TBook 
INNER JOIN TBookCopy ON TBook.nBookID = TBookCopy.nBookID
INNER JOIN TLoan ON TBookCopy.cSignature = TLoan.cSignature
RIGHT JOIN TMember ON TLoan.cCPR = TMember.cCPR
WHERE YEAR(TMember.dNewMember) = 2013
AND YEAR(TLoan.dLoan) = 2013

-- OR

SELECT TMember.cName, TMember.cSurname, TBook.cTitle
FROM TMember
LEFT JOIN TLoan ON TMember.cCPR = TLoan.cCPR
LEFT JOIN TBookCopy ON TLoan.cSignature = TBookCopy.cSignature
LEFT JOIN TBook ON TBookCopy.nBookID = TBook.nBookID
WHERE YEAR(TMember.dNewMember) = 2013
AND YEAR(TLoan.dLoan) = 2013

/* 16. Show the name and surname of all authors along with their nationality or nationalities and 
the titles of their books. Every author must be shown, even though s/he has no registered books.
Sort by author name and surname.*/
SELECT TAuthor.cName, TAuthor.cSurname, TCountry.cName AS Country
FROM TCountry
INNER JOIN TNationality ON TCountry.nCountryID = TNationality.nCountryID
RIGHT JOIN TAuthor ON TNationality.nAuthorID = TAuthor.nAuthorID

--OR 

SELECT TAuthor.cName, TAuthor.cSurname, TCountry.cName AS Country
FROM TAuthor 
LEFT JOIN TNationality ON  TAuthor.nAuthorID = TNationality.nAuthorID
LEFT JOIN TCountry ON TNationality.nCountryID = TCountry.nCountryID

/* 17. Show the title of those books which have had different editions published in both 1970 and 1989.*/
SELECT TBook.cTitle, COUNT(*) "NUMBER OF EDTIONS"
FROM TBook
WHERE TBook.nPublishingYear IN (1970, 1989)
GROUP BY TBook.cTitle
HAVING COUNT(*) > 1

-- IF IT IS BETWEEN 1970 - 1989

SELECT TBook.cTitle, COUNT(*) "NUMBER OF EDTIONS"
FROM TBook
WHERE TBook.nPublishingYear BETWEEN 1970 AND 1989
GROUP BY TBook.cTitle
HAVING COUNT(*) > 1

--- TEST
SELECT *
FROM TBook
WHERE TBook.cTitle = 'XXX'

/* 18. Show the surname and name of all members who joined the library in December 2013 followed by the
surname and name of those authors whose name is “William”.*/
SELECT TMember.cName, TMember.cSurname
FROM TMember
WHERE TMember.dNewMember LIKE '2013-12-%'
UNION
SELECT TAuthor.cName, TAuthor.cSurname
FROM TAuthor
WHERE TAuthor.cName = 'William'

/* 19. Show the name and surname of the first chronological member of the library using subqueries.*/
SELECT TMember.cName, TMember.cSurname, TMember.dNewMember
FROM TMember
WHERE TMember.dNewMember = ( SELECT MIN(TMember.dNewMember) FROM TMember )

/* 20. For each publishing year, show the number of book titles published by publishing companies from
countries that constitute the nationality for at least three authors. Use subqueries.*/
SELECT nPublishingYear, COUNT(*) "number of bookS"
FROM TBook
WHERE nPublishingCompanyID IN (SELECT nPublishingCompanyID
								FROM TPublishingCompany
								WHERE nCountryID IN (SELECT nCountryID
														FROM TNationality
														GROUP BY nCountryID
														HAVING COUNT(nCountryID) > 3))
GROUP BY nPublishingYear
ORDER BY nPublishingYear

/* 21. Show the name and country of all publishing companies with the headings "Name" and "Country".*/
SELECT TPublishingCompany.cName "Name", TCountry.cName Country
FROM TPublishingCompany JOIN TCountry ON TPublishingCompany.nCountryID = TCountry.nCountryID

/* 22. Show the titles of the books published between 1926 and 1978 that were not published by the
 publishing company with ID 32.*/
 SELECT TBook.cTitle
 FROM TBook
 WHERE nPublishingYear BETWEEN 1926 AND 1978
 AND nPublishingCompanyID != 32

-- 23. Show the name and surname of the members who joined the library after 2012 and have no address.
SELECT TMember.cName, TMember.cSurname, TMember.dNewMember
FROM TMember
WHERE YEAR(TMember.dNewMember) > 2012
AND TMember.cAddress IS NULL

-- 24. Show the country codes for countries with publishing companies. Exclude repeated values.
SELECT  DISTINCT nCountryID 
FROM TPublishingCompany

-- 25. Show the titles of books whose title starts by "The Tale" and that are not published by "Lynch Inc".
SELECT TBOOK.cTitle
FROM TBook
WHERE TBook.cTitle LIKE 'The Tale%'
AND TBook.nPublishingCompanyID != (SELECT nPublishingCompanyID FROM TPublishingCompany WHERE cName = 'Lynch Inc')
-- 26. Show the list of themes for which the publishing company "Lynch Inc" has published books, excluding repeated values.
SELECT DISTINCT cName
FROM TTheme
WHERE nThemeID IN (SELECT DISTINCT nThemeID
					FROM TbookTheme
					WHERE nBookID IN (SELECT DISTINCT nBookID
										FROM TBook
										WHERE nPublishingCompanyID IN (SELECT nPublishingCompanyID
																		FROM TPublishingCompany
																		WHERE cName = 'Lynch Inc')))
-- 27. Show the titles of those books which have never been loaned.

SELECT *
FROM TBook
WHERE TBook.nBookID NOT IN (SELECT DISTINCT nBookID
							FROM TBookCopy
							INNER JOIN TLoan ON TBookCopy.cSignature = TLoan.cSignature)




-- 28. For each publishing company, show its number of existing books under the heading "No. of Books".
SELECT TPublishingCompany.cName AS "publishing company",  COUNT(*) AS "No. of Books"
FROM TBOOK
INNER JOIN TPublishingCompany ON TBook.nPublishingCompanyID = TPublishingCompany.nPublishingCompanyID
GROUP BY TPublishingCompany.cName
ORDER BY 2 DESC

-- 29. Show the number of members who took some book on a loan during 2013./*
SELECT COUNT(DISTINCT TLoan.cCPR) AS "number of members who took books in 2013"
FROM TLoan
WHERE YEAR(TLoan.dLoan) = 2013

-- 30 For each book that has at least two authors, show its title and number of authors under the heading "No. of Authors".
SELECT TBook.cTitle, COUNT(*) "No. of Authors"
FROM TAuthorship INNER JOIN TBook ON TAuthorship.nBookID = TBook.nBookID
GROUP BY TBook.nBookID, TBook.cTitle
HAVING COUNT(*) > 1

SELECT TBook.cTitle, TBook.nBookID
FROM TBook
WHERE TBook.cTitle IN ('Beowulf', 'English Medieval Poetry', 'Harry Potter and the Sorcerer''s Stone (Book 1)')



SELECT TBook.cTitle, TBook.nBookID, TAuthorship.nAuthorID
FROM TAuthorship INNER JOIN TBook ON TAuthorship.nBookID = TBook.nBookID

SELECT *
FROM TBook
WHERE TBook.cTitle  ='Beowulf'








