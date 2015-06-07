#ifndef DOCUMENTMANAGE_H
#define DOCUMENTMANAGE_H

// Qt lib import
#include <QObject>

// JasonQt lib import
#include "JasonQt/JasonQt_Foundation.h"
#include "JasonQt/JasonQt_Settings.h"
#include "JasonQt/JasonQt_File.h"

class DocumentManage: public QObject
{
    Q_OBJECT

public:
    explicit DocumentManage(QObject *parent = NULL);

public slots:
    QJsonObject availablesDocument(void);

    bool saveDocument(const QJsonArray &document, const QString &name);

    QJsonArray readDocument(const QString &group, const QString &name);

    bool deleteDocument(const QString &name);
};

#endif // DOCUMENTMANAGE_H
