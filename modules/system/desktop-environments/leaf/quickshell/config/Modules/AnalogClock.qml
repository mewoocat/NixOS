import Quickshell
import QtQuick

Rectangle {
    id: rectangle
    anchors.fill: parent
    color: "transparent"
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
            ctx.lineCap = "round"
            //ctx.fillRect(10, 10, rectangle.width - 20, rectangle.height - 20)
            //ctx.arc(40, 40, 0, 90, false)
            
            const degToRad = (degrees) => (Math.PI / 180) * degrees

            const xMid = canvas.width / 2
            const yMid = canvas.height / 2
            ctx.beginPath()
            ctx.moveTo(xMid, 0)
            ctx.lineTo(xMid, yMid) // 12 o'clock
            console.log(`deg to rad: ${degToRad(90)}`)
            ctx.rotate(degToRad(90))
            ctx.stroke() // Actually draw the path
            //ctx.quadraticCurveTo(20, -20, 60, 50)
            ctx.closePath()
        }
    }
}
