import QtQuick 2.0
import QDJson 1.0
import "../d3.js" as D3
import "../topojson.js" as TopoJson
Canvas{
    property var path;
    property var outline : ({type: "Sphere"})


    property var projection
    property var graticule
    property var land
    property var jsonData
    property int scaleValue:850
    property var homePos:[116.418757,39.917544]
    property var d3MousePos: d3.scalePoint().domain([1,2])
    property var centerPos:d3.scalePoint().domain([1,2])
    property var nowCenterPos:d3.scalePoint().domain([1,2])
    property var curtPos:d3.scalePoint().domain([1,2])
    property var prePos:d3.scalePoint().domain([1,2])
    property bool bLeftButtonDown: false
    property var rotate:d3.scalePoint().domain([1,2])

    QDJson{
        id: classifyTableJsonFile
        source:":/D3OnQml/Resource/land-50m.json"
    }

    MouseArea
    {
        anchors.fill: parent
        acceptedButtons: Qt.AllButtons
        onWheel:function(wheel)
        {
            var datl = wheel.angleDelta.y/120;
            if(datl>0)
            {
                scaleValue += 100;
            }
            else
            {
                scaleValue -= 100;
            }
            projection.scale(scaleValue);
            requestPaint();
        }

        onPressed:function(mouse)
        {
            if(mouse.button === Qt.LeftButton)
            {
                bLeftButtonDown = true;
                d3MousePos[0] = mouse.x;
                d3MousePos[1] = mouse.y;
                prePos = projection.invert(d3MousePos);
            }
        }

        onReleased: function(mouse)
        {
            if(mouse.button === Qt.LeftButton)
            {
                nowCenterPos[0] = centerPos[0];
                nowCenterPos[1] = centerPos[1];
                bLeftButtonDown = false;

            }
        }

        onPositionChanged:function(mouse)
        {
            if(bLeftButtonDown)
            {
//                d3MousePos[0] = mouse.x;
//                d3MousePos[1] = mouse.y;
//                curtPos = projection.invert(d3MousePos);
//                centerPos[0] = nowCenterPos[0] - curtPos[0] + prePos[0];
//                centerPos[1] = nowCenterPos[1] - curtPos[1] + prePos[1];
//                projection.center(centerPos);
                rotate[0] += 10;
                projection.rotate(rotate);
                requestPaint();
            }
        }
    }

    onPaint:
    {
        var canvas = getContext("2d");
        canvas.clearRect(0, 0, width, height);
        if(typeof path === 'undefined')
        {
            projection = d3.geoOrthographic()
            .scale(scaleValue)
            .translate([width/2, height/2])
            nowCenterPos = projection.center();

            path = d3.geoPath(projection, canvas);
            graticule = d3.geoGraticule10();
            jsonData = classifyTableJsonFile.readJsonFile();
            rotate[0] = 0;
            rotate[1] = 0;
            land = topojson.feature(jsonData, jsonData.objects.land)
        }

        canvas.save();
        canvas.beginPath(), path(outline), canvas.clip();
        canvas.beginPath(), path(graticule), canvas.strokeStyle = "#c00", canvas.stroke();
        canvas.beginPath(), path(land), canvas.fillStyle = "#000", canvas.fill();
        canvas.beginPath(), path(outline), canvas.strokeStyle = "#000", canvas.stroke();
        canvas.restore();
    }

    onCanvasSizeChanged:
    {
        if(typeof projection !== 'undefined')
        {
            projection.translate([width/2, height/2])
            requestPaint();
        }
    }

}
