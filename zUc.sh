#!/bin/bash


# Έλεγχος αν υπάρχει δίσκος USB και αν υπάρχει συνεχίζεται η διαδικασία#
########################################################################

if [[ -z $(lsblk | grep media) ]];
	then
	echo "Δεν υπάρχει δίσκος USB"
	echo "Τερματισμός προγράμματος"
	exit 0
	else
	echo "Δίσκος USB	Μέγεθος"
	lsblk | grep media -B1 | awk '{print $1"\t\t "$4}'
fi
while [ "$finished" != "true" ]
do
	read -rp "Σε ποιο δίσκο θέλεις να κάνεις την εγκατάσταση; " diskvar;
	if [ -z "$diskvar" ]; then
		echo "Δεν έχεις δώσει δίσκο"
	elif [[ $diskvar != *"/dev/sd"[a-z]* ]]; then									# Έλεγχος αν το string
		echo "η απάντηση πρέπει να είναι της μορφης /dev/sdx" 								# περιέχει το /dev/sd
	elif [[ ${diskvar:(-3)} != $(lsblk -m | grep -i "${diskvar:(-3)}[^0-9]" | awk '{print $1}') ]]; then		
		echo "μη έγκυρη ονομασία δίσκου"	
	else
      		finished=true	
	fi
done

########################################################################

echo "Συνέχεια διαδιακασίας..."

FILE=$(zenity --file-selection --title="Επιλέξτε αρχείο" --file-filter="*.iso")

echo $diskvar $FILE

if [[ -z $FILE ]];
	then
	echo "Δεν έχετε επιλέξει αρχείο...τερματισμός"
	exit 0
	else


(
  sleep 5
  echo "Προετοιμασία εγκατάστασης"
  sleep 1	
  echo "Εγγραφή USB"
  gksudo dd if=$FILE of=$diskvar bs=1MB
) | zenity --title="zenity USB creator" --width=350 --progress --pulsate --auto-close

fi 
