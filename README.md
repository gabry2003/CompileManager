# Project Manager
Insieme di software per creare e gestire progetti in C e in C++ con Visual Studio Code su Debian e derivate

## ISTRUZIONI INSTALLAZIONE
```console
sudo apt-get install git
mkdir tmp
cd tmp
git clone https://github.com/gabry2003/project_manager.git
cd project_manager
```
Compila il programma QT new_project nella cartella **$HOME/tmp/project_manager/new_project/**  
Copia il file eseguibile e copialo nella cartella **/usr/bin/**
```console
chmod +x install_project_manager.sh
./install_project_manager.sh
```
### N.B.
La cartella dello Workspace è la cartella che hai aperto VS Code dove lavori ai tuoi progetti.  
È necessaria per il funzionamento del file tasks.json
