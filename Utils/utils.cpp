// Qt:
#include <QFile>
#include <QTextStream>

// Application:
#include "utils.h"

// Load text file:
QString Utils::loadTextFile(const QString &sFilePath)
{
    QString sContents = "";
    QFile f(sFilePath);
    if (f.open(QFile::ReadOnly | QFile::Text))
    {
        QTextStream in(&f);
        sContents = in.readAll();
        f.close();
    }
    return sContents.simplified();
}
