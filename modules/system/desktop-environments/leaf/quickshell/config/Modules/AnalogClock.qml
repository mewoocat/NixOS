import Quickshell
import QtQuick

Rectangle {
    id: rectangle
    anchors.fill: parent
    Canvas {
        id: canvas
        anchors.fill: parent
        // When it's time to render the canvas
        onPaint: {
            // Generate a 2d context to draw in
            let ctx = canvas.getContext("2d")
            ctx.fillStyle = "#00ff00"
            ctx.strokeStyle = '#0ff000'
            ctx.lineWidth = 4
            //ctx.fillRect(10, 10, rectangle.width - 20, rectangle.height - 20)
            //ctx.arc(40, 40, 0, 90, false)

            ctx.beginPath()
            ctx.moveTo(40, 40)
            ctx.lineTo(60, 50)
            ctx.stroke() // Actually draw the path
            //ctx.quadraticCurveTo(20, -20, 60, 50)
            ctx.closePath()
        }
    }
}
