// Qt:
#include <QApplication>
#include <sailorclient.h>

// Application:
#include "sailor.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    // Launch application:
    Sailor *pSailor = Sailor::instance();
    if (!pSailor)
        return 0;

     // Start application:
    if (pSailor->startup())
        // Run:
        app.exec();

    // Shutdown:
    pSailor->shutdown();

    // Delete application:
    delete pSailor;

    return 1;
}
