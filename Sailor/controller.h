#ifndef CONTROLLER_H
#define CONTROLLER_H

// Application:
#include "iservice.h"

// Qt:
#include <QObject>
#include <QVariantMap>
#include <QQmlApplicationEngine>
class SailorClient;

class Controller : public QObject, public IService
{
    Q_OBJECT
    Q_PROPERTY(int nextHeading READ nextHeading NOTIFY nextHeadingAvailable)
    Q_PROPERTY(QVariant nextPosition READ nextPosition NOTIFY nextPositionAvailable)

public:
    friend class Sailor;

    // Destructor:
    virtual ~Controller();

    // Startup:
    virtual bool startup();

    // Shutdown:
    virtual void shutdown();

protected:
    // Constructor:
    explicit Controller(QObject *parent = 0);

private:
    // Register types:
    void registerTypes();

    // Set context properties:
    void setContextProperties();

    // Start GUI:
    void startGUI();

    // Return next heading:
    int nextHeading() const;

    // Return next position:
    QVariant nextPosition() const;

private:
    // Sailor client:
    SailorClient *m_pSailorClient;

    // QML application engine:
    QQmlApplicationEngine m_Engine;

    // Next heading:
    int m_iNextHeading;

    // Next position:
    QVariant m_vNextPosition;

public slots:
    // Next heading available:
    void onNextHeadingAvailable(int iHeading);

    // Next position available:
    void onNextPositionAvailable(double dLongitude, double dLatitude);

signals:
    // New heading available:
    void nextHeadingAvailable();

    // New position available:
    void nextPositionAvailable();
};

#endif // CONTROLLER_H
