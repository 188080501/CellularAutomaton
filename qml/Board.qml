import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import "qrc:/MaterialUI/Interface/"

Rectangle {
    id: mainRectangle
    width: 300
    height: 200
    color: "#00000000"

    property int timerInterval

    signal begin()
    signal refresh()
    signal paint()

    function hide() {
        if(centerRectangle.y !== -1 * mainRectangle.height)
        {
            animation.to = -1 * mainRectangle.height;
            animation2.to = 0.2;

            animation.restart();
            animation2.restart();
        }
    }

    Rectangle{
        anchors.fill: centerRectangle
        color: "#ddffffff"
        clip: true

        property var target: centerRectangle

        FastBlur {
            id: blur
            source: parent.target
            width: source.width;
            height: source.height
            radius: 20
        }

        onXChanged: setBlurPosition();
        onYChanged: setBlurPosition();
        Component.onCompleted: setBlurPosition();
        function setBlurPosition(){
            blur.x = target.x - x;
            blur.y = target.y - y;
        }
    }

    Rectangle {
        id: centerRectangle
        x: 0
        y: 200
        width: mainRectangle.width
        height: parent.height
        color: "#00000000"
        border.color: "#a1a1a1"
        border.width: 2

        MouseArea {
            anchors.fill: parent

            Rectangle {
                id: rectangle1
                x: 10
                y: 93
                width: 280
                height: 1
                color: "#a1a1a1"
            }
        }

        Rectangle {
            id: rectangleMore
            width: 50
            height: 25
            color: "#55a1a1a1"
            border.color: "#a1a1a1"
            border.width: 2
            radius: 5
            anchors.bottom: parent.top
            anchors.bottomMargin: 0
            anchors.horizontalCenter: parent.horizontalCenter

            onVisibleChanged: {
                if(!visible)
                {
                    hide();
                }
            }

            Text {
                text: qsTr("控制")
                color: "#88ffffff"
                anchors.fill: parent
                font.pixelSize: 15
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            MouseArea {
                anchors.fill: parent
                property int firstY
                property int firstTargetY

                onPressed: {
                    firstY = mouseY;
                    firstTargetY = centerRectangle.y
                    animation.stop();
                }
                onMouseYChanged: {
                    centerRectangle.y = centerRectangle.y + mouseY - firstY;
                }
                onReleased: {
                    if(Math.abs(centerRectangle.y - firstTargetY) < 3)
                    {
                        if(centerRectangle.y > (mainRectangle.height * 0.3))
                        {
                            animation.to = 0;
                        }
                        else
                        {
                            animation.to = 1 * mainRectangle.height;
                        }
                    }
                    else
                    {
                        if(centerRectangle.y > (mainRectangle.height * 0.3))
                        {
                            animation.to = 1 * mainRectangle.height;
                        }
                        else
                        {
                            animation.to = 0;
                        }
                    }

                    animation.restart();
                }
            }

            NumberAnimation {
                id: animation
                duration: 500
                target: centerRectangle
                easing.type: Easing.OutQuad
                property: "y"
            }
        }

        MaterialButton {
            x: 206
            y: 130
            width: 80
            height: 40
            text: qsTr("刷新")
            elevation: 1
            backgroundColor: materialUI.accentColor

            onClicked: {
                refresh();
                paint();
            }
        }

        Text {
            x: 6
            y: 117
            width: 80
            height: 24
            text: qsTr("自动刷新")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 15
        }

        MaterialSwitch {
            x: 119
            y: 104
            width: 50
            height: 50

            Timer {
                interval: timerInterval
                repeat: true
                running: parent.checked

                onTriggered: {
                    refresh();
                    paint();
                }
            }
        }

        Text {
            x: 6
            y: 160
            width: 80
            height: 24
            text: timerInterval + "ms"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 15
        }

        MaterialSlider {
            x: 87
            y: 160
            width: 99
            height: 32
            minimumValue: 1
            maximumValue: 9

            onValueChanged: {
                switch(parseInt(value))
                {
                    case 1:
                        timerInterval = 250;
                        break;
                    case 2:
                        timerInterval = 500;
                        break;
                    case 3:
                        timerInterval = 750;
                        break;
                    case 4:
                        timerInterval = 1000;
                        break;
                    case 5:
                        timerInterval = 2000;
                        break;
                    case 6:
                        timerInterval = 3000;
                        break;
                    case 7:
                        timerInterval = 4000;
                        break;
                    case 8:
                        timerInterval = 5000;
                        break;
                    case 9:
                        timerInterval = 10000;
                        break;
                }
            }

            Component.onCompleted: {
                value = 4;
            }
        }

        MaterialButton {
            x: 51
            y: 29
            width: 80
            height: 40
            text: qsTr("重置")
            elevation: 1

            onClicked: {
                materialUI.showDialogConfirm(qsTr("重置"), qsTr("你确定要重置当前数据吗？"),
                                             null,
                                             function(){
                                                 mainRectangle.begin();
                                                 mainRectangle.paint();
                                             });
            }
        }

        MaterialButton {
            x: 168
            y: 29
            width: 80
            height: 40
            text: qsTr("存取")
            elevation: 1

            onClicked: {
                var sheetData = new Array;

                sheetData.push( { text: qsTr("保存"), flag: "Save" } );
                sheetData.push( { text: qsTr("读取"), flag: "Read", hasDividerAfter: true } );
                sheetData.push( { text: qsTr("删除"), flag: "Delete" } );

                materialUI.showBottomActionSheet("存取操作", sheetData,
                                                 null,
                                                 function(index, text, flag) {
                                                     var availableDocument;
                                                     var listData;
                                                     var index2;

                                                     switch(flag)
                                                     {
                                                         case "Save":
                                                             materialUI.showDialogPrompt(qsTr("保存"), qsTr("请输入存档名"), qsTr("存档名"), qsTr("新存档"),
                                                                                         null,
                                                                                         function(filename) {
                                                                                             if(DocumentManage.saveDocument(current, filename))
                                                                                             {
                                                                                                 materialUI.showSnackbarMessage(qsTr("保存成功"));
                                                                                             }
                                                                                             else
                                                                                             {
                                                                                                 materialUI.showSnackbarMessage(qsTr("保存失败"));
                                                                                             }
                                                                                         });
                                                             break;

                                                         case "Read":
                                                             availableDocument = DocumentManage.availablesDocument();
                                                             listData = new Array;

                                                             for(index2 = 0; index2 < availableDocument["userDocument"].length; index2++)
                                                             {
                                                                 listData.push( { text: availableDocument["userDocument"][index2], flag: "userDocument" } );
                                                             }

                                                             for(index2 = 0; index2 < availableDocument["defaultDocument"].length; index2++)
                                                             {
                                                                 listData.push( { text: availableDocument["defaultDocument"][index2], flag: "defaultDocument" } );
                                                             }

                                                             materialUI.showDialogScrolling(qsTr("读取"), qsTr("选择要读取的存档"), listData,
                                                                                            null,
                                                                                            function(index, text, flag) {
                                                                                                var data = DocumentManage.readDocument(flag, text);

                                                                                                if(!data || (data.length === 0))
                                                                                                {
                                                                                                    materialUI.showSnackbarMessage(qsTr("读取失败"));
                                                                                                    return;
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                    materialUI.showSnackbarMessage(qsTr("读取成功"));
                                                                                                }

                                                                                                current = data;
                                                                                                mainRectangle.paint();
                                                                                            });
                                                             break;

                                                         case "Delete":
                                                             availableDocument = DocumentManage.availablesDocument();
                                                             listData = new Array;

                                                             for(index2 = 0; index2 < availableDocument["userDocument"].length; index2++)
                                                             {
                                                                 listData.push( { text: availableDocument["userDocument"][index2], flag: "userDocument" } );
                                                             }

                                                             materialUI.showDialogScrolling(qsTr("删除"), qsTr("选择要删除的存档"), listData,
                                                                                            null,
                                                                                            function(index, text, flag) {
                                                                                                if(DocumentManage.deleteDocument(text))
                                                                                                {
                                                                                                    materialUI.showSnackbarMessage(qsTr("删除成功"));
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                    materialUI.showSnackbarMessage(qsTr("删除失败"));
                                                                                                }
                                                                                            });
                                                             break;
                                                     }
                                                 });
            }
        }
    }
}
