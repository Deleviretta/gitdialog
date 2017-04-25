#! /bin/bash


OUTPUT="/tmp/output.txt"
>$OUTPUT

regex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'

wrapper(){
	>$OUTPUT	
	echo $1 
	$2 2>>$OUTPUT 
	result=$(<$OUTPUT)
}

#1) git config --global user.name "name" 
mygitConfigUserName(){	
	if [[ $1 =~ "-h" ]]; then
		echo "Komenda: git config --global user.name 'name'"
	elif [[ $# -eq '0' ]] || [[ -z $1 ]]; then 
		echo "Aktualny nazwa:"	
		git config --global user.name	
	else	
		echo "user.name: $1"
		git config --global user.name "$1"
	fi
}

#2) git config --global user.email valid@email.pl 
mygitConfigUserEmail(){
	if [[ $1 =~ "-h" ]]; then
		echo "Komenda: git config --global user.email valid@email.pl"
	else
		if  [[ $# -ne '0' ]] || ! [[ -z $1 ]]; then
			if [[ $1 =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$ ]]; then			
				echo "user.email: $1"		
				git config --global user.email $1
			else
				echo "Niepoprawny adres"
			fi		
		else
			echo "Aktualny adres:"
			git config --global user.email
		fi
	fi
}

#3) git init 
mygitInitRep() {
	echo "Komenda: git init" 
	git init 

}

#4) git clone 
mygitClone(){
	if [[ $1 =~ "-h" ]]; then
		echo "Komenda: git clone" 
	else
		if ! [[ $1 =~ (\/.*)+ ]] && [[ $1 =~ $regex ]]; then
			wrapper "$1" "git clone $1 $2" #drugi parametr mówi o klonowaniu do katalogu o innej nazwie
		else
			echo "Nieporawne parametry"
		fi		
	fi
	
}

#5) git add 
mygitAdd(){
	if [[ $1 =~ "-h" ]]; then
		echo "Komenda: git add. Opcja -f: podanie konkretnego pliku"	
	else
		if [[ $1 =~ "-f" ]]; then	
			if [[ -f $2 ]]; then
				wrapper "Dodaje plik $2" "git add $2"			
			else 
				echo "Taki plik nie istnieje"
			fi		
		else 
			if [[ $1 =~ \*|\.|-A|--all|-u ]]; then
				wrapper "$1" "git add $1"
			else
				echo "Błędny parametr. Dozwolone znaki '*', '.' , '-A', '--all', '-u', '-f'" 
			fi
		fi
	fi
}

#6) git commit 
mygitCommit(){
	if [[ $1 =~ "-h" ]]; then
		echo "Komenda: git commit. Podany parametr traktowany jest jako wiadomość"	
	else				
		if [[ $1 =~ .+ ]]; then
			wrapper "Wiadomość: $1"	"git commit -m '$1'"
		else	
			echo "Wiadomość ma nieporawny format"
		fi
	fi
}

#7) git status
mygitStatus(){
	echo "Komenda: git status"
	git status
}


#8) git push
mygitPush(){
	if [[ $1 =~ "-h" ]]; then
		echo "Komenda: git push. Parametr --all"
	else		
		if [[ $# -eq 0 ]] || [[ -z $1 ]]; then
			wrapper 'master' 'git push origin master'
		else
			if [[ $1 =~ --all ]]; then
				wrapper "all" 'git push --all origin'
			else
				wrapper "branch: $1" "git push origin $1"		
			fi
		fi
	fi
}

#9) git mv 
mygitMv(){
	if [[ $1 =~ "-h" ]]; then
		echo "Komenda: git mv"
	else
		if [[ $# -ne 0 ]]; then
			if [[ !(-f $1) ]] || [[ $2 =~ \/ ]]; then
				echo "Nieprawidłowe parametry. Podany plik nie istnieje lub nowa nazwa zawiera /"
			else
				wrapper "Zmiana z $1 na $2" "git mv $1 $2"		
			fi
		else
			echo "Za mało parametrów"		
		
		fi
	fi	
}


#10) git remote
mygitRemote(){
	if [[ $1 =~ "-h" ]]; then
		echo "Komenda: git remote"
	else
		if [[ $# -eq 0 ]] || [[ -z $1 ]] ; then
			wrapper "Listowanie:" "git remote -v"
		elif [[ $1 =~ $regex ]]; then
			wrapper "Dodawanie: $1"	"git remote add origin $1"		
		fi
	fi
}

#11) git checkout 
mygitCheckout(){
	if [[ $1 =~ "-h" ]]; then
		echo "Komenda: git checkout. Parametr -b stworzenie branchu i przeniesie się na niego"
	else
		if [[ $# -eq 2 ]] && [[ $1 =~ "-b" ]] && ! [[ -z $2 ]]; then
			wrapper "Nowy branch: $2" "git checkout $1 $2" 
		elif ! [[ -z $1 ]]; then	
			wrapper "Zmiana: $1 " "git checkout $1"
		else
			echo "Brak parametru" 
		fi
	fi
}


#12) git branch 
mygitBranch(){
	if [[ $1 =~ "-h" ]]; then
		echo "Komenda: git branch"
	else
		if [[ $# -eq 0 ]] || [[ -z $1 ]]; then 
			wrapper "Listowanie: " "git branch"
		else
			wrapper "Nowy branch: $1" "git branch $1" #stworzenie nowego branchu
		fi
	fi	
}

#13) git pull 
mygitPull(){
	echo "Komenda: git pull"
	git pull
}

#14) git merge 
mygitMerge(){
	if [[ $1 =~ "-h" ]]; then
		echo "Komenda: git merge"
	else	
		if [[ $# -eq 1 ]] && ! [[ -z $1 ]]; then
			wrapper "Scalam z: $1" "git merge $1"
		else
			echo "Za mało parametrów"
		fi
	fi
}


#15) git grep 
mygitSearch(){
	if [[ $1 =~ "-h" ]]; then
		echo "Komenda: git grep"
	else
		if [[ $# -eq 1 ]] || ! [[ -z $1 ]]; then
			
			wrapper "wzorzec: $1" "git grep $1"
		else
			echo "Brak wzorca" 		
		fi
	fi
}





