#! /bin/bash

source git.sh

DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=0
WIDTH=0

OUTPUT="/tmp/input.txt" 
ERROR="/tmp/error.txt"

# create empty file
>$OUTPUT
>$ERROR

display_result() {
	dialog --title "$1" \
		--no-collapse \
		--clear \
		--msgbox "$result" 20 60
}

enter_text() {
	dialog --title "$1" \
		--backtitle "$1" \
		--inputbox "$2" 8 60 2>$OUTPUT
		respose=$?
}


mygitMenu() {
while true; do
	exec 3>&1
	exec 3>&1
selection=$(dialog \
    --backtitle "System Information" \
    --title "Menu" \
    --clear \
    --cancel-label "Exit" \
    --menu "Please select:" $HEIGHT $WIDTH 20 \
    "1" "Config User Name" \
    "2" "Config User Email" \
    "3" "Git clone" \
    "4" "Git add" \
    "5" "Git commit" \
    "6" "Git push" \
    "7" "Git mv" \
    "8" "Git remote" \
    "9" "Git checkout" \
    "10" "Git branch" \
    "11" "Git merge" \
    "12" "Git grep" \
    "13" "Git add, commit, push" \
    2>&1 1>&3)
  	exit_status=$?
  	exec 3>&-
  	case $exit_status in
    		$DIALOG_CANCEL)
      		clear
      		echo "Program terminated."
      		exit
      		;;
    	$DIALOG_ESC)
      		clear
     		echo "Program aborted." >&2
      		exit 1
      		;;
 	esac
  	case $selection in
    	0 )
      		clear
      		echo "Program terminated."
      		;;
    	1 ) 
     		enter_text "Configure User Name" "Podaj nazwe użytkownika"
		case $respose in
	  	0) 
			name=$(<$OUTPUT)
			mygitConfigUserName ${name} 1>$OUTPUT
			result=$(<$OUTPUT)		
			display_result "Result" 
	  		;;
		esac
	      		;;
	2 ) 
		enter_text "Configure User Email" "Podaj email"
		case $respose in
	  	0) 
			email=$(<$OUTPUT)
			mygitConfigUserEmail ${email} 1>$OUTPUT 
			result=$(<$OUTPUT)		
			display_result "Result"	 
	  		;;
		esac
	      		;;
	3 ) 
		enter_text "git clone" "Podaj ścieżkę, z której chcesz kopiować"
		case $respose in
	  	0) 
			email=$(<$OUTPUT)
			mygitClone ${email} 1>$OUTPUT 
			result=$(<$OUTPUT)		
			display_result "Result"	 
	  		;;
		esac
	      		;; 
	4 )  
		enter_text "git add" "Podaj nazwę pliku, który chcesz dodać"
		case $respose in
	  	0) 
			file=$(<$OUTPUT)
			mygitAdd "-f" "${file}" 1>$OUTPUT 
			result=$(<$OUTPUT)	
			display_result "Result"	 
	  		;;
		esac
	      		;;
	5 ) 
		enter_text "git commit" "Podaj wiadomość"
		case $respose in
	  	0) 
			message=$(<$OUTPUT)
			mygitCommit "${message}" 1>$OUTPUT
			result=$(<$OUTPUT)		
			display_result "Result"	 
	  		;;
		esac
	      		;;
	6 )
		enter_text "git push" "Dozwolne parametry: nazwa branchu, --all, puste(master)"
		case $respose in
	  	0) 
			branch=$(<$OUTPUT)
			mygitPush "${branch}" 1>$OUTPUT
			result=$(<$OUTPUT)		
			display_result "Result"	 
	  		;;
		esac
	      		;;
	7 ) 
		enter_text "Zmiana nazwy pliku w repozytorium" "Podaj nazwe pliku, któremu chcesz zmienić nazwę"
		case $respose in
	  	0) 
			from=$(<$OUTPUT) 
			enter_text "Zmiana nazwy pliku w repozytorium" "Podaj nową nazwę"
			case $respose in
	  	 	0) 
				to=$(<$OUTPUT) 
				mygitMv $from $to 1>$OUTPUT
				result=$(<$OUTPUT)		
				display_result "Result"	 
	  			;;
			esac
	      			;;
		 esac
	      		;;
	8 ) 
		enter_text "git remote" "Podaj adres serwera lub pozostaw puste aby wylistować zdalne repozytoria"
		case $respose in
	  	0) 
			server=$(<$OUTPUT)
			mygitRemote "${server}" 1>$OUTPUT
			result=$(<$OUTPUT)		
			display_result "Result"	 
	  		;;
		esac
	      		;;
	9 ) 
		dialog --title "git checkout" \
		--backtitle "git checkout" \
		--yesno "Czy chcesz stworzyć nowy branch?" 7 60

		# Get exit status
		# 0 means user hit [yes] button.
		# 1 means user hit [no] button.
		response=$?
		case $response in
   		0)   
			enter_text "git checkout" "Podaj nazwę nowego branchu"
			case $respose in
	  		0) 
				branch=$(<$OUTPUT)
				mygitCheckout "-b" "${branch}" 1>$OUTPUT
				result=$(<$OUTPUT)		
				display_result "Result"	 
	  			;;
			esac
	      			;;
   		1)   
			enter_text "git checkout" "Podaj nazwę branchu, na który chcesz się przenieść"	
			case $respose in
	  		0) 
				branch=$(<$OUTPUT)
				mygitCheckout "${branch}" 1>$OUTPUT
				result=$(<$OUTPUT)		
				display_result "Result"	 
	  			;;
			esac
	      			;;	
		esac 
			;;		
	10 ) 		
		enter_text "git branch" "Podanie nazwy - stworzenie branchu, brak prametru wylistowanie"
		case $respose in
	  	0) 
			name=$(<$OUTPUT)
			mygitBranch "${name}" 1>$OUTPUT
			result=$(<$OUTPUT)		
			display_result "Result"	 
	  		;;
		esac
	      		;;
	 11 ) 
		enter_text "git merge" "Podaj nazwe branchu, który chcesz scalić z obecnym"
		case $respose in
	 	0) 
			branch=$(<$OUTPUT)
			mygitMerge "${branch}" 1>$OUTPUT
			result=$(<$OUTPUT)		
			display_result "Result"	 
	 		;;
		esac
	     		;;
	 12 ) 
		enter_text "git grep" "Podaj wzorzec"
		case $respose in
	 	0) 
			pattern=$(<$OUTPUT)
			mygitSearch "${pattern}" 1>$OUTPUT
			result=$(<$OUTPUT)		
			display_result "Result"	 
	  		;;
		esac
	     		;;
	 13 ) 
		enter_text "git add" "Podaj nazwe pliku, który chcesz dodać"
		case $respose in
	 	0) 
			file=$(<$OUTPUT)
			mygitAdd "-f" "${file}" 1>$OUTPUT
			result=$(<$OUTPUT)		
			display_result "Result"
			enter_text "git commit" "Podaj wiadomość commita"
			case $respose in
	 		0) 
				message=$(<$OUTPUT)
				mygitCommit "${message}" 1>$OUTPUT
				result=$(<$OUTPUT)		
				display_result "Result"	 
				enter_text "git push" "Podaj nazwę branchu"
				case $respose in
			 	0) 
					branch=$(<$OUTPUT)
					mygitPush "${branch}" 1>$OUTPUT
					result=$(<$OUTPUT)		
					display_result "Result"	 
			  		;;
				esac
			     		;;
			esac
	     			;;	
		esac
	     		;;	
  	esac
done

}

mygitMenu

