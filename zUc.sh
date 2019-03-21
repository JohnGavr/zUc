#!/bin/bash

# Αρχικό μενού προγράμματος

file=$(zenity --list --title "Επιλογές" --text="Διαλέξτε μια από τις επιλογές" --column="Επιλέξτε" "Usb Writter" --ok-label="Quit" --cancel-label="About" --width=350 --height=350)

find_disk () {
#Διαδικασία εύρεσης δίσκου εγγραφής. 

if [[ -z $(lsblk | grep media) ]];
	then
	zenity --error --title="Σφάλμα" --text="Δεν υπάρχει δίσκος εγγραφής" --width=350
	exit 0
	else
	diskvar=$(zenity --list --title="Επιλογή Δίσκου" --column="Disk" --column="Space" \ $(lsblk -do name,tran,size | awk '$2=="usb"{print $1"\t\t"$3}')) #επιλογή και αποθήκευση δίσκου εγγραφής
fi

# Έλεγχος αν η μεταβλητή diskvar πήρε τιμή. Σε περίπτωση επιλογής cancel ή σκέτου ok χωρίς επιλογή δίσκου τερματίζει.

if [[ -z $diskvar ]] 
     then
     zenity --error --title="ΣΦάλμα" --text="Δεν δηλώθηκε δίσκος εγγραφής."
     exit 0
     elif zenity --question --title="Προειδοποίηση" --text="Με αυτήν την ενέργεια θα χαθούν τα αρχεία στο δίσκο που επιλέξατε. Θέλετε να συνεχίσετε;" --width=350  #ερώτηση για την συνέχεια του προγράμματος
     then 
     sure=1   #αν η απάντηση είναι ναι τότε sure=1
     else 
     sure=0   #αν η απάντηση είναι όχι τότε sure=0
fi

if [[ sure -ne 1 ]] 
     then
     # zenity --info --title="Ενημέρωση" --text="Συνεχίζουμε"   #συνέχισε
     
     # else 
     zenity --info --title="Ενημέρωση" --text="Επιλέξατε να μην γίνει η εγγραφή. Καλή συνέχεια" --width=350
     exit 0 #σταμάτα ή επέστρεψε πίσω
fi

diskvar=$(echo $diskvar | tr -d '[:space:]') 
}

write_usb () {
# Επιλογή αρχείου για την εγγραφή στο δίσκο που επιλέχτηκε

FILE=$(zenity --file-selection --title="Επιλέξτε αρχείο" --file-filter="*.iso")

zenity --info --title="Επιλογή" --text=" Θα γίνει εγγραφή του $FILE στο $diskvar" --width=350

if [[ -z $FILE ]];
	then
	zenity --error -title="Σφάλμα" --text="Δεν έχετε επιλέξει αρχείο...τερματισμός"
	exit 0
	else
	(pkexec sudo dd if=$FILE of=/dev/"$diskvar" bs=1MB)| zenity --title="zenity USB creator" --width=350 --progress --pulsate 
fi 
}

if [[ $? = "1" ]]; then # $? γίνεται ένα μόνο στην περίπτωση που πατηθεί το κουμπί About
  
# Menu About
zenity --info --title="About" --text="GNU GENERAL PUBLIC LICENSE
 Version 3, 29 June 2007
Ένα πρόγραμμα που επιτρέπει την εγγραφή .iso αρχείων στον δίσκο της επιλογής σας." --width=350 --height=350

# Επιλογή Quit τερματίζει 

elif [[ $? = "0" ]] || [[ -z $file ]]; then # $? παραμένει 0 στο Quit και αν εισαχθεί και κάποια επιλογή άρα ελέγχουμε αν είναι μηδέν και η μεταβλητή $file να μην έχει πάρει τιμή
  exit 0

#Επιλογή Usb Writter

elif [[ $file = "Usb Writter" ]]; then
  find_disk
  write_usb
fi


