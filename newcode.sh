#!/bin/bash

echo "Application to check vacine vacancies for desired date -by Santosh Bitra"

read -p "Kindly enter the date you want to check vaccine availability for this month :" date

date1="$date-06-2021"
vacancies="<td>\d</td>"
#srt="awk '{print $2}'"
webserver="https://cgteeka.cgstate.gov.in/book-appointment?var=NjU1ODQ4OQ%3D%3D"
file1='/tmp/trial.txt'
file2='/tmp/trial2.txt'



#Continously keep searching for keyword-variable in the given webpage and also redirect the output to the given 1st file.
curl -s "$webserver" | egrep -i "$date1|$vacancies" 1> $file1

# filter and redirect only the desired values to a seperate file
cat "$file1" | gawk '{print $1,$4}' FPAT='[0-9]+' 1> "$file2"

#Print the available number of vacancies for the date
#echo "There are `cat "$file2" | awk '{print $2}'` vacancies for today"





#Comparision Program Below

if [ "$(curl -s "$webserver" | grep -i "$date1")" = "" ]; then

        echo "This date is not open yet.!"

elif [ "$(cat /tmp/trial2.txt | awk '{print $2}')" -eq "0" ]; then

        #If the vaccines availability is EQUAL TO 0, then an email notification is sent to the user(s)
        echo "No vaccines are available for the $date1" | mail -s "availability for vaccines" mail.santoshbitra@gmail.com
else
        #If the vaccines availability value is NOT EQUAL TO 0, then an email notification is sent to the user(s)
        echo "HURRY !! Vacancies currently seems available for the $date" | mail -s "availability for vaccines" mail.santoshbitra@gmail.com
fi
