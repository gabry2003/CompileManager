#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QFileDialog>
#include <QFile>
#include <QTextStream>
#include <QMessageBox>
#include <QDebug>
#include <fstream>

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void on_actionEsci_triggered();

    void on_actionApri_progetto_triggered();

    void on_pulsanteEseguiLinux64_clicked();

    void on_pulsanteEseguiLinux32_clicked();

    void on_pulsanteEseguiWindows64_clicked();

    void on_pulsanteEseguiWindows32_clicked();

    void on_pulsanteCompila_clicked();

    void on_pulsanteCompilaEdEsegui_clicked();

    void on_pulsanteCreaAppImage_clicked();

    void on_pulsanteAppImageEdEsegui_clicked();

    void on_pushButton_clicked();

    void on_actionChiudi_progetto_triggered();

    void on_actionCompila_file_triggered();

    void on_actionCos_triggered();

    void on_actionCome_funziona_triggered();

    void on_actionCompial_ed_esegui_file_triggered();

private:
    Ui::MainWindow *ui;
};

#endif // MAINWINDOW_H
