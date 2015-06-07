#include "JasonQt_File.h"

using namespace JasonQt_File;

void JasonQt_File::foreachFileFromDirectory(const QFileInfo &directory, const std::function<void(const QFileInfo &)> &each, const bool &recursion)
{
    const auto &&Files = QDir(directory.filePath()).entryInfoList();

    for(const auto &now: Files)
    {
        if((now.fileName().indexOf(".") == 0) || (now.fileName().indexOf("~") == 0))
        {
            continue;
        }
        if(now.isFile())
        {
            each(now);
        }
    }

    if(recursion)
    {
        for(const auto &now: Files)
        {
            if((now.fileName().indexOf(".") == 0) || (now.fileName().indexOf("~") == 0))
            {
                continue;
            }
            if(now.isDir())
            {
                foreachFileFromDirectory(now.filePath(), each, recursion);
            }
        }
    }
}

bool JasonQt_File::writeFile(const QFileInfo &targetFilePath, const QByteArray &data, const bool &cover)
{
    if(!targetFilePath.dir().isReadable())
    {
        if(!QDir().mkpath(targetFilePath.path()))
        {
            return false;
        }
    }

    if(targetFilePath.isFile() && !cover)
    {
        return true;
    }

    QFile file(targetFilePath.filePath());
    if(!file.open(QIODevice::WriteOnly))
    {
        return false;
    }

    file.write(data);
    file.waitForBytesWritten(10000);

    return true;
}

std::pair<bool, QByteArray> JasonQt_File::readFile(const QFileInfo &filePath)
{
    QFile file(filePath.filePath());

    if(!file.open(QIODevice::ReadOnly)) { return { false, "Open file error" }; }

    return { true, file.readAll() };
}

bool JasonQt_File::copyFile(const QFileInfo &sourcePath, const QFileInfo &targetPath, const bool &cover)
{
    if(sourcePath.filePath()[sourcePath.filePath().size() - 1] == '/')
    {
        return false;
    }

    if(targetPath.filePath()[targetPath.filePath().size() - 1] == '/')
    {
        return false;
    }

    if(!targetPath.dir().isReadable())
    {
        if(!QDir().mkpath(targetPath.path()))
        {
            return false;
        }
    }

    if(targetPath.isFile() && !cover)
    {
        return true;
    }

    return QFile::copy(sourcePath.filePath(), targetPath.filePath());
}

bool JasonQt_File::copyDirectory(const QFileInfo &sourceDirectory, const QFileInfo &targetDirectory, const bool &cover)
{
    try
    {
        if(!sourceDirectory.isDir())
        {
            throw false;
        }

        if(sourceDirectory.filePath()[sourceDirectory.filePath().size() - 1] != '/')
        {
            throw false;
        }

        if(targetDirectory.filePath()[targetDirectory.filePath().size() - 1] != '/')
        {
            throw false;
        }

        JasonQt_File::foreachFileFromDirectory(sourceDirectory, [&](const QFileInfo &info)
        {
            const auto &&path = info.path().mid(sourceDirectory.path().size());
            if(!JasonQt_File::copyFile(info, targetDirectory.path() + "/" + ((path.isEmpty()) ? ("") : (path + "/")) + info.fileName(), cover))
            {
                throw false;
            }
        }, true);
    }
    catch(const bool &error)
    {
        return error;
    }

    return true;
}

bool JasonQt_File::copy(const QFileInfo &source, const QFileInfo &target, const bool &cover)
{
    if(source.isFile())
    {
        return JasonQt_File::copyFile(source, target, cover);
    }
    else if(source.isDir())
    {
        return JasonQt_File::copyDirectory(source, target, cover);
    }

    return false;
}
