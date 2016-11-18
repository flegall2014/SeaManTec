#ifndef SAILORCLIENT_H
#define SAILORCLIENT_H

// Qt:
#include <QWebSocket>

// Application:
#include "sailorclient_global.h"

#define POSITION_CHANNEL "{\"channel\":\"PositionChannel\"}"
#define IDENTIFIER "identifier"
#define MESSAGE "message"
#define HEADING "heading"
#define LATITUDE "latitude"
#define LONGITUDE "longitude"

class SAILORCLIENTSHARED_EXPORT SailorClient : public QObject
{
    Q_OBJECT

public:
    enum MessageType {UNDEFINED=0, HEADING_TO, CURRENT_POSITION};

    // Constructor:
    explicit SailorClient(const QUrl &url, bool debug = false, QObject *parent = Q_NULLPTR);

    // Start:
    void start();

private:
    // Parse JSON:
    QVariant parseJson(const QString &sMessageData);

    // Message type:
    MessageType messageType(const QVariant &jsonData);

private:
    // Web socket:
    QWebSocket m_webSocket;

    // URL:
    QUrl m_url;

    // Debug mode:
    bool m_debug;

signals:
    // New heading available:
    void newHeadingAvailable(int iHeading);

    // New position available:
    void newPositionAvailable(double dLatitude, double dLongitude);

public slots:
    // Connection success:
    void onConnected();

    // Text message received:
    void onTextMessageReceived(const QString &messageData);

    // Disconnected:
    void onDisconnected();
};

#endif // SAILORCLIENT_H
