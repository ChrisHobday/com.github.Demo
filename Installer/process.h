#ifndef PROCESS_H
#define PROCESS_H

#include <QObject>
#include <QtQml>
#include <QCursor>
#include <QGuiApplication>

class Process : public QObject
{
    Q_OBJECT
    QML_ELEMENT

public:
    explicit Process(QObject *parent = nullptr);
    Q_INVOKABLE void run(QString program, QStringList arguments); // Runs the given program with the given arguments
    QThread thread;

signals:
    void error(QString errorOutput); // Signifies an error while running process, which returns the error output
    void success(QString successOutput); // Signifies a successfully ran process, which returns the output
    void start(); // Signifies the start of a process
    void finish(); // Signifies the finish of a process
};

#endif // PROCESS_H
