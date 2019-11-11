#! /bin/bash
#title          :compile.sh
#description    :Con questo script puoi compilare i progetti creati con new_project.sh
#author         :Gabriele Princiotta
#date           :02-11-2019
#version        :1.0
#note           :Da abbinare a new_project.sh e new_project
#Prendo la cartella del progetto
cartella_progetto=$1
#Prendo in input la scelta se eseguire o meno il programma dopo la compilazione
eseguire=$2
#Architettura processore
architettura=$(uname -i)
#Prendo la distribuzione
#1 = Sia Linux che Windows
#2 = Solo Linux
#3 = Solo Windows
distribuzione=$(head -3 $cartella_progetto/info | tail -1)
#Se le cartelle non esistono e le posso creare le creo, altrimenti fermo lo script
if [ $distribuzione == "1" ] || [ $distribuzione == "2" ]; then #Se rispetta le condizioni
    if [ "$architettura" == "x86_64" ]; then    #Se il computer e' a 64 bit
        if ! test -d $cartella_progetto/release/linux/64bit/; then
            echo "Creazione cartella per Linux a 64 bit..."
            output=$(mkdir -p $cartella_progetto/release/linux/64bit/)
            if $output;then
                echo "Cartella creata!"
            else
                echo "Impossibile creare la cartella!"
                exit
            fi
        fi
    fi
    if ! test -d $cartella_progetto/release/linux/32bit/; then
        echo "Creazione cartella per Linux a 32 bit..."
        output=$(mkdir -p $cartella_progetto/release/linux/32bit/)
        if $output;then
            echo "Cartella creata!"
        else
            echo "Impossibile creare la cartella!"
            exit
        fi
    fi
fi
if [ "$distribuzione" == "1" ] || [ "$distribuzione" == "3" ]; then #Se rispetta le condizioni
    if [ "$architettura" == "x86_64" ]; then    #Se il computer e' a 64 bit
        if ! test -d $cartella_progetto/release/windows/64bit/; then
            echo "Creazione cartella per Windows a 64 bit..."
            output=$(mkdir -p $cartella_progetto/release/windows/64bit/)
            if $output;then
                echo "Cartella creata!"
            else
                echo "Impossibile creare la cartella!"
                exit
            fi
        fi
    fi
    if ! test -d $cartella_progetto/release/windows/32bit/; then
        echo "Creazione cartella per Windows a 32 bit..."
        output=$(mkdir -p $cartella_progetto/release/windows/32bit/)
        if $output;then
            echo "Cartella creata!"
        else
            echo "Impossibile creare la cartella!"
            exit
        fi
    fi
fi
#Prendo il linguaggio utilizzato (C o C++)
tipo_progetto=$(head -1 $cartella_progetto/info | tail -1)
#Se e' C++
if [ "$tipo_progetto" == "c++" ]; then
    estensione_file=cpp
    #Siccome io uso l'estensione .cpp per i file c++, ma si possono usare altre estensioni, le cambio tutte
    for file in $cartella_progetto/*.cc $cartella_progetto/*.cxx $cartella_progetto/*.c++; do
        #Se il file esiste
        if test -f $file; then
            estensione="${FILE##*.}"
            #Cambio l'estensione a tutti i file
            if mv $file ${file%.*}".cpp"; then
                echo "File "$file" rinominato in "${file%.*}".cpp"
            fi
        fi
    done
else
    #Se e' C
    estensione_file=c
fi
#Se i file contengono gli spazi, li sostituisco con un underscore
for FILE in $cartella_progetto/*.$estensione_file; do
    #Se il nome del file contiene spazi
    if [[ $FILE =~ " " ]];then
        mv "$FILE" $(echo $FILE | tr " " "_")
    fi
done
#Prendo il tipo di UI (grafica o console, per ora solo console)
tipo_grafica=$(head -2 $cartella_progetto/info | tail -1)
#Prendo il nome del progetto
nome_progetto=$(head -5 $cartella_progetto/info | tail -1)
#Cartella corrente, per il nome del file eseguibile
current_dir=$(basename $cartella_progetto)
compilazione_linux_64="0"
compilazione_windows_32="0"
compilazione_linux_64="0"
compilazione_windows_32="0"
#Se il progetto e' a riga di comando
if [ "$tipo_grafica" == "console" ]; then
    if [ "$distribuzione" == "1" ] || [ "$distribuzione" == "2" ]; then  #Compilo per Linux solo se lo prevede il progetto
        #Compilo per Linux, per C o per C++
        #Compilo per 64 bit solo se sono su 64 bit
        if [ "$architettura" == "x86_64" ]; then
            echo "Compilo per Linux a 64 bit..."
            if [ "$tipo_progetto" == "c++" ]; then
                if g++ -g $cartella_progetto/*.cpp -o $cartella_progetto/release/linux/64bit/$current_dir -fexceptions -Wall;then
                    echo "Compilazione effettuata! File eseguibile su release/linux/64bit/"$current_dir
                    compilazione_linux_64="1"
                fi
            else
                if gcc -g $cartella_progetto/*.c -o $cartella_progetto/release/linux/64bit/$current_dir -fexceptions -Wall;then
                    echo "Compilazione effettuata! File eseguibile su release/linux/64bit/"$current_dir
                    compilazione_linux_64="1"
                fi
            fi
        fi
        echo "Compilo per Linux a 32 bit..."
        if [ "$tipo_progetto" == "c++" ]; then
            if g++ -g -m32 $cartella_progetto/*.cpp -o $cartella_progetto/release/linux/32bit/$current_dir -fexceptions -Wall;then
                echo "Compilazione effettuata! File eseguibile su release/linux/32bit/"$current_dir
                compilazione_linux_32="1"
            fi
        else
            if gcc -g -m32 $cartella_progetto/*.c -o $cartella_progetto/release/linux/32bit/$current_dir -fexceptions -Wall;then
                echo "Compilazione effettuata! File eseguibile su release/linux/32bit/"$current_dir
                compilazione_linux_32="1"
            fi
        fi
    fi
    if [ "$distribuzione" == "1" ] || [ "$distribuzione" == "3" ]; then #Compilo per Windows solo se lo prevede il progetto
        #Compilo per Windows, per C o per C++
        #Compilo per 64 bit solo se sono su 64 bit
        if [ "$architettura" == "x86_64" ]; then
            echo "Compilo per Windows a 64 bit..."
            if [ "$tipo_progetto" == "c++" ]; then
                if x86_64-w64-mingw32-g++ -g $cartella_progetto/*.cpp -o $cartella_progetto/release/windows/64bit/$current_dir.exe -static-libgcc -static-libstdc++;then
                    echo "Compilazione effettuata! File eseguibile su release/windows/64bit/"$current_dir".exe"
                    compilazione_windows_64="1"
                fi
            else
                if x86_64-w64-mingw32-gcc -g $cartella_progetto/*.c -o $cartella_progetto/release/windows/64bit/$current_dir.exe -static-libgcc -static-libstdc++;then
                    echo "Compilazione effettuata! File eseguibile su release/windows/64bit/"$current_dir".exe"
                    compilazione_windows_64="1"
                fi
            fi
        fi
        echo "Compilo per Windows a 32 bit..."
        if [ "$tipo_progetto" == "c++" ]; then
            if i686-w64-mingw32-g++ -g $cartella_progetto/*.cpp -o $cartella_progetto/release/windows/32bit/$current_dir.exe -static-libgcc -static-libstdc++;then
                echo "Compilazione effettuata! File eseguibile su release/windows/32bit/"$current_dir".exe"
                compilazione_windows_32="1"
            fi
        else
            if i686-w64-mingw32-gcc -g $cartella_progetto/*.c -o $cartella_progetto/release/windows/32bit/$current_dir.exe -static-libgcc -static-libstdc++;then
                echo "Compilazione effettuata! File eseguibile su release/windows/32bit/"$current_dir".exe"
                compilazione_windows_64="1"
            fi
        fi
    fi
else    #Altrimenti
    #Al momento compila solo i progetti di QT Creator
    #Compilo il progetto
    cd $cartella_progetto
    make clean
    if [ "$distribuzione" == "1" ] || [ "$distribuzione" == "2" ]; then  #Compilo per Linux solo se lo prevede il progetto
        echo "Compilo per Linux..."
        if qmake -qt=qt5 && make; then   #Se compila il progetto
            if mv $nome_progetto release/linux/64bit/$nome_progetto; then
                echo "Progetto compilato con successo. Disponibile su $cartella_progetto/release/linux/64bit/$nome_progetto"
                compilazione_linux_64="1"
            else
                echo "Impossibile compilare il progetto!"
            fi
        else
            echo "Impossibile compilare il progetto!"
        fi
    fi
    if [ "$distribuzione" == "1" ] || [ "$distribuzione" == "3" ]; then #Compilo per Windows solo se lo prevede il progetto
        echo ""
        echo "Compilo per Windows a 64bit..."
        #Compilo per Windows a 64 bit solo se sono su 64 bit
        if [ "$architettura" == "x86_64" ]; then
            if qmake -qt=qt5 && make CC=x86_64-w64-mingw32-gcc CXX=x86_64-w64-mingw32-g++ LINK=x86_64-w64-mingw32-g++; then   #Se compila il progetto
                if mv "$nome_progetto" "release/windows/64bit/$nome_progetto.exe"; then
                    echo "Progetto compilato con successo. Disponibile su $cartella_progetto/release/windows/64bit/$nome_progetto.exe"
                    compilazione_windows_64="1"
                else
                    echo "Impossibile compilare il progetto!"
                fi
            else
                echo "Impossibile compilare il progetto!"
            fi
        fi
        echo "Compilo per Windows a 32bit..."
        if qmake -qt=qt5 && make CC=i686-w64-mingw32-gcc CXX=i686-w64-mingw32-g++ LINK=i686-w64-mingw32-g++; then   #Se compila il progetto
            if mv "$nome_progetto" "release/windows/32bit/$nome_progetto.exe"; then
                echo "Progetto compilato con successo. Disponibile su $cartella_progetto/release/windows/32bit/$nome_progetto.exe"
                compilazione_windows_32="1"
            else
                echo "Impossibile compilare il progetto!"
            fi
        else
            echo "Impossibile compilare il progetto!"
        fi

    fi
    make clean
fi
#Se ha scelto di eseguire il programma
if [ "$eseguire" == "1" ]; then
    echo ----------------------------------
    echo "Esecuzione programma in corso..."
    echo ----------------------------------
    clear
    #Se sono su 64 bit
    if [ "$architettura" == "x86_64" ]; then
        #Se la compilazione ha avuto successo
        if [ "$compilazione_linux_64" == "1" ]; then
            #Se il programma non si puo' eseguire
            if ! $cartella_progetto/release/linux/64bit/./*;then
                echo -------------------------------
                echo Impossibile aprire il programma
                echo -------------------------------
            fi
        else    #Altrimenti
            echo "Non posso eseguire il programma perche' la compilazione non ha avuto successo!"
        fi
    else    #Altrimenti
        #Se la compilazione ha avuto successo
        if [ "$compilazione_linux_32" == "1" ]; then
            #Se il programma si puo' eseguire
            if ! $cartella_progetto/release/linux/32bit/./*;then
                echo -------------------------------
                echo Impossibile aprire il programma
                echo -------------------------------
            fi
        else    #Altrimenti
            echo "Non posso eseguire il programma perche' la compilazione non ha avuto successo!"
        fi
    fi
fi
