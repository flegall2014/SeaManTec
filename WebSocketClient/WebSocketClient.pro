#-------------------------------------------------
#
# Project created by QtCreator 2016-11-16T12:58:13
#
#-------------------------------------------------

QT       -= gui

TARGET = WebSocketClient
TEMPLATE = lib
CONFIG += c++11

DEFINES += WEBSOCKETCLIENT_LIBRARY

SOURCES += websocketclient.cpp

HEADERS += websocketclient.h\
        websocketclient_global.h

unix {
    target.path = /usr/lib
    INSTALLS += target
}
