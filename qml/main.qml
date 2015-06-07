import QtQuick 2.4
import QtQuick.Controls 1.3
import "qrc:/MaterialUI/Interface/"

ApplicationWindow {
    id: mainApplication
    title: qsTr("Cellular Automaton")
    width: 320
    height: 548
    visible: true
    color: "#000000"

    property var buf: null
    property var current: null

    function begin(horizontalCount, verticalCount) {
        current = new Array;
        for(var yIndex = 0; yIndex < verticalCount; yIndex++)
        {
            current.push(new Array);
            for(var xIndex = 0; xIndex < horizontalCount; xIndex++)
            {
                current[yIndex].push(0);
            }
        }
    }

    function refresh() {
        var yIndex;
        var xIndex;

        buf = new Array;
        for(yIndex = 0; yIndex < current.length; yIndex++)
        {
            buf.push(new Array);
            for(xIndex = 0; xIndex < current[yIndex].length; xIndex++)
            {
                buf[yIndex].push(current[yIndex][xIndex]);
            }
        }

        for(yIndex = 0; yIndex < current.length; yIndex++)
        {
            for(xIndex = 0; xIndex < current[yIndex].length; xIndex++)
            {
                var count = calculateValue(xIndex - 1, yIndex - 1)
                          + calculateValue(xIndex,     yIndex - 1)
                          + calculateValue(xIndex + 1, yIndex - 1)
                          + calculateValue(xIndex - 1, yIndex    )
                          + calculateValue(xIndex + 1, yIndex    )
                          + calculateValue(xIndex - 1, yIndex + 1)
                          + calculateValue(xIndex,     yIndex + 1)
                          + calculateValue(xIndex + 1, yIndex + 1)

                switch(count)
                {
                    case 2:
                        break;
                    case 3:
                        current[yIndex][xIndex] = 1;
                        break;
                    default:
                        current[yIndex][xIndex] = 0;
                        break;
                }
            }
        }
    }

    function calculateValue(xIndex, yIndex) {
        if((xIndex < 0) || (xIndex >= buf[0].length)) { return 0; }

        if((yIndex < 0) || (yIndex >= buf.length)) { return 0; }

        return buf[yIndex][xIndex];
    }

    Component.onCompleted: {
        begin(40, 40);
    }

    Rectangle {
        id: rectangleCanvas
        anchors.centerIn: parent
        width: Math.min(parent.width, parent.height)
        height: Math.min(parent.width, parent.height)
        color: "#00000000"

        Canvas {
            id: canvasBackground
            width: parent.width * JasonQtTool.devicePixelRatio()
            height: parent.height * JasonQtTool.devicePixelRatio()

            transform: Scale {
                xScale: 1 / JasonQtTool.devicePixelRatio()
                yScale: 1 / JasonQtTool.devicePixelRatio()
            }

            onPaint: {
                if((current === null) || (current.length === 0)) { return; }

                var ctx = getContext("2d");
                ctx.reset();

                var width = canvasMain.width / current[0].length;
                var height = canvasMain.height / current.length;
                var yIndex;
                var xIndex;

                ctx.strokeStyle = "#15ffffff";
                ctx.fillStyle = "#15ffffff";
                ctx.beginPath();

                for(yIndex = 0; yIndex < current.length; yIndex++)
                {
                    for(xIndex = 0; xIndex < current[yIndex].length; xIndex++)
                    {
                        ctx.roundedRect(xIndex * width, yIndex * height, width, height, width / 7, height / 7);
                    }
                }

                ctx.stroke();
                ctx.fill();
            }
        }

        Canvas {
            id: canvasMain
            width: parent.width * JasonQtTool.devicePixelRatio()
            height: parent.height * JasonQtTool.devicePixelRatio()

            transform: Scale {
                xScale: 1 / JasonQtTool.devicePixelRatio()
                yScale: 1 / JasonQtTool.devicePixelRatio()
            }

            onPaint: {
                if((current === null) || (current.length === 0)) { return; }

                var ctx = getContext("2d");
                ctx.reset();

                var width = canvasMain.width / current[0].length;
                var height = canvasMain.height / current.length;
                var yIndex;
                var xIndex;

                ctx.strokeStyle = "#15ffffff";
                ctx.fillStyle = "#00ff00";
                ctx.beginPath();

                for(yIndex = 0; yIndex < current.length; yIndex++)
                {
                    for(xIndex = 0; xIndex < current[yIndex].length; xIndex++)
                    {
                        if(current[yIndex][xIndex] === 1)
                        {
                            ctx.roundedRect(xIndex * width + (width / 28), yIndex * height + (height / 28), width - (width / 14), height - (height / 14), width / 7, height / 7);
                        }
                    }
                }

                ctx.stroke();
                ctx.fill();
            }

            MouseArea {
                anchors.fill: parent

                property int lastX
                property int lastY

                onPressed: {
                    lastX = mouseX;
                    lastY = mouseY;

                    arrow.visible = true;
                    positionChanged(mouse);
                }

                onPositionChanged: {
                    if(arrow.visible)
                    {
                        var currentX = mouseX;
                        var currentY = mouseY;

                        if(!JasonQtTool.isDesktop())
                        {
                            currentX = lastX + ((mouseX - lastX) / 3);
                            currentY = lastY + ((mouseY - lastY) / 3);
                        }

                        var x = parseInt(currentX / (canvasMain.width / current[0].length));
                        var y = parseInt(currentY / (canvasMain.height / current.length)) + ((JasonQtTool.isDesktop()) ? (0) : (-5));

                        if(y < 0) { y = 0; }
                        if(y >= current[0].length) { y = current[0].length - 1; }
                        if(x < 0) { x = 0; }
                        if(x >= current.length) { x = current.length - 1; }

                        arrow.x = x * arrow.width;
                        arrow.y = y * arrow.height;
                    }
                }

                onClicked: {
                    var currentX = mouseX;
                    var currentY = mouseY;

                    if(!JasonQtTool.isDesktop())
                    {
                        currentX = lastX + ((mouseX - lastX) / 3);
                        currentY = lastY + ((mouseY - lastY) / 3);
                    }

                    var x = parseInt(currentX / (canvasMain.width / current[0].length));
                    var y = parseInt(currentY / (canvasMain.height / current.length)) + ((JasonQtTool.isDesktop()) ? (0) : (-5));

                    if(y < 0) { y = 0; }
                    if(y >= current[0].length) { y = current[0].length - 1; }
                    if(x < 0) { x = 0; }
                    if(x >= current.length) { x = current.length - 1; }

                    switch(current[y][x])
                    {
                        case 0:
                            current[y][x] = 1;
                            break;
                        case 1:
                            current[y][x] = 0;
                            break;
                    }

                    canvasMain.requestPaint();
                }

                onReleased: {
                    arrow.visible = false;
                }
            }

            Rectangle {
                id: arrow
                color: "#00000000"
                border.color: "#ff0000"
                border.width: 2
                visible: false

                onVisibleChanged: {
                    if(visible){
                        width = rectangleCanvas.width / current[0].length * JasonQtTool.devicePixelRatio();
                        height = rectangleCanvas.height / current.length * JasonQtTool.devicePixelRatio();
                    }
                }
            }
        }
    }

    Board {
        id: board
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        onBegin: {
            mainApplication.begin(40, 40);
        }
        onRefresh: {
            mainApplication.refresh();
        }
        onPaint: {
            canvasMain.requestPaint();
        }
    }

    MaterialUI {
        id: materialUI
    }
}
