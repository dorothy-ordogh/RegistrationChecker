#!/bin/bash

#List of course links I want to check for registration
courses=("https://courses.students.ubc.ca/cs/main?pname=subjarea&tname=subjareas&req=5&dept=ENGL&course=301&section=99X" "https://courses.students.ubc.ca/cs/main?pname=subjarea&tname=subjareas&req=5&dept=ITAL&course=101&section=201")

#Loop through course links
for course in ${courses[@]} 
do
	#Take department and course from link and put it into a text file
	echo "$course" | grep -o 'dept=....' > course.txt
	echo "$course" | grep -o "course=..." >> course.txt

	#Download page into a text file
	curl "$course" > "coursepage.txt"
	#Take the three lines after the text containing the "Total Seats Remaining" and put it into a text file
	grep -A 3 "Total Seats Remaining:" "coursepage.txt" > "outputlines.txt"
	#Take the number following the quote in the output file
	grep -o 'Total Seats Remaining:[[:print:]]*' < outputlines.txt > tempfile.txt
	grep -o '[0-9]' < tempfile.txt | head -n1
	num=$(grep -o '[0-9]' < tempfile.txt | head -n1)
	echo $num
	#If num (which is the number of the seats remainging) is greater than 0, then send me an email
	if [ $num -gt 0 ]; then
		mail -s "There is an opening in the following course" c9f7@ugrad.cs.ubc.ca < course.txt
	fi
done
