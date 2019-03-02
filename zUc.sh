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
