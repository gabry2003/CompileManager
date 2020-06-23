#include "mainwindow.h"
#include "ui_mainwindow.h"

QString pathPassata;

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
}

MainWindow::~MainWindow()
{
    delete ui;
}


void MainWindow::on_actionEsci_triggered()
{
    // Pulsante "Esci"
    QCoreApplication::quit();
}

void MainWindow::on_actionApri_progetto_triggered()
{
    // Pulsante "Apri progetto"
    QString dir;
    if (pathPassata != "") {
        dir = pathPassata;
        pathPassata = "";
    }else {

        QString username = qgetenv("USER");
        if (username.isEmpty()) username = qgetenv("USERNAME");
        dir = QFileDialog::getExistingDirectory(this, tr("Seleziona cartella progetto"), "/home/" + username + "/", QFileDialog::ShowDirsOnly | QFileDialog::DontResolveSymlinks);
        if (dir == "") return;  // Se non ha selezionato una cartella annullo

    }

    // Se il file del progetto non esiste lo creo
    std::ifstream tmp(dir.toStdString() + "/infoPrj");
    if (tmp.fail()) {

        QMessageBox::StandardButton reply;
        reply = QMessageBox::question(this, "Progetto non esistente", "Vuoi creare un progetto e modificarlo?", QMessageBox::Yes | QMessageBox::No);
        if (reply == QMessageBox::Yes) {

            std::ofstream tmp2(dir.toStdString() + "/infoPrj");
            if (tmp2.is_open()) {   // Se si puo' creare il proegtto

                tmp2 << "Nome progetto" << "\n";
                tmp2 << "Autore progetto" << "\n";
                tmp2 << "Descrizione" << "\n";
                tmp2 << "console" << "\n";
                tmp2 << "1" << "\n";
                tmp2 << "1" << "\n";
                tmp2 << "1";
                tmp2.close();

            }else {
                QMessageBox::critical(this, tr("Errore"), tr("Impossibile creare il progetto"), QMessageBox::Ok);
                qDebug() << dir;
                return;
            }

        } else {
            QMessageBox::warning(this, tr("Progetto non aperto"), tr("Hai deciso di non creare il progetto in questa cartella, quindi non è stato aperto alcun progetto"), QMessageBox::Ok);
            return;
        }

    }else {
        tmp.close();
    }

    QFile infoPrj(QString(dir + "/infoPrj"));
    infoPrj.open(QIODevice::ReadOnly);

    if (infoPrj.isOpen()) {
        ui->pathProgetto->setText(dir);

        /*
        **Struttura file infoPrj:**
        Nome progetto
        Autore progetto
        Descrizione progetto
        Tipo UI (gui/console)
        Disponibile per 32 bit (1 se lo e' oppure 0 se non lo e')
        Disponibile per linux (1 se lo e' oppure 0 se non lo e')
        Disponibile per windows (1 se lo e' oppure 0 se non lo e')
        */

        QTextStream stream(&infoPrj);
        QString nomeProgetto = stream.readLine();
        QString autoreProgetto = stream.readLine();
        QString descrizioneProgetto = stream.readLine();
        QString tipoInterfaccia = stream.readLine();
        QString thereIs32Bit = stream.readLine();
        QString thereIsLinux = stream.readLine();
        QString thereIsWindows = stream.readLine();

        infoPrj.close();

        ui->inputNomeProgetto->setText(nomeProgetto);
        ui->inputAutoreProgetto->setText(autoreProgetto);
        ui->inputDescrizioneProgetto->setText(descrizioneProgetto);
        ui->inputTipoInterfaccia->setCurrentText(tipoInterfaccia);
        if (tipoInterfaccia == "gui") { // Se il progetto e' ad interfaccia grafica
            ui->pulsanteCreaAppImage->setEnabled(true);
            ui->pulsanteAppImageEdEsegui->setEnabled(true);
        }else {
            ui->pulsanteCreaAppImage->setEnabled(false);
            ui->pulsanteAppImageEdEsegui->setEnabled(false);
        }

        if(thereIsLinux == "1") {
            ui->checkboxLinux->setChecked(true);
            ui->pulsanteEseguiLinux32->setEnabled(true);
            ui->pulsanteEseguiLinux64->setEnabled(true);
        }else {
            ui->checkboxLinux->setChecked(false);
            ui->pulsanteEseguiLinux32->setEnabled(false);
            ui->pulsanteEseguiLinux64->setEnabled(false);
        }
        if(thereIsWindows == "1") {
            ui->checkboxWindows->setChecked(true);
            ui->pulsanteEseguiWindows32->setEnabled(true);
            ui->pulsanteEseguiWindows64->setEnabled(true);
        }else {
            ui->checkboxWindows->setChecked(false);
            ui->pulsanteEseguiWindows32->setEnabled(false);
            ui->pulsanteEseguiWindows64->setEnabled(false);
        }
        if(thereIs32Bit == "1") {
            ui->checkbox32Bit->setChecked(true);
            ui->pulsanteEseguiLinux32->setEnabled(true);
            ui->pulsanteEseguiWindows32->setEnabled(true);
        }else {
            ui->checkbox32Bit->setChecked(false);
            ui->pulsanteEseguiLinux32->setEnabled(false);
            ui->pulsanteEseguiWindows32->setEnabled(false);
        }
        ui->pushButton->setEnabled(true);
        infoPrj.close();

    }else {
        // Impossibile aprire il progetto
        QMessageBox::critical(this, tr("Errore"), tr("Impossibile aprire il progetto"), QMessageBox::Ok);
    }

}

void MainWindow::on_pulsanteEseguiLinux64_clicked()
{
    // Pulsante "Esegui Linux a 64 bit"
    QString path = ui->pathProgetto->text();
    std::string command = "xterm -hold -e 'PROMPT_COMMAND= echo -en \"\033]0;Esegui Linux 64 bit\a\"; " + path.toStdString() + "/release/linux/64bit/./*'; exit";
    system(command.c_str());
}

void MainWindow::on_pulsanteEseguiLinux32_clicked()
{
    // Pulsante "Esegui Linux a 32 bit"
    QString path = ui->pathProgetto->text();
    std::string command = "xterm -hold -e 'PROMPT_COMMAND= echo -en \"\033]0;Esegui Linux 32 bit\a\"; " + path.toStdString() + "/release/linux/32bit/./*'; exit";
    system(command.c_str());

}

void MainWindow::on_pulsanteEseguiWindows64_clicked()
{
    // Pulsante "Esegui Windows a 64 bit"
    QString path = ui->pathProgetto->text();
    std::string command = "xterm -hold -e 'PROMPT_COMMAND= echo -en \"\033]0;Esegui Windows 64 bit\a\"; wine " + path.toStdString() + "/release/windows/64bit/*.exe'; exit";
    system(command.c_str());

}

void MainWindow::on_pulsanteEseguiWindows32_clicked()
{
    // Pulsante "Esegui Windows a 32 bit"
    QString path = ui->pathProgetto->text();
    std::string command = "xterm -hold -e 'PROMPT_COMMAND= echo -en \"\033]0;Esegui Windows 32 bit\a\"; wine " + path.toStdString() + "/release/windows/32bit/*.exe'; exit";
    system(command.c_str());

}

void MainWindow::on_pulsanteCompila_clicked()
{
    // Pulsante "Compila"
    QString path = ui->pathProgetto->text();
    std::string command = "xterm -hold -e 'PROMPT_COMMAND= echo -en \"\033]0;Compila\a\"; sh /opt/compileManager/compile.sh \"" + path.toStdString() + "\" 0'; exit";
    system(command.c_str());

}

void MainWindow::on_pulsanteCompilaEdEsegui_clicked()
{
    // Pulsante "Compila ed esegui"
    QString path = ui->pathProgetto->text();
    std::string command = "xterm -hold -e 'PROMPT_COMMAND= echo -en \"\033]0;Compila ed esegui\a\"; sh /opt/compileManager/compile.sh \"" + path.toStdString() + "\" 1'; exit";
    system(command.c_str());

}

void MainWindow::on_pulsanteCreaAppImage_clicked()
{
    // Pulsante "Crea AppImage"
    QString path = ui->pathProgetto->text();
    std::string command = "xterm -hold -e 'PROMPT_COMMAND= echo -en \"\033]0;Crea AppImage\a\"; sh /opt/compileManager/createAppImage.sh \"" + path.toStdString() + "\" 0'; exit";
    system(command.c_str());

}

void MainWindow::on_pulsanteAppImageEdEsegui_clicked()
{
    // Pulsante "Crea AppImage ed esegui"
    QString path = ui->pathProgetto->text();
    std::string command = "xterm -hold -e 'PROMPT_COMMAND= echo -en \"\033]0;Crea AppImage ed esegui\a\"; sh /opt/compileManager/createAppImage.sh \"" + path.toStdString() + "\" 1'; exit";
    system(command.c_str());
}

void MainWindow::on_pushButton_clicked()
{
    // Pulsante "Applica modifiche ⏎"
    QString path = ui->pathProgetto->text();
    if (path != "") {    // Se e' stato aperto un progetto

        /*
        **Struttura file infoPrj:**
        Nome progetto
        Autore progetto
        Descrizione progetto
        Tipo UI (gui/console)
        Disponibile per 32 bit (1 se lo e' oppure 0 se non lo e')
        Disponibile per linux (1 se lo e' oppure 0 se non lo e')
        Disponibile per windows (1 se lo e' oppure 0 se non lo e')
        */
        QString nomeProgetto = ui->inputNomeProgetto->text();
        QString autoreProgetto = ui->inputAutoreProgetto->text();
        QString descrizioneProgetto = ui->inputDescrizioneProgetto->text();
        QString tipoInterfaccia = ui->inputTipoInterfaccia->currentText();
        bool thereIs32Bit = ui->checkbox32Bit->isChecked();
        bool thereIsLinux = ui->checkboxLinux->isChecked();
        bool thereIsWindows = ui->checkboxWindows->isChecked();

        std::ofstream infoPrj(path.toStdString() + "/infoPrj");
        if (infoPrj.is_open()) {

            infoPrj << nomeProgetto.toStdString() << "\n";
            infoPrj << autoreProgetto.toStdString() << "\n";
            infoPrj << descrizioneProgetto.toStdString() << "\n";
            infoPrj << tipoInterfaccia.toStdString() << "\n";

            if (tipoInterfaccia == "gui") {

                ui->pulsanteCreaAppImage->setEnabled(true);
                ui->pulsanteAppImageEdEsegui->setEnabled(true);

            }else {

                ui->pulsanteCreaAppImage->setEnabled(false);
                ui->pulsanteAppImageEdEsegui->setEnabled(false);

            }

            if (thereIsLinux) {
                infoPrj << "1" << "\n";
                ui->pulsanteEseguiLinux32->setEnabled(true);
                ui->pulsanteEseguiLinux64->setEnabled(true);
            }else {
                infoPrj << "0" << "\n";
                ui->pulsanteEseguiLinux32->setEnabled(false);
                ui->pulsanteEseguiLinux64->setEnabled(false);
            }

            if (thereIsWindows) {
                infoPrj << "1" << "\n";
                ui->pulsanteEseguiWindows32->setEnabled(true);
                ui->pulsanteEseguiWindows64->setEnabled(true);
            }else {
                infoPrj << "0" << "\n";
                ui->pulsanteEseguiWindows32->setEnabled(false);
                ui->pulsanteEseguiWindows64->setEnabled(false);
            }

            if (thereIs32Bit) {
                infoPrj << "1" << "\n";
                ui->pulsanteEseguiWindows32->setEnabled(true);
                ui->pulsanteEseguiLinux32->setEnabled(true);
            }else {
                infoPrj << "0" << "\n";
                ui->pulsanteEseguiWindows32->setEnabled(false);
                ui->pulsanteEseguiLinux32->setEnabled(false);
            }

            infoPrj.close();

            QMessageBox::information(this, tr("Perfetto"), tr("Modifiche applicate con successo!"), QMessageBox::Ok);

        }else {
            QMessageBox::critical(this, tr("Errore"), tr("Impossibile applicare le modifiche!"), QMessageBox::Ok);
        }

    }
}

void MainWindow::on_actionChiudi_progetto_triggered()
{
    // Pulsante "Chiudi progetto"
    ui->inputNomeProgetto->setText("");
    ui->inputAutoreProgetto->setText("");
    ui->inputDescrizioneProgetto->setText("");
    ui->inputTipoInterfaccia->setCurrentText("console");
    ui->checkbox32Bit->setChecked(true);
    ui->checkboxLinux->setChecked(true);
    ui->checkboxWindows->setChecked(true);
    ui->pulsanteEseguiLinux32->setEnabled(true);
    ui->pulsanteEseguiLinux64->setEnabled(true);
    ui->pulsanteEseguiWindows32->setEnabled(true);
    ui->pulsanteEseguiWindows64->setEnabled(true);
    ui->pulsanteCreaAppImage->setEnabled(false);
    ui->pulsanteAppImageEdEsegui->setEnabled(false);
    ui->pushButton->setEnabled(false);
    ui->pathProgetto->setText("");
}

void MainWindow::on_actionCompila_file_triggered()
{
    // Pulsante "Compila file"
    QString username = qgetenv("USER");
    if (username.isEmpty()) username = qgetenv("USERNAME");
    QString fileName = QFileDialog::getOpenFileName(this,
        tr("Seleziona file"), "/home/" + username, tr("(*.cpp *.cc *.cxx *.c *.py *.kt)"));
    if (fileName != "") {   // Se ha selezionato un file

        std::string command = "xterm -hold -e \"sh /opt/compileManager/compile.sh " + fileName.toStdString() + " 0\"";
        system(command.c_str());

    }
}

void MainWindow::on_actionCos_triggered()
{
    // Pulsante "Cos'è?"
    QMessageBox::information(this, tr("Cos'è?"), tr("CompileManager è un programma che permette di facilitare la compilazione e l'esecuzione cross-platform del proprio codice sorgente nei linauggi: C, C++, Python e Kotlin senza l'utilizzo di un IDE specifico. Inoltre permette di creare un AppImage dei propri progetti QT così da facilitarne la distribuzione"), QMessageBox::Ok);
}

void MainWindow::on_actionCome_funziona_triggered()
{
    // Pulsante "Come funziona?"
    QMessageBox::information(this, tr("Come funziona?"), tr("Per aprire un progetto (o crearlo se non esiste) vai nel su File->Apri progetto, per fare le diverse azioni l'interfaccia è abbastanza intuitiva. Per compilare un singolo file vai su File->Compila file oppure File->Compila File ed esegui"), QMessageBox::Ok);
}

void MainWindow::on_actionCompial_ed_esegui_file_triggered()
{
    // Pulsante "Compila ed esegui file"
    QString fileName;
    if (pathPassata != "") {
        fileName = pathPassata;
        pathPassata = "";
    }else {

        QString username = qgetenv("USER");
        if (username.isEmpty()) username = qgetenv("USERNAME");
        QString fileName = QFileDialog::getOpenFileName(this,
            tr("Seleziona file"), "/home/" + username + "/", tr("(*.cpp *.cc *.cxx *.c *.py *.kt)"));

    }

    if (fileName == "") return;
    std::string command = "xterm -hold -e 'sh /opt/compileManager/compile.sh \"" + fileName.toStdString() + "\" 1'";
    system(command.c_str());
}

void MainWindow::showEvent(QShowEvent *ev)
{
    QMainWindow::showEvent(ev);
    showEventHelper();
}

void MainWindow::showEventHelper()
{
    if (QCoreApplication::arguments().count() > 1) {
        pathPassata = QCoreApplication::arguments().at(1);
        qDebug() << pathPassata;
        if (!pathPassata.isEmpty()) {

            if (QDir(pathPassata).exists()) {  // Se e' una cartella

                // Apro il progetto
                this->on_actionApri_progetto_triggered();

            }else { // Se e' un file

                // Lo compilo e lo eseguo
                this->on_actionCompial_ed_esegui_file_triggered();

            }

        }
    }
}
