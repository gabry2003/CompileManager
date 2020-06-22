# CompileManager

**CompileManager** è un programma che facilita la compilazione e l'esecuzione cross-platform del codice sorgente in diversi linguaggi di programmazione senza l'utilizzo di un IDE specifico.

Al momento supporta i seguenti linguaggi:

- **C**
- **C++**
- **Python**
- **Kotlin**

Inoltre, permette, in pochi click, di creare un appImage del tuo progetto QT in modo tale da poterlo distribuire senza problemi.

È disponibile per:

- **Debian e derivate**
- **CentOS, Fedora e RedHat**
- **Arch e derivate**

## Funzionamento

Se vuoi compilare solamente un file, puoi selezionarlo e fare partire il processo, altrimenti, se vuoi fare qualcosa di più ordinato o il progetto ha più file, puoi selezionare l'intera cartella e il programma farà tutto da solo.

Verrà creato un file chiamato infoPrj contente le informazioni del progetto (che puoi sempre modificare in un secondo momento) e ad ogni compilazione verrà modificato il file .compileError che segna quante volte di fila è fallito il processo di compilazione.

Gli eseguibili saranno inseriti all'interno della cartella **release** divisi per sistema operativo ed architettura.

Es. release/linux/64bit/

N.B. Per i progetti Python il file principale deve chiamarsi **main_app.py**

## Installazione

Esegui i seguenti comandi:

```shell
cd ~
git clone https://github.com/gabry2003/compileManager.git
cd compileManager
chmod a+x install.sh
sudo ./install.sh
```

## Disinstallazione

Esegui i seguenti comandi:

```shell
cd ~/compileManager/
chmod a+x uninstall.sh
./uninstall.sh
```

### File infoPrj

È strutturato in questo modo:

```textile
Nome progetto
Autore progetto
Descrizione progetto
Tipo UI (gui/console)
Disponibile per 32 bit (1 se lo e' oppure 0 se non lo e')
Disponibile per linux (1 se lo e' oppure 0 se non lo e')
Disponibile per windows (1 se lo e' oppure 0 se non lo e')
```
