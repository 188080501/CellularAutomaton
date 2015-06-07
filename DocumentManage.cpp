#include "DocumentManage.h"

DocumentManage::DocumentManage(QObject *parent):
    QObject(parent)
{ }

QJsonObject DocumentManage::availablesDocument(void)
{
    QJsonObject buf;
    QJsonArray defaultDocument, userDocument;

    JasonQt_File::foreachFileFromDirectory( { ":/DefaultDocument/" }, [&](const auto &file)
    {
        defaultDocument.push_back(file.fileName());
    });

    JasonQt_File::foreachFileFromDirectory( { JasonQt_Settings::documentsPath("CellularAutomaton") + "Document/" }, [&](const auto &file)
    {
        userDocument.push_back(file.fileName());
    });

    buf["defaultDocument"] = defaultDocument;
    buf["userDocument"] = userDocument;

    return buf;
}

bool DocumentManage::saveDocument(const QJsonArray &document, const QString &name)
{
    return JasonQt_File::writeFile(JasonQt_Settings::documentsPath("CellularAutomaton") + "Document/" + name, QJsonDocument(document).toJson());
}

QJsonArray DocumentManage::readDocument(const QString &group, const QString &name)
{
    if(group == "userDocument")
    {
        const auto &&data = JasonQt_File::readFile(JasonQt_Settings::documentsPath("CellularAutomaton") + "Document/" + name);
        if(data.first)
        {
            return QJsonDocument::fromJson(data.second).array();
        }
    }
    else if(group == "defaultDocument")
    {
        const auto &&data = JasonQt_File::readFile(":/DefaultDocument/" + name);
        if(data.first)
        {
            return QJsonDocument::fromJson(data.second).array();
        }
    }

    return QJsonArray();
}

bool DocumentManage::deleteDocument(const QString &name)
{
    return QFile().remove(JasonQt_Settings::documentsPath("CellularAutomaton") + "Document/" + name);
}
