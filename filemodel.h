#ifndef FILEMODEL_H
#define FILEMODEL_H

#include <QObject>
#include <QAbstractListModel>

class FileModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit FileModel(QObject *parent = nullptr);

    void setModelData(QStringList fileNames);

    Q_INVOKABLE QStringList getModelData();

    void setDirectory(QString directory);

    QString getDirectory();

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE int getSongIndex(const QString& songName);

    Q_INVOKABLE QString getSongName(int index);

    Q_INVOKABLE int getTotalSongsCount();

signals:


private:
    QList<QPair<int, QString>> m_fileNames;
    QString m_directory;
};

#endif // FILEMODEL_H
