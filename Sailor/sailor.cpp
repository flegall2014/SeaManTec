// Application:
#include "sailor.h"
#include "controller.h"

// Qt:
#include <QDebug>

// Farmers fridge singleton:
Sailor *Sailor::sSailor = 0;

// Constructor:
Sailor::Sailor(QObject *parent)
{
    Q_UNUSED(parent);
    m_pController = new Controller(this);
}

// Return kemanage singleton:
Sailor *Sailor::instance()
{
    if (!sSailor)
        sSailor = new Sailor();

    return sSailor;
}

// Startup:
bool Sailor::startup()
{
    qDebug() << "START APP";

    // Start controller:
    if (!m_pController->startup())
        return false;

    return true;
}

// Shutdown:
void Sailor::shutdown()
{
    qDebug() << "SHUT DOWN APP";

    // Shutdown controller:
    m_pController->shutdown();
}
