#!/bin/bash

courses=("https://courses.students.ubc.ca/cs/main?pname=subjarea&tname=subjareas&req=5&dept=ENGL&course=301&section=99X" "https://courses.students.ubc.ca/cs/main?pname=subjarea&tname=subjareas&req=5&dept=ITAL&course=101&section=201")

for course in ${courses[@]} 
do
	echo "$course" | grep -o 'dept=....' > course.txt
	echo "$course" | grep -o "course=..." >> course.txt

	curl "$course" > "coursepage.txt"
	grep -A 3 "Total Seats Remaining:" "coursepage.txt" > "outputlines.txt"
	grep -o 'Total Seats Remaining:[[:print:]]*' < outputlines.txt > tempfile.txt
	grep -o '[0-9]' < tempfile.txt | head -n1
	num=$(grep -o '[0-9]' < tempfile.txt | head -n1)
	echo $num
	if [ $num -gt 0 ]; then
		mail -s "There is an opening in the following course" c9f7@ugrad.cs.ubc.ca < course.txt
	fi
done
