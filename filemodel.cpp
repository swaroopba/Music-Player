#include "filemodel.h"

FileModel::FileModel(QObject *parent)
{

}

void FileModel::setModelData(QStringList fileNames)
{
    int i = 0;
    qDebug("Called from setModelData");
    beginResetModel();
    foreach(QString file, fileNames)
    {   qDebug("Adding new file");
        m_fileNames.push_back(QPair<int, QString>(i, file));
        i++;
    }
    endResetModel();
}

QStringList FileModel::getModelData()
{
    QStringList ret;
    QPair<int, QString> item;
    qDebug("Called from getModelData");

    foreach(item, m_fileNames)
    {
        qDebug("Item..");
        ret.push_back(item.second);
    }

    return ret;
}

void FileModel::setDirectory(QString directory)
{
    m_directory = directory;
}

QString FileModel::getDirectory()
{
    return m_directory;
}

int FileModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_fileNames.size();
}

QHash<int, QByteArray> FileModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[0] = "songName";
    roles[1] = "songIndex";
    return roles;
}

int FileModel::getSongIndex(const QString& songName)
{
    QPair<int, QString> item;
    foreach(item, m_fileNames)
    {
        if(item.second == songName) return item.first;
    }
    return 0;
}

QString FileModel::getSongName(int index)
{
    return m_fileNames.at(index).second;
}

int FileModel::getTotalSongsCount()
{
    return m_fileNames.size();
}

QVariant FileModel::data(const QModelIndex &index, int role) const
{
    QVariant val;

    switch(role)
    {
        case 0:
                        val = QVariant::fromValue(m_fileNames.at(index.row()).second);
        break;

        case 1:
                        val = QVariant::fromValue(m_fileNames.at(index.row()).first);
        break;
    }
    return val;
}


