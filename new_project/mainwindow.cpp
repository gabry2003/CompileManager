#include "mainwindow.h"
#include "ui_mainwindow.h"
static QString cartella_progetto;
MainWindow::MainWindow(QStringList arguments, QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    cartella_progetto = arguments[1];
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_creaProgetto_clicked()
{
    //Quando viene cliccato il pulsante per creare un nuovo progetto
    //Dichiaro le variabili
    QString autore,nome,descrizione,linguaggio,interfaccia_grafica,distribuzione_,distribuzione,comando;
    autore = ui->autore->text();    //Autore del progetto
    nome = ui->nome->text();    //Nome del progetto
    descrizione = ui->descrizione->text();  //Descrizione del progetto
    linguaggio = ui->linguaggio->currentText(); //Linguaggio utilizzato
    interfaccia_grafica = ui->interfaccia_grafica->currentText();   //Tipo interfaccia grafica
    distribuzione_ = ui->distribuzione->currentText();   //Distribuzione del progetto
    if(distribuzione_ == "Sia Linux che Windows") {
        distribuzione = "1";
    }else if(distribuzione_ == "Solo Linux") {
        distribuzione = "2";
    }else {
        distribuzione = "3";
    }
    comando = "\"/usr/share/new_project.sh\" ";
    comando += "\"" + cartella_progetto + "\" ";  //Aggiungo la cartella del progetto
    comando += "\"" + linguaggio + "\" ";    //Aggiungo il linguaggio utilizzato
    comando += "\"" + interfaccia_grafica + "\" ";   //Aggiungo il tipo di interfaccia grafica
    comando += "\"" + distribuzione + "\" "; //Aggiungo la distribuzione del progetto
    comando += "\"" + autore + "\" ";   //Aggiungo l'autore del progetto
    comando += "\"" + nome + "\" ";  //Aggiungo il nome del progetto
    comando += "\"" + descrizione + "\""; //Aggiungo la descrizione del progetto
    //system(comando.toLocal8Bit().constData());
    qDebug() << comando;
    QProcess *process = new QProcess();
    QString exec = "xterm";
    QStringList params;
    params << "-hold" << "-e" << comando;
    process->start(exec, params);
}

void MainWindow::on_pulisciTutto_clicked()
{
    //Quando viene cliccato il pulsante per pulire tutto
    ui->autore->setText("");    //Pulisco l'input dell'autore
    ui->nome->setText("");    //Pulisco l'input del nome
    ui->descrizione->setText("");    //Pulisco l'input della descrizione
    ui->linguaggio->setCurrentText("C++");    //Pulisco l'input del linguaggio utilizzato
    ui->interfaccia_grafica->setCurrentText("Console");    //Pulisco l'input del tipo di interfaccia grafica
    ui->distribuzione->setCurrentText("Sia Linux che Windows");    //Pulisco l'input del linguaggio utilizzato
}
