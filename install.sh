#!/bin/bash

## Project		: Compile Manager
## Description	: Un programma che facilita la compilazione del codice sorgente in diversi linguaggi senza l'utilizzo di alcun IDE
## File			: install.sh
## Author		: Gabriele Princiotta
## Date			: 09/06/2020

# Funzioni per stampare a schermo il testo con diversi colori
shw_green () {
    echo $(tput bold)$(tput setaf 2) $@ $(tput sgr 0)
}

shw_info () {
    echo $(tput bold)$(tput setaf 4) $@ $(tput sgr 0)
}

shw_warn () {
    echo $(tput bold)$(tput setaf 3) $@ $(tput sgr 0)
}

shw_err ()  {
    echo $(tput bold)$(tput setaf 1) $@ $(tput sgr 0)
}

shw_title () {	# Funzione per stampare a schermo il titolo del programma
	tput bold; tput setaf 3; cat /opt/compileManager/logo.txt; tput sgr 0
	echo
	echo
	shw_info "Descrizione:"
	shw_info "Grazie a questo programma ti viene facilitata la compilazione e l'esecuzione cross-platform del codice sorgente in diversi linguaggi, senza bisogno di un IDE specifico:"
	shw_info "- C"
	shw_info "- C++"
	shw_info "- Python"
	shw_info "- Kotlin"
	shw_info "Inoltre, permette in pochi click di creare un appImage del tuo progetto QT, cosi' da renderlo eseguibile su tutte le distribuzioni"
	echo
	shw_warn "Disponibile per:"
	shw_warn "- Debian e derivate"
	shw_warn "- CentOS, Fedora e RedHat"
	shw_warn "- Arch e derivate"
	echo
	shw_warn "ATTENZIONE, COL TEMPO SARANNO AGGIUNTE ALTRE FUNZIONI ABBASTANZA UTILI"
	shw_warn "IN CONCLUSIONE, FA SCHIFO MA HA ANCHE DEI DIFETTI :)"
}

# Trovo il package manager del sistema operativo
package_manager=""
declare -A osInfo;
osInfo[/etc/debian_version]="apt"
osInfo[/etc/centos-release]="yum"
osInfo[/etc/fedora-release]="yum"
osInfo[/etc/redhat-release]="yum"
osInfo[/etc/arch-release]="pacman"

for f in ${!osInfo[@]}; do

    if [[ -f $f ]]; then
        package_manager=${osInfo[$f]}
    fi

done

shw_title

echo
echo

if [ "$package_manager" != "" ]; then	# Se il package manager e' stato trovato
	shw_info "Rilevato package manager: $package_manager"
else
	shw_err "Il programma non supporta la tua distribuzione!"	# Messaggio di errore
	exit	# Fermo lo script
fi

# Trovo l'architettura del sistema operativo
architettura=$(uname -i)

echo
shw_info "Rilevata architettura: $architettura"

echo

saltaDipendenze=$1

if [ "$saltaDipendenze" != "1" ]; then
	echo "Dipendenze da installare:"
	shw_info "- build-essential (per avere a disposizione tutti gli strumenti di sviluppatore)"

	if [ "$architettura" == "x86_64" ]; then	# Se l'OS e' a 64 bit
		shw_info "- librerie per eseguire programmi a 32 bit"
	fi

	shw_info "- mingw (necessario a compilare per Windows)"
	shw_info "- g++-multilib (necessario a compilare per Windows)"

	if [ "$package_manager" == "apt-get" ]; then	# Se e' una distro basata su Debian
		shw_info "- aptitude (necessario ad installare Wine)"
	fi

	shw_info "- Wine (necessario ad eseguire i programmi compilati per Windows)"
	shw_info "- OpenJDK"
	shw_info "- Kotlin"
	shw_info "- xTerm"
	shw_info "- Linuxdeployqt (per creare appImage di progetti Qt)"
	shw_info "- Appimagetool (per creare appImage di progetti Qt)"

	echo
	shw_warn "Per installarle dovrai inserire la tua password per darmi i permessi di amministratore"
	echo

	if [ "$package_manager" == "apt" ]; then	# Se e' una distro basata su Ubuntu

		# Installo build-essential
		echo "Installazione di build-essential in corso..."
		if sudo apt install -y build-essential;then
		    shw_green "Installazione di build-essential effettuata con successo!"
		else    # Altrimenti
		    shw_err "Installazione fallita!"   # Messaggio di errore
		    exit    # Fermo lo script
		fi

		if [ "$architettura" == "x86_64" ]; then	# Se l'OS e' a 64 bit
			echo "Installazione librerie per eseguire programmi a 32 bit in corso ..."
			
			sudo dpkg --add-architecture i386
			sudo apt-get update
			sudo apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386
			sudo apt-get install -y multiarch-support
			sudo apt-get install -y libc6-dev-i386
		fi

		# Installo Qmake
		echo "Installazione di Qmake in corso..."
		if sudo apt-get install -y qt5-qmake; then
			shw_green "Qmake installato con successo!"
		else
			shw_warn "Installazione fallita, impossibile compilare progetti QT"
		fi

		# Installo MinGW
		echo "Installazione di MinGW in corso..."
		if sudo apt install -y mingw-w64;then
		    shw_green "Installazione di MinGW effettuata con successo!"
		else    # Altrimenti
		    shw_warn "Installazione fallita, impossibile compilare per Windows!"   # Messaggio di errore
		fi

		# Installo g++-multilib
		echo "Installazione di g++-multilib (necessario a compilare per Windows) in corso..."
		if sudo apt-get install -y g++-multilib;then
		    echo "Installazione di g++-multilib effettuata con successo!"
		else    # Altrimenti
		    shw_warn "Installazione fallita, impossibile compilare per Windows!"   # Messaggio di errore
		fi

		# Installo Aptitude
		echo "Installazione di aptitude (necessario ad installare Wine) in corso..."
		if sudo apt install -y aptitude;then
		    shw_green "Installazione di aptitude effettuata con successo!"
		else    # Altrimenti
		    shw_warn "Installazione fallita, impossibile installare Wine!"   # Messaggio di errore
		fi

		# Installo Wine
		echo "Installazione di Wine (necessario ad eseguire i programmi compilati per Windows) in corso..."
		sudo dpkg --add-architecture i386
		wget -qO- https://dl.winehq.org/wine-builds/Release.key | sudo apt-key add -
		sudo apt-add-repository 'deb http://dl.winehq.org/wine-builds/ubuntu/ artful main'
		sudo apt update
		if sudo aptitude install -y winehq-stable; then
		    shw_green "Installazione di Wine effettuata con successo!"
		else    # Altrimenti
		    shw_warn "Installazione fallita, impossibile eseguire i programmi per Windows!"   # Messaggio di errore
		fi

		# Installo OpenJDK
		sudo apt install -y snapd
		echo "Installazione di OpenJDK in corso..."
		if sudo apt install -y openjdk-11-jdk; then
			shw_green "Installazione di OpenJDK effettuata con successo!"
		else
			shw_warn "Installazione fallita, impossibile compilare ed eseguire Kotlin!"	# Messaggio di errore
		fi

		# Installo Kotlin
		echo "Installazione di Kotlin in corso..."
		if yes | sudo snap install --classic kotlin; then
			shw_green "Installazione di Kotlin effettuata con successo!"
		else
			shw_warn "Installazione fallita, impossibile compilare ed eseguire Kotlin!"	# Messaggio di errore
		fi

		# Installo Python3
		echo "Installazione di Python3 in corso..."
		if sudo apt install -y python3; then
			shw_green "Installazione di Python3 effettuata con successo!"
		else
			shw_warn "Installazione fallita, impossibile compilare ed eseguire per python!"	# Messaggio di errore
		fi

		# Installo xTerm
		echo "Installazione di xTerm in corso..."
		if sudo apt install -y xterm; then
		    shw_green "Installazione di xTerm effettuata con successo!"
		else
		    shw_warn "Installazione fallita, impossibile eseguire i programmi in una nuova finestra di terminale!" # Messaggio di errore
		    exit    # Fermo lo script
		fi

	elif [ "$package_manager" == "yum" ]; then	# Se sono su CentOS o Fedora

		# Installo build-essential
		echo "Installazione build-essential in corso..."
		if sudo yum groupinstall -y "Development Tools" "Development Libraries"; then
			shw_green "build-essential installato con successo!"
		else
			shw_err "Installazione fallita!"	# Messaggio di errore
			exit
		fi

		if [ "$architettura" == "x86_64" ]; then	# Se l'OS e' a 64 bit
			echo "Installazione librerie per eseguire programmi a 32 bit in corso ..."
			sudo yum install -y glibc.i686
			sudo yum install -y glibc-devel.i686
		fi

		# Installo Qmake
		echo "Installazione di Qmake in corso..."
		if sudo dnf install -y qt5-devel; then
			shw_green "Qmake installato con successo!"
		else
			shw_warn "Installazione fallita, impossibile compilare progetti QT"
		fi

		# Installo MinGW
		echo "Installazione di MinGW in corso..."
		if sudo yum install -y mingw64-gcc-c++ mingw64-gcc-c++ mingw64-headers mingw64-crt mingw64-winpthreads mingw64-cpp mingw64-filesystem mingw32-gcc-c++ mingw32-gcc-c++ mingw32-headers mingw32-crt mingw32-winpthreads mingw32-cpp mingw32-filesystem;then
		    shw_green "Installazione di MinGW effettuata con successo!"
		else    # Altrimenti
		    shw_warn "Installazione fallita, impossibile compilare per Windows!"   # Messaggio di errore
		fi

		# Installo g++-multilib
		echo "Installazione di g++-multilib (necessario a compilare per Windows) in corso..."
		sudo yum install -y glibc-devel.i386 libstdc++-devel.i386 glibc-devel.i686 glibc-devel libstdc++-devel.i686

		# Installo Wine
		source /etc/os-release
		rpm --import https://dl.winehq.org/wine-builds/winehq.key
		sudo yum config-manager --add-repo https://dl.winehq.org/wine-builds/fedora/$VERSION_ID/winehq.repo
		if sudo yum -y install wine; then
			shw_green "Installazione di Wine effettuata con successo!"
		else
			shw_warn "Installazione fallita, impossibile eseguire i programmi per Windows!" # Messaggio di errore
		fi

		# Installo OpenJDK
		if ! test -d /snap; then
			sudo yum install -y snapd
			sudo rm /snap
			sudo ln -s /var/lib/snapd/snap /snap
			sudo systemctl enable --now snapd.socket
		fi

		echo "Installazione di OpenJDK in corso..."
		if sudo dnf install -y java-11-openjdk; then
			shw_green "Installazione di Kotlin effettuata con successo!"
		else
			shw_warn "Installazione fallita, impossibile compilare ed eseguire Kotlin!"	# Messaggio di errore
		fi

		# Installo Kotlin
		echo "Installazione di Kotlin in corso..."
		if yes | sudo snap install --classic kotlin; then
			shw_green "Installazione di Kotlin effettuata con successo!"
		else
			shw_warn "Installazione fallita, impossibile compilare ed eseguire Kotlin!"	# Messaggio di errore
		fi

		# Installo Python3
		echo "Installazione di Python3 in corso..."
		if sudo dnf install -y python3; then
			shw_green "Installazione di Python3 effettuata con successo!"
		else
			shw_warn "Installazione fallita, impossibile compilare ed eseguire per python!"	# Messaggio di errore
		fi

		# Installo xTerm
		echo "Installazione di xTerm in corso..."
		if sudo yum -y install xterm; then
		    shw_green "Installazione di xTerm effettuata con successo!"
		else
		    shw_warn "Installazione fallita, impossibile eseguire i programmi in una nuova finestra di terminale!" # Messaggio di errore
		fi

	elif [ "$package_manager" == "pacman" ]; then	# Se sono su Arch o derivate
		
		# Installo build-essential
		echo "Installazione build-essential in corso..."
		if sudo pacman -Syyu base-devel; then
			shw_green "build-essential installato con successo!"
		else
			shw_err "Installazione fallita!"	# Messaggio di errore
			exit
		fi

		if [ "$architettura" == "x86_64" ]; then	# Se l'OS e' a 64 bit
			echo "Installazione librerie per eseguire programmi a 32 bit in corso ..."

			# Abilito multilib
			a="#[multilib]"
			b="[multilib]"
			x="#Include = /etc/pacman.d/mirrorlist"
			y="Include = /etc/pacman.d/mirrorlist"
			sudo sed -i -e 's/$a/$b/g' /etc/pacman.d/mirrorlist
			sudo sed -i -e 's/$x/$y/g' /etc/pacman.d/mirrorlist
			pacman -Syu

			# Installo il pacchetto
			sudo pacman -S lib32-glibc
		fi

		# Installo MinGW
		echo "Installazione di MinGW in corso..."
		wget https://aur.archlinux.org/cgit/aur.git/snapshot/mingw-w64-gcc.tar.gz	# Scarico il sorgente
		tar xzvf mingw-w64-gcc.tar.gz	# Lo estraggo
		cd mingw-w64-gcc/
		if makepkg -si; then
			shw_green "MinGW installato con successo!"
		else
			shw_warn "Installazione fallita, impossibile compilare per Windows!"
		fi

		cd ..	# Torno alla directory precedente

		# Installo Wine
		echo "Installazione di Wine in corso..."
		if pacman -S wine; then
			shw_green "Installazione di Wine avvenuta con successo!"
		else
			shw_warn "Installazione fallita, impossibile eseguire i programmi per Windows!"
		fi

		# Installo OpenJDK
		shw_warn "PER UTILIZZARE KOTLIN INSTALLA MANUALMENTE OPENJDK E KOTLIN"
		sudo pacman -S snapd
		sudo systemctl enable --now snapd.socket

		# Installo Python3
		echo "Installazione di Python3 in corso..."
		if sudo pacman -S python-'package'; then
			shw_green "Installazione di Python3 effettuata con successo!"
		else
			shw_warn "Installazione fallita, impossibile compilare ed eseguire per python!"	# Messaggio di errore
		fi

		# Installo xTerm
		echo "Installazione di xTerm in corso..."
		if sudo pacman -S xterm; then
			shw_green "Installazione di xTerm effettuata con successo!"
		else
			shw_warn "Installazione fallita, impossibile eseguire i programmi in una nuova finestra di terminale!" # Messaggio di errore
		fi

	else

		shw_err "Il programma non supporta la tua distribuzione!"	# Messaggio di errore
		exit	# Fermo lo script

	fi

	# Se Linuxdeployqt e' installato
	if test -f /bin/linuxdeployqt || test -f /usr/bin/linuxdeployqt || test -f /usr/local/bin/linuxdeployqt || test -f /sbin/linuxdeployqt || test -f /usr/sbin/linuxdeployqt || test -f /usr/local/sbin/linuxdeployqt; then    #Se linuxdeployqt e' gia' installato
	    shw_green "Linuxdeployqt e' gia' installato!"
	else    # Altrimenti

	    echo "Installazione di Linuxdeployqt in corso..."

	    #Lo scarico, lo rinomino e lo sposto su /usr/bin/
	    if wget https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage && sudo mv linuxdeployqt-continuous-x86_64.AppImage /usr/bin/linuxdeployqt && sudo chmod a+x /usr/bin/linuxdeployqt; then   #Se lo ha installato
	        shw_green "Linuxdeployqt installato con successo!"
	    else    # Altrimenti
	        shw_warn "Impossibile scaricare Linuxdeployqt! E' necessario per creare AppImage di progetti QT ma l'installazione puo' comunque continuare senza utilizzare al momento questa funzione!"
	    fi

	fi

	# Se appimagetool e' installato
	if test -f /usr/bin/appimagetool.AppImage; then    #Se appimagetool e' gia' installato
	    shw_green "Appimagetool e' gia' installato!"
	else    # Altrimenti

	    echo "Installazione di Appimagetool in corso..."

	    # Lo scarico, lo rinomino e lo sposto su /usr/bin/
	    if wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage && sudo mv appimagetool-x86_64.AppImage /usr/bin/appimagetool.AppImage && sudo chmod a+x /usr/bin/appimagetool.AppImage; then   #Se lo ha installato
	        shw_green "Appimagetool installato con successo!"
	    else    # Altrimenti
	        shw_warn "Impossibile scaricare Appimagetool! E' necessario per creare AppImage di progetti QT ma l'installazione puo' comunque continuare senza utilizzare al momento questa funzione!"
	    fi

	fi

	if pip3 install pyinstaller --user; then
		shw_green "Pyinstaller installato con successo!"
	else
		shw_warn "Impossibile installare pyinstaller!"
	fi

fi

# Creo la cartella /opt/compileManager/
if test -d /opt/compileManager/ && test -d /opt/compileManager/bin; then
	shw_green "Cartella /opt/compileManager/ gia' presente!"
else
	if sudo mkdir /opt/compileManager/ && sudo mkdir /opt/compileManager/bin/; then
		shw_green "Cartella /opt/compileManager/ creata con successo!"
	else
		shw_err "Impossibile creare la cartella /opt/compileManager/"
		shw_err "Installazione fallita!"
		exit
	fi
fi

# Creo l'AppImage
chmod +x *.sh
chmod a+x compileManagerGUI/./toAppImage.sh
./createAppImage.sh "$(pwd)/compileManagerGUI/" "0"
mv compileManagerGUI/release/linux/64bit/compileManagerGUI.AppImage compileManager.AppImage

# Inserisco all'interno della cartella i file necessari
if  sudo cp compile.sh /opt/compileManager/ && sudo cp createAppImage.sh /opt/compileManager/ && sudo cp logo.txt /opt/compileManager/ && sudo cp icon.png /opt/compileManager/ && sudo chmod a+x compileManager.AppImage && sudo cp compileManager.AppImage /opt/compileManager/bin/ && sudo cp compileManager.desktop /opt/compileManager/bin/; then
	shw_green "File inseriti correttamente all'interno della cartella!"
else
	shw_err "Impossibile inserire i file all'interno della cartella!"
	exit
fi

# Creo i collegamenti simbolici
# /usr/share/applications/compileManager.desktop -> /opt/compileManager/bin/compileManager.desktop
# /usr/bin/compileManager -> /opt/compileManager/bin/compileManager.AppImage

sudo rm /usr/share/applications/compileManager.desktop
sudo rm /usr/bin/compileManager

if sudo ln -s /opt/compileManager/bin/compileManager.desktop /usr/share/applications/compileManager.desktop && sudo ln -s /opt/compileManager/bin/compileManager.AppImage /usr/bin/compileManager; then
	shw_green "Collegamenti simbolici creati con successo!"
else
	shw_err "Impossibile creare i collegamenti simbolici!"
	exit
fi

shw_green "CompileManager installato con successo!"

echo
echo "Vuoi eseguirlo? (s|n)"
read eseguire

if [ "$eseguire" == "s" ] || [ "$eseguire" == "S" ]; then
	compileManager
else
	exit
fi
