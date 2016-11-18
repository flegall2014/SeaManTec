// Qt:
#include <QQmlContext>

// Application:
#include "controller.h"
#include "sailorclient.h"

#define SERVER_URL "ws://seamantec-assessment.herokuapp.com/websocket"

// Constructor:
Controller::Controller(QObject *parent) : QObject(parent),
    m_pSailorClient(NULL), m_iNextHeading(0)
{
    // Client:
    m_pSailorClient = new SailorClient(QUrl(SERVER_URL), true, this);
    connect(m_pSailorClient, &SailorClient::newHeadingAvailable, this, &Controller::onNextHeadingAvailable);
    connect(m_pSailorClient, &SailorClient::newPositionAvailable, this, &Controller::onNextPositionAvailable);
}

// Destructor:
Controller::~Controller()
{
}

// Startup:
bool Controller::startup()
{
    // Register types:
    registerTypes();

    // Set context properties:
    setContextProperties();

    // Start GUI:
    startGUI();

    // Start Sailor client:
    m_pSailorClient->start();

    return true;
}

// Shutdown:
void Controller::shutdown()
{
}

// Register types:
void Controller::registerTypes()
{

}

// Set context properties:
void Controller::setContextProperties()
{
    m_Engine.rootContext()->setContextProperty("_controller", this);
}

// Start GUI:
void Controller::startGUI()
{
    // Load:
    m_Engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
}

// Return next heading:
int Controller::nextHeading() const
{
    return m_iNextHeading;
}

// Return next position:
QVariant Controller::nextPosition() const
{
    return m_vNextPosition;
}

// Next heading available:
void Controller::onNextHeadingAvailable(int iHeading)
{
    m_iNextHeading = iHeading;
    emit nextHeadingAvailable();
}

// Next position available:
void Controller::onNextPositionAvailable(double dLongitude, double dLatitude)
{
    QVariantMap nextPosition;
    nextPosition[LONGITUDE] = dLongitude;
    nextPosition[LATITUDE] = dLatitude;
    m_vNextPosition = nextPosition;
    emit nextPositionAvailable();
}
