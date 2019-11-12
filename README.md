# Project Manager
Insieme di software per creare e gestire progetti in C e in C++ con Visual Studio Code su Debian e derivate

## ISTRUZIONI INSTALLAZIONE
```console
sudo apt-get install git
cd $HOME
mkdir tmp
cd tmp
git clone https://github.com/gabry2003/project_manager.git
cd project_manager
chmod +x install_project_manager.sh
./install_project_manager.sh
```
## SE L'INSTALLAZIONE VA A BUON FINE
```console
cd $HOME
rm -rf tmp
```
### N.B.
La cartella dello Workspace è la cartella che hai aperto VS Code dove lavori ai tuoi progetti.  
È necessaria per il funzionamento del file tasks.json
