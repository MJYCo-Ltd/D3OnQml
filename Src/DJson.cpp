#include <QFile>
#include "DJson.h"
QDJson::QDJson()
{
}

bool QDJson::writeJsonFile(const QJsonObject &object)
{
    QFile file(m_source);
    bool ok = file.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Truncate);
    if(ok == false) //不存在
    {
        return false;
    }
    QJsonDocument jsonDocument;
    jsonDocument.setObject(object);
    QByteArray byteArray = jsonDocument.toJson(QJsonDocument::Indented);
    QTextStream out(&file);
    out << byteArray;
    if(file.isOpen())
    {
        file.close();
    }
    return true;
}

QJsonObject QDJson::readJsonFile()
{
    QFile file(m_source);
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        return QJsonObject();
    }
    QByteArray allData = file.readAll();
    if(allData.isEmpty())
        return QJsonObject();
    QJsonParseError json_error;
    QJsonDocument jsonDoc(QJsonDocument::fromJson(allData, &json_error));
    if(json_error.error != QJsonParseError::NoError)
    {
        return QJsonObject();
    }
    QJsonObject rootObj = jsonDoc.object();
    if(file.isOpen())
    {
        file.close();
    }
    return rootObj;
}

void QDJson::clearJsonObject(QJsonObject &object)
{
    QStringList strList = object.keys();
    for(int i = 0; i < strList.size(); ++i)
    {
        object.remove(strList.at(i));
    }
}
