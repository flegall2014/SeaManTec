#ifndef UTILS_H
#define UTILS_H

// Application:
#include "utils_global.h"

class UTILSSHARED_EXPORT Utils
{
public:
    // Load text file:
    static QString loadTextFile(const QString &sFilePath);
};

#endif // UTILS_H
