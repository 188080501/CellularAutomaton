// Qt lib import
#include <QApplication>
#include <QQmlApplicationEngine>

// JasonQt lib import
#include "JasonQt/JasonQt_QML.h"

// CellularAutomaton lib import
#include "DocumentManage.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    JasonQt_QML::Tool jasonQtTool;
    DocumentManage documentManage;

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("JasonQtTool", &jasonQtTool);
    engine.rootContext()->setContextProperty("DocumentManage", &documentManage);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
