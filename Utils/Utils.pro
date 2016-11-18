#-------------------------------------------------
#
# Project created by QtCreator 2016-11-02T16:29:57
#
#-------------------------------------------------

QT       += core websockets xml

TEMPLATE = lib
DEFINES += UTILS_LIBRARY

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
    TARGET = utilsd
} else {
    TARGET = utils
}

DISTFILES += \
    subscribe.json

HEADERS += \
    utils.h \
    utils_global.h

SOURCES += \
    utils.cpp




