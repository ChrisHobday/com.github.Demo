#ifndef PROCESS_H
#define PROCESS_H

#include <QObject>
#include <QtQml>

class Process : public QObject
{
    Q_OBJECT
    QML_ELEMENT

public:
    explicit Process(QObject *parent = nullptr);
    Q_INVOKABLE void run(QString program, QStringList arguments); // Runs the given program with the given arguments

signals:
    void error(QString errorOutput); // Signifies an error while running process, which returns the error output
    void success(QString successOutput); // Signifies a successfully ran process, which returns the output
};

#endif // PROCESS_H
