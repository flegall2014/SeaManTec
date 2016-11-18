// Qt:
#include <QtCore/QDebug>
#include <QJsonDocument>

// Application:
#include "sailorclient.h"
#include <utils.h>

// Constructor:
SailorClient::SailorClient(const QUrl &url, bool debug, QObject *parent) :
    QObject(parent),
    m_url(url),
    m_debug(debug)
{
    if (m_debug)
        qDebug() << "WebSocket server:" << url;
    connect(&m_webSocket, &QWebSocket::connected, this, &SailorClient::onConnected);
    connect(&m_webSocket, &QWebSocket::disconnected, this, &SailorClient::disconnected);
    connect(&m_webSocket, static_cast<void(QWebSocket::*)(QAbstractSocket::SocketError)>(&QWebSocket::error),
            [=](QAbstractSocket::SocketError error){ qDebug() << "ERROR " << error; });
    m_webSocket.open(QUrl(url));
}

// Connected:
void SailorClient::onConnected()
{
    if (m_debug)
        qDebug() << "WebSocket connected";
    connect(&m_webSocket, &QWebSocket::textMessageReceived,
            this, &SailorClient::onTextMessageReceived);
    start();
}

// Text message received:
void SailorClient::onTextMessageReceived(const QString &sMessageData)
{
    if (!sMessageData.isEmpty())
    {
        // Load JSON data:
        QVariant jsonData = parseJson(sMessageData);
        MessageType msgType = messageType(jsonData);

        // Return heading:
        if (msgType == HEADING_TO)
        {
            QVariantMap mMessageData = jsonData.toMap();
            QVariantMap sMessageContents =
                    mMessageData[MESSAGE].toMap();
            double dHeading = sMessageContents[HEADING].toDouble();
            emit newHeadingAvailable(dHeading);
        }

        // Return lon/lat:
        if (msgType == CURRENT_POSITION)
        {
            QVariantMap mMessageData = jsonData.toMap();
            QVariantMap sMessageContents =
                    mMessageData[MESSAGE].toMap();
            double dLongitude = sMessageContents[LONGITUDE].toDouble();
            double dLatitude = sMessageContents[LATITUDE].toDouble();
            emit newPositionAvailable(dLongitude, dLatitude);
        }
    }
}

// Start:
void SailorClient::start()
{
    QString sJsonData = Utils::loadTextFile(":/subscribe.json");
    m_webSocket.sendTextMessage(sJsonData);
}

// Parse JSON:
QVariant SailorClient::parseJson(const QString &sMessageData)
{
    QJsonParseError error;
    QJsonDocument message =
            QJsonDocument::fromJson(sMessageData.toUtf8(), &error);
    if (error.error)
        return QVariant();
    else if (!message.isObject())
        return QVariant();
    return message.toVariant();
}

// Message type:
SailorClient::MessageType SailorClient::messageType(const QVariant &jsonData)
{
    if (jsonData.type() == QVariant::Map)
    {
        QVariantMap mMessageData = jsonData.toMap();
        if (mMessageData.contains(IDENTIFIER))
        {
            QString sIdentifier = mMessageData[IDENTIFIER].toString();
            if (sIdentifier == POSITION_CHANNEL)
            {
                if (mMessageData.contains(MESSAGE))
                {
                    QVariantMap mMessageContents =
                            mMessageData[MESSAGE].toMap();
                    if (mMessageContents.contains(HEADING))
                        return HEADING_TO;
                    if (mMessageContents.contains(LONGITUDE) &&
                            mMessageContents.contains(LATITUDE))
                        return CURRENT_POSITION;
                }
                else return UNDEFINED;
            }
            else return UNDEFINED;
        }
        else return UNDEFINED;
    }
    return UNDEFINED;
}
