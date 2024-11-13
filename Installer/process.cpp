#include <process.h>
#include <QThread>
#include <QDebug>

Process::Process(QObject *parent)
    : QObject{parent}
{}

void Process::run(QString program, QStringList arguments)
{
    QThread *thread = QThread::create([this](QString program, QStringList arguments) -> void {
        QProcess *process = new QProcess(); // Create a process that will run the given program

        emit start(); // Emit that the process has started
        QGuiApplication::setOverrideCursor(Qt::WaitCursor); // Set the cursor to the wait cursor

        // process->setWorkingDirectory(""); // Set working directory where given program will be executed
        // process->setProgram(program);
        // process->setArguments(arguments);
        // process->startDetached();
        process->start(program, arguments); // Start the given program with the given arguments
        process->waitForFinished(); // Waits for the program to finish executing before returing control to GUI (this freezes the GUI)

        QString errorOutput = process->readAllStandardError(); // Stores error output from standard error if any
        QString successOutput = process->readAllStandardOutput(); // Stores success output from standard output if any

        emit error(errorOutput); // Emit the program error output
        emit success(successOutput); // Emit the program success output

        QGuiApplication::restoreOverrideCursor(); // Restore the cursor to previous cursor
        emit finish(); // Emit that the process has finished
    }, program, arguments);
    thread->start();
}

void Process::test(QString string)
{
    qDebug() << Q_FUNC_INFO << string;
}
