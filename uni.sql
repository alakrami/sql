USE Uni
--1. Find the names of all the instructors from Biology department
SELECT name
FROM instructor
WHERE dept_name = 'Biology'

--2. Find the names of courses in Computer science department ("Comp. Sci.") which have 3 credits
SELECT title
FROM course
WHERE dept_name = 'Comp. Sci.'
AND credits = 3
--3. For the student with ID 10481, show all course_id and title of all courses registered for by the student.
SELECT takes.course_id, course.title
FROM takes, course
WHERE takes.ID = 10481
AND takes.course_id = course.course_id

--4. As above, but show the total number of credits for such courses (taken by that student). Don't display
--the tot_creds value from the student table, you should use SQL aggregation on courses taken by the
--student.
SELECT takes.ID AS STUDENT_ID, SUM(credits) AS TOTAL_CREDITS
FROM takes, course
WHERE takes.ID = 10481
AND takes.course_id = course.course_id
GROUP BY takes.ID

-- OR
SELECT SUM(credits) AS TOTAL_CREDITS
FROM takes, course
WHERE takes.ID = 10481
AND takes.course_id = course.course_id


--5. As above, but display the total credits for each of the students, along with the ID of the student; don't
--bother about the name of the student. (Don't bother about students who have not registered for any
--course, they can be omitted)
SELECT takes.ID AS STUDENT_ID, SUM(credits) AS TOTAL_CREDITS
FROM takes, course
WHERE takes.course_id = course.course_id
GROUP BY takes.ID

--6. Find the names of all students who have taken any Comp. Sci. course ever (there should be no
--duplicate names)

SELECT DISTINCT name
FROM student
WHERE student.ID IN (
						SELECT DISTINCT takes.ID
						FROM takes
						WHERE takes.course_id IN (SELECT DISTINCT(course.course_id)
													FROM course
													WHERE course.dept_name = 'Comp. Sci.'))
-- OR

SELECT DISTINCT student.name
FROM  student, takes, course
WHERE course.course_id = takes.course_id
AND takes.ID = student.ID
AND course.dept_name = 'Comp. Sci.'; 

-- OR

SELECT DISTINCT name
FROM takes JOIN student ON takes.ID = student.ID
JOIN course ON course.course_id = takes.course_id
WHERE course.dept_name = 'Comp. Sci.';   

--7. Display the IDs of all instructors who have never taught or have never been scheduled to teach a
--course
SELECT instructor.ID 
FROM instructor
WHERE id not in (SELECT id FROM teaches); 

-- OR
SELECT instructor.ID
FROM instructor   LEFT OUTER JOIN teaches ON instructor.ID = teaches.ID
WHERE teaches.course_id IS NULL


--8. As above, but display the names of the instructors also, not just the IDs.
SELECT instructor.name 
FROM instructor
WHERE id not in (SELECT id FROM teaches); 

-- OR
SELECT instructor.name
FROM instructor   LEFT OUTER JOIN teaches ON instructor.ID = teaches.ID
WHERE teaches.course_id IS NULL

--9. Find the maximum and minimum enrollment across all sections, considering only sections that had
--some enrollment, don't worry about those that had no students taking that section
SELECT MIN(students) AS "minimum enrollment", MAX(students) as "maximum enrollment"
FROM (SELECT COUNT(ID)  students
		FROM takes
		group by course_id, sec_id, semester, year) AS enrolled_students




--10. Find the name, department, and salary of those teachers who have taught courses of departments with
--a budget above average, but who perceive a salary below average
USE Uni
SELECT name, dept_name, salary
FROM instructor
WHERE dept_name IN (SELECT dept_name
					FROM department
					WHERE budget > (SELECT AVG(budget) FROM department))
AND ID IN (SELECT ID FROM teaches)
AND salary < (SELECT AVG(salary) FROM instructor)

--11. Some students take the same course more than once. Show the student's ID, the course's ID, the year
--and semester the course was taken, and the grade. Sort chronologically
SELECT takes.ID, takes.course_id, takes.year, takes.semester, takes.grade
FROM takes, (SELECT ID, course_id
				FROM takes
				GROUP BY ID, course_id
				HAVING COUNT(*) > 1) AS REPEATED
WHERE takes.ID =REPEATED.ID
AND takes.course_id = REPEATED.course_id
ORDER BY takes.ID, takes.course_id, takes.year  -- YOU CAN SORT JUST BY YEAR
--12. Repeat the above query, but now showing the student's name, course title, year, semester and grade.

SELECT student.name, course.title, takes.year, takes.semester, takes.grade
FROM takes, student, course, (SELECT ID, course_id
				FROM takes
				GROUP BY ID, course_id
				HAVING COUNT(*) > 1) AS REPEATED
WHERE takes.ID =REPEATED.ID
AND takes.course_id = REPEATED.course_id
AND student.ID = REPEATED.ID
AND course.course_id = REPEATED.course_id
ORDER BY student.name, course.title, takes.year
--13. Find all rooms that have been assigned to more than one section at the same time. Display the rooms
--along with the assigned sections.


SELECT YEAR, room_number, building, sec_id, COUNT(sec_id)
FROM section
GROUP BY YEAR, room_number, building, sec_id
HAVING COUNT(sec_id) > 1





