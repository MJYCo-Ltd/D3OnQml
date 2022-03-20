#ifndef DJSON_H
#define DJSON_H
#include <QObject>
#include <QJsonDocument>
#include <QString>
#include <QVariant>
#include <QJsonObject>
class QDJson : public QObject
{
    Q_OBJECT
public:
    QDJson();
    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged)
    Q_INVOKABLE bool writeJsonFile(const QJsonObject &object);
    Q_INVOKABLE QJsonObject readJsonFile();
    QString source() {return m_source;}
    void setSource(const QString &path)
    {
        if(m_source != path)
        {
            m_source  = path;
            emit sourceChanged(path);
        }
    }
    static void clearJsonObject(QJsonObject &object);
signals:
   void sourceChanged(const QString &path);
private:
    QString m_source;
};
#endif // DJSON_H
