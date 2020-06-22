/********************************************************************************
** Form generated from reading UI file 'mainwindow.ui'
**
** Created by: Qt User Interface Compiler version 5.14.2
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_MAINWINDOW_H
#define UI_MAINWINDOW_H

#include <QtCore/QVariant>
#include <QtGui/QIcon>
#include <QtWidgets/QAction>
#include <QtWidgets/QApplication>
#include <QtWidgets/QCheckBox>
#include <QtWidgets/QComboBox>
#include <QtWidgets/QLabel>
#include <QtWidgets/QLineEdit>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QMenu>
#include <QtWidgets/QMenuBar>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_MainWindow
{
public:
    QAction *actionEsci;
    QAction *actionApri_progetto;
    QAction *actionChiudi_progetto;
    QAction *actionCompila_file;
    QAction *actionCos;
    QAction *actionCome_funziona;
    QAction *actionCompial_ed_esegui_file;
    QWidget *centralwidget;
    QLabel *labelProgettoAperto;
    QLabel *labelAutore;
    QLabel *labelDescrizione;
    QLabel *labelInterfaccia;
    QLineEdit *inputNomeProgetto;
    QLineEdit *inputAutoreProgetto;
    QLineEdit *inputDescrizioneProgetto;
    QCheckBox *checkbox32Bit;
    QCheckBox *checkboxWindows;
    QCheckBox *checkboxLinux;
    QPushButton *pulsanteEseguiLinux64;
    QPushButton *pulsanteEseguiLinux32;
    QPushButton *pulsanteEseguiWindows64;
    QPushButton *pulsanteEseguiWindows32;
    QPushButton *pulsanteCompila;
    QPushButton *pulsanteCompilaEdEsegui;
    QPushButton *pulsanteCreaAppImage;
    QPushButton *pulsanteAppImageEdEsegui;
    QPushButton *pushButton;
    QComboBox *inputTipoInterfaccia;
    QLabel *pathProgetto;
    QMenuBar *menubar;
    QMenu *menuFile;
    QMenu *menuHelp;

    void setupUi(QMainWindow *MainWindow)
    {
        if (MainWindow->objectName().isEmpty())
            MainWindow->setObjectName(QString::fromUtf8("MainWindow"));
        MainWindow->setWindowModality(Qt::ApplicationModal);
        MainWindow->resize(800, 315);
        MainWindow->setMinimumSize(QSize(800, 315));
        MainWindow->setMaximumSize(QSize(800, 315));
        QIcon icon;
        icon.addFile(QString::fromUtf8("../icon.png"), QSize(), QIcon::Normal, QIcon::Off);
        MainWindow->setWindowIcon(icon);
        actionEsci = new QAction(MainWindow);
        actionEsci->setObjectName(QString::fromUtf8("actionEsci"));
        actionApri_progetto = new QAction(MainWindow);
        actionApri_progetto->setObjectName(QString::fromUtf8("actionApri_progetto"));
        actionChiudi_progetto = new QAction(MainWindow);
        actionChiudi_progetto->setObjectName(QString::fromUtf8("actionChiudi_progetto"));
        actionCompila_file = new QAction(MainWindow);
        actionCompila_file->setObjectName(QString::fromUtf8("actionCompila_file"));
        actionCos = new QAction(MainWindow);
        actionCos->setObjectName(QString::fromUtf8("actionCos"));
        actionCome_funziona = new QAction(MainWindow);
        actionCome_funziona->setObjectName(QString::fromUtf8("actionCome_funziona"));
        actionCompial_ed_esegui_file = new QAction(MainWindow);
        actionCompial_ed_esegui_file->setObjectName(QString::fromUtf8("actionCompial_ed_esegui_file"));
        centralwidget = new QWidget(MainWindow);
        centralwidget->setObjectName(QString::fromUtf8("centralwidget"));
        labelProgettoAperto = new QLabel(centralwidget);
        labelProgettoAperto->setObjectName(QString::fromUtf8("labelProgettoAperto"));
        labelProgettoAperto->setGeometry(QRect(20, 20, 121, 19));
        labelAutore = new QLabel(centralwidget);
        labelAutore->setObjectName(QString::fromUtf8("labelAutore"));
        labelAutore->setGeometry(QRect(20, 60, 121, 19));
        labelDescrizione = new QLabel(centralwidget);
        labelDescrizione->setObjectName(QString::fromUtf8("labelDescrizione"));
        labelDescrizione->setGeometry(QRect(20, 100, 151, 19));
        labelInterfaccia = new QLabel(centralwidget);
        labelInterfaccia->setObjectName(QString::fromUtf8("labelInterfaccia"));
        labelInterfaccia->setGeometry(QRect(20, 140, 151, 19));
        inputNomeProgetto = new QLineEdit(centralwidget);
        inputNomeProgetto->setObjectName(QString::fromUtf8("inputNomeProgetto"));
        inputNomeProgetto->setGeometry(QRect(180, 20, 201, 27));
        inputAutoreProgetto = new QLineEdit(centralwidget);
        inputAutoreProgetto->setObjectName(QString::fromUtf8("inputAutoreProgetto"));
        inputAutoreProgetto->setGeometry(QRect(180, 60, 201, 27));
        inputDescrizioneProgetto = new QLineEdit(centralwidget);
        inputDescrizioneProgetto->setObjectName(QString::fromUtf8("inputDescrizioneProgetto"));
        inputDescrizioneProgetto->setGeometry(QRect(180, 100, 201, 27));
        checkbox32Bit = new QCheckBox(centralwidget);
        checkbox32Bit->setObjectName(QString::fromUtf8("checkbox32Bit"));
        checkbox32Bit->setGeometry(QRect(440, 20, 201, 25));
        checkbox32Bit->setChecked(true);
        checkboxWindows = new QCheckBox(centralwidget);
        checkboxWindows->setObjectName(QString::fromUtf8("checkboxWindows"));
        checkboxWindows->setGeometry(QRect(440, 60, 201, 25));
        checkboxWindows->setChecked(true);
        checkboxLinux = new QCheckBox(centralwidget);
        checkboxLinux->setObjectName(QString::fromUtf8("checkboxLinux"));
        checkboxLinux->setGeometry(QRect(440, 100, 201, 25));
        checkboxLinux->setChecked(true);
        pulsanteEseguiLinux64 = new QPushButton(centralwidget);
        pulsanteEseguiLinux64->setObjectName(QString::fromUtf8("pulsanteEseguiLinux64"));
        pulsanteEseguiLinux64->setGeometry(QRect(20, 200, 161, 27));
        pulsanteEseguiLinux32 = new QPushButton(centralwidget);
        pulsanteEseguiLinux32->setObjectName(QString::fromUtf8("pulsanteEseguiLinux32"));
        pulsanteEseguiLinux32->setGeometry(QRect(200, 200, 161, 27));
        pulsanteEseguiWindows64 = new QPushButton(centralwidget);
        pulsanteEseguiWindows64->setObjectName(QString::fromUtf8("pulsanteEseguiWindows64"));
        pulsanteEseguiWindows64->setGeometry(QRect(380, 200, 191, 27));
        pulsanteEseguiWindows32 = new QPushButton(centralwidget);
        pulsanteEseguiWindows32->setObjectName(QString::fromUtf8("pulsanteEseguiWindows32"));
        pulsanteEseguiWindows32->setGeometry(QRect(590, 200, 191, 27));
        pulsanteCompila = new QPushButton(centralwidget);
        pulsanteCompila->setObjectName(QString::fromUtf8("pulsanteCompila"));
        pulsanteCompila->setGeometry(QRect(50, 240, 91, 27));
        pulsanteCompilaEdEsegui = new QPushButton(centralwidget);
        pulsanteCompilaEdEsegui->setObjectName(QString::fromUtf8("pulsanteCompilaEdEsegui"));
        pulsanteCompilaEdEsegui->setGeometry(QRect(200, 240, 161, 27));
        pulsanteCreaAppImage = new QPushButton(centralwidget);
        pulsanteCreaAppImage->setObjectName(QString::fromUtf8("pulsanteCreaAppImage"));
        pulsanteCreaAppImage->setEnabled(false);
        pulsanteCreaAppImage->setGeometry(QRect(410, 240, 121, 27));
        pulsanteCreaAppImage->setFlat(false);
        pulsanteAppImageEdEsegui = new QPushButton(centralwidget);
        pulsanteAppImageEdEsegui->setObjectName(QString::fromUtf8("pulsanteAppImageEdEsegui"));
        pulsanteAppImageEdEsegui->setEnabled(false);
        pulsanteAppImageEdEsegui->setGeometry(QRect(590, 240, 191, 27));
        pushButton = new QPushButton(centralwidget);
        pushButton->setObjectName(QString::fromUtf8("pushButton"));
        pushButton->setEnabled(false);
        pushButton->setGeometry(QRect(440, 140, 161, 27));
        inputTipoInterfaccia = new QComboBox(centralwidget);
        inputTipoInterfaccia->addItem(QString());
        inputTipoInterfaccia->addItem(QString());
        inputTipoInterfaccia->setObjectName(QString::fromUtf8("inputTipoInterfaccia"));
        inputTipoInterfaccia->setGeometry(QRect(180, 140, 201, 27));
        pathProgetto = new QLabel(centralwidget);
        pathProgetto->setObjectName(QString::fromUtf8("pathProgetto"));
        pathProgetto->setGeometry(QRect(660, 10, 0, 0));
        MainWindow->setCentralWidget(centralwidget);
        menubar = new QMenuBar(MainWindow);
        menubar->setObjectName(QString::fromUtf8("menubar"));
        menubar->setGeometry(QRect(0, 0, 800, 24));
        menuFile = new QMenu(menubar);
        menuFile->setObjectName(QString::fromUtf8("menuFile"));
        menuHelp = new QMenu(menubar);
        menuHelp->setObjectName(QString::fromUtf8("menuHelp"));
        MainWindow->setMenuBar(menubar);

        menubar->addAction(menuFile->menuAction());
        menubar->addAction(menuHelp->menuAction());
        menuFile->addAction(actionApri_progetto);
        menuFile->addAction(actionChiudi_progetto);
        menuFile->addAction(actionCompila_file);
        menuFile->addAction(actionCompial_ed_esegui_file);
        menuFile->addAction(actionEsci);
        menuHelp->addAction(actionCos);
        menuHelp->addAction(actionCome_funziona);

        retranslateUi(MainWindow);

        pulsanteCreaAppImage->setDefault(false);


        QMetaObject::connectSlotsByName(MainWindow);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindow)
    {
        MainWindow->setWindowTitle(QCoreApplication::translate("MainWindow", "CompileManager", nullptr));
        actionEsci->setText(QCoreApplication::translate("MainWindow", "Esci", nullptr));
        actionApri_progetto->setText(QCoreApplication::translate("MainWindow", "Apri progetto", nullptr));
        actionChiudi_progetto->setText(QCoreApplication::translate("MainWindow", "Chiudi progetto", nullptr));
        actionCompila_file->setText(QCoreApplication::translate("MainWindow", "Compila file", nullptr));
        actionCos->setText(QCoreApplication::translate("MainWindow", "Cos'\303\250?", nullptr));
        actionCome_funziona->setText(QCoreApplication::translate("MainWindow", "Come funziona?", nullptr));
        actionCompial_ed_esegui_file->setText(QCoreApplication::translate("MainWindow", "Compila ed esegui file", nullptr));
#if QT_CONFIG(tooltip)
        labelProgettoAperto->setToolTip(QCoreApplication::translate("MainWindow", "Nome del progetto aperto", nullptr));
#endif // QT_CONFIG(tooltip)
        labelProgettoAperto->setText(QCoreApplication::translate("MainWindow", "Progetto aperto:", nullptr));
#if QT_CONFIG(tooltip)
        labelAutore->setToolTip(QCoreApplication::translate("MainWindow", "Autore del progetto aperto", nullptr));
#endif // QT_CONFIG(tooltip)
        labelAutore->setText(QCoreApplication::translate("MainWindow", "Autore progetto:", nullptr));
#if QT_CONFIG(tooltip)
        labelDescrizione->setToolTip(QCoreApplication::translate("MainWindow", "Descrizione del progetto aperto", nullptr));
#endif // QT_CONFIG(tooltip)
        labelDescrizione->setText(QCoreApplication::translate("MainWindow", "Descrizione progetto:", nullptr));
#if QT_CONFIG(tooltip)
        labelInterfaccia->setToolTip(QCoreApplication::translate("MainWindow", "Tipo di interfaccia del progetto aperto (console o ad interfaccia grafica)", nullptr));
#endif // QT_CONFIG(tooltip)
        labelInterfaccia->setText(QCoreApplication::translate("MainWindow", "Tipo interfaccia:", nullptr));
        checkbox32Bit->setText(QCoreApplication::translate("MainWindow", "Disponibile per 32 bit", nullptr));
        checkboxWindows->setText(QCoreApplication::translate("MainWindow", "Disponibile per Windows", nullptr));
        checkboxLinux->setText(QCoreApplication::translate("MainWindow", "Disponibile per Linux", nullptr));
        pulsanteEseguiLinux64->setText(QCoreApplication::translate("MainWindow", "Esegui Linux a 64 bit", nullptr));
        pulsanteEseguiLinux32->setText(QCoreApplication::translate("MainWindow", "Esegui Linux a 32 bit", nullptr));
        pulsanteEseguiWindows64->setText(QCoreApplication::translate("MainWindow", "Esegui Windows a 64 bit", nullptr));
        pulsanteEseguiWindows32->setText(QCoreApplication::translate("MainWindow", "Esegui Windows a 32 bit", nullptr));
        pulsanteCompila->setText(QCoreApplication::translate("MainWindow", "Compila", nullptr));
        pulsanteCompilaEdEsegui->setText(QCoreApplication::translate("MainWindow", "Compila ed esegui", nullptr));
        pulsanteCreaAppImage->setText(QCoreApplication::translate("MainWindow", "Crea AppImage", nullptr));
        pulsanteAppImageEdEsegui->setText(QCoreApplication::translate("MainWindow", "Crea AppImage ed esegui", nullptr));
        pushButton->setText(QCoreApplication::translate("MainWindow", "Applica modifiche \342\217\216", nullptr));
        inputTipoInterfaccia->setItemText(0, QCoreApplication::translate("MainWindow", "console", nullptr));
        inputTipoInterfaccia->setItemText(1, QCoreApplication::translate("MainWindow", "gui", nullptr));

        pathProgetto->setText(QString());
        menuFile->setTitle(QCoreApplication::translate("MainWindow", "File", nullptr));
        menuHelp->setTitle(QCoreApplication::translate("MainWindow", "Help", nullptr));
    } // retranslateUi

};

namespace Ui {
    class MainWindow: public Ui_MainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MAINWINDOW_H
