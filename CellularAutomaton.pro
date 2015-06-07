TEMPLATE = app

QT += qml quick widgets

include(./MaterialUI/MaterialUI.pri)

CONFIG += c++11
CONFIG += c++14

SOURCES += main.cpp \
    JasonQt/JasonQt_Foundation.cpp \
    JasonQt/JasonQt_Net.cpp \
    JasonQt/JasonQt_QML.cpp \
    DocumentManage.cpp \
    JasonQt/JasonQt_Settings.cpp \
    JasonQt/JasonQt_File.cpp

RESOURCES += ./qml/qml.qrc \
    Resources/Document/Document.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    JasonQt/JasonQt_Foundation.h \
    JasonQt/JasonQt_Net.h \
    JasonQt/JasonQt_QML.h \
    DocumentManage.h \
    JasonQt/JasonQt_Settings.h \
    JasonQt/JasonQt_File.h

mac{
    ICON = ./Resources/Icon/Icon.icns
}

win32{
    RC_FILE = ./Resources/Icon/Icon.rc
}
