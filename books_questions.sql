
USE Library
GO


/*
1. How many copies of the book titled The Lost Tribe are owned by the library branch whose name
is "Sharpstown"?
*/

SELECT COUNT(*) AS 'Books Count' FROM BOOK B
INNER JOIN BOOK_COPIES C
ON C.BookId = B.BookId
INNER JOIN LIBRARY_BRANCH L
ON L.BranchId = C.BranchId
WHERE B.Title = 'The Lost Tribe' AND L.BranchName = 'Sharpstown'

/*
2. How many copies of the book titled The Lost Tribe are owned by each library branch?
*/

SELECT DISTINCT(L.BranchName), C.No_Of_Copies FROM BOOK B
INNER JOIN BOOK_COPIES C
ON C.BookId = B.BookId
INNER JOIN LIBRARY_BRANCH L
ON L.BranchId = C.BranchId
WHERE B.Title = 'The Lost Tribe' 

/*
3. Retrieve the names of all borrowers who do not have any books checked out.
*/

SELECT B.Name FROM BORROWER B
FULL OUTER JOIN BOOK_LOANS L
ON B.CardId = L.CardNo
WHERE L.CardNo  IS NULL

/*
4. For each book that is loaned out from the "Sharpstown" branch and whose DueDate is today,
retrieve the book title, the borrower's name, and the borrower's address.
*/

SELECT B.Title, BR.Name AS 'Borrower name', BR.Address  FROM BOOK B
INNER JOIN BOOK_LOANS BL
ON B.BookId = BL.BookId
INNER JOIN LIBRARY_BRANCH LB
ON BL.BranchId = LB.BranchId
INNER JOIN BORROWER BR
ON BR.CardId = BL.CardNo

WHERE LB.BranchName = 'Sharpstown' AND BL.DueDate = '2017-01-03'

/*
5. For each library branch, retrieve the branch name and the total number of books loaned out from
that branch.*/


SELECT LB.BranchName, COUNT(B.BookId) as 'Books out' FROM LIBRARY_BRANCH LB
INNER JOIN BOOK_LOANS B
ON B.BranchId = LB.BranchId
GROUP BY LB.BranchName, B.BranchId

/*
6. Retrieve the names, addresses, and number of books checked out for all borrowers who have more
than five books checked out.

*/

SELECT b.Name, b.Address, COUNT(l.CardNo) AS 'Books out' FROM BORROWER b
INNER JOIN BOOK_LOANS l
ON b.CardId = l.CardNo
GROUP BY b.Name, b.Address, l.CardNo 
HAVING COUNT(l.CardNo) > 5

/*
7. For each book authored (or co-authored) by "Stephen King", retrieve the title and the number of
copies owned by the library branch whose name is "Central"
*/

SELECT DISTINCT(b.Title), A.AuthorName, l.BranchName, C.No_Of_Copies FROM BOOK B
INNER JOIN BOOK_AUTHORS A
ON B.BookId = A.BookId
INNER JOIN BOOK_COPIES C
ON B.BookId = C.BookId
INNER JOIN LIBRARY_BRANCH L
ON C.BranchId = L.BranchId
WHERE A.AuthorName = 'Stephan King' AND L.BranchName = 'Central'


/*
Stored Procedure
*/

USE LIBRARY
GO

CREATE PROCEDURE booksOwnedByLibrary @Branch varchar(30)
AS

SELECT L.BranchName, B.Title, BC.No_Of_Copies FROM BOOK B
INNER JOIN BOOK_COPIES BC
ON B.BookId = BC.BookId
INNER JOIN LIBRARY_BRANCH L
ON BC.BranchId = L.BranchId
WHERE L.BranchName = @Branch
GO

/*
Executing the stored procedure
branch names: Beaverton, Tigard, Tualatin, Sherwood, Sharpstown, Central
*/

EXEC booksOwnedByLibrary 'Tigard'

