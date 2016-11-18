#ifndef SAILOR_H
#define SAILOR_H

// Application:
#include "iservice.h"

// Qt:
#include <QObject>

class Controller;

// Main application:
class Sailor : public QObject, public IService
{
    Q_OBJECT

public:
    // Return an instance of Sailor:
    static Sailor *instance();

    // Startup:
    virtual bool startup();

    // Shutdown:
    virtual void shutdown();

    // Destructor:
    virtual ~Sailor() {

    }

private:
    // Constructor:
    Sailor(QObject *parent=0);

private:
    // Sailor singleton:
    static Sailor *sSailor;

    // Controller singleton:
    Controller *m_pController;
};

#endif // SAILOR_H
