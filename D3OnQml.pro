QT += quick

SOURCES += \
        Src/DJson.cpp \
        Src/main.cpp

resources.files = Qml/main.qml \
                  Qml/D3Canvas.qml \
                  JS/d3.js \
                  JS/topojson.js \
                  Resource/land-50m.json
resources.prefix = /$${TARGET}
RESOURCES += resources

TRANSLATIONS += \
    Resource/D3OnQml_zh_CN.ts
CONFIG += lrelease
CONFIG += embed_translations

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = Qml

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \

HEADERS += \
    Src/DJson.h

