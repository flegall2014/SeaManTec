#-------------------------------------------------
#
# Project created by QtCreator 2016-10-23T09:16:18
#
#-------------------------------------------------

QT       += core gui xml widgets websockets qml quick

TEMPLATE = app

INCLUDEPATH += $$PWD/../utils ../SailorClient

CONFIG(debug, debug|release) {
    LIBS += -L$$PWD/../bin/ -lsailorclientd
    TARGET = sailord
} else {
    LIBS += -L$$PWD/../bin/ -lsailorclient
    TARGET = sailor
}

unix {
    DESTDIR = ../bin
    MOC_DIR = ./moc
    OBJECTS_DIR = ./obj
}

win32 {
    DESTDIR = ..\\bin
    MOC_DIR = .\\moc
    OBJECTS_DIR = .\\obj
}

unix {
    QMAKE_CLEAN *= $$DESTDIR/*$$TARGET*
    QMAKE_CLEAN *= $$MOC_DIR/*moc_*
    QMAKE_CLEAN *= $$OBJECTS_DIR/*.o*
}

win32 {
    QMAKE_CLEAN *= $$DESTDIR\\*$$TARGET*
    QMAKE_CLEAN *= $$MOC_DIR\\*moc_*
    QMAKE_CLEAN *= $$OBJECTS_DIR\\*.o*
}

FORMS +=

HEADERS += \
    sailor.h \
    iservice.h \
    controller.h

SOURCES += \
    main.cpp \
    sailor.cpp \
    controller.cpp

DISTFILES += \
    qml/application.json

RESOURCES += \
    resources.qrc
