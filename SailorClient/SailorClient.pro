#-------------------------------------------------
#
# Project created by QtCreator 2016-11-02T16:29:57
#
#-------------------------------------------------

QT       += core websockets script xml

TEMPLATE = lib
DEFINES += SAILORCLIENT_LIBRARY
INCLUDEPATH += $$PWD/../utils

unix {
    DESTDIR = ../bin
    MOC_DIR = ../moc
    OBJECTS_DIR = ../obj
}

win32 {
    DESTDIR = ..\\bin
    MOC_DIR = ..\\moc
    OBJECTS_DIR = ..\\obj
}

QMAKE_CLEAN *= $$DESTDIR\\*$$TARGET*
QMAKE_CLEAN *= $$MOC_DIR\\*$$TARGET*
QMAKE_CLEAN *= $$OBJECTS_DIR\\*$$TARGET*

CONFIG(debug, debug|release) {
    LIBS += -L$$PWD/../bin/ -lutilsd
    TARGET = sailorclientd
} else {
    LIBS += -L$$PWD/../bin/ -lutils
    TARGET = sailorclient
}

HEADERS += \
    sailorclient.h \
    sailorclient_global.h

SOURCES += \
    sailorclient.cpp

DISTFILES +=

RESOURCES += \
    resources.qrc




