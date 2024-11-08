#include <process.h>

Process::Process(QObject *parent)
    : QObject{parent}
{}

void Process::run(QString program, QStringList arguments)
{
    QProcess *process = new QProcess(); // Create a process that will run the given program

    // process->setWorkingDirectory(""); // Set working directory where given program will be executed
    // TODO: Find a way to run the given program async as to not block the GUI, possibly using QProcess->startDetached or not using QProcess->waitForFinished
    process->start(program, arguments); // Start the given program with the given arguments
    process->waitForFinished();

    QString errorOutput = process->readAllStandardError(); // Stores error output from standard error if any
    QString successOutput = process->readAllStandardOutput(); // Stores success output from standard output if any

    emit error(errorOutput); // Emit the program error output
    emit success(successOutput); // Emit the program success output
}

