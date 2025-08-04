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
            const indicatorLength = 30
            const indicatorInnerPadding = 60
            const indicatorOuterPadding = 25
            /*
            ctx.beginPath()
            ctx.translate(xMid, yMid) // Move origin from 0,0 to center
            ctx.rotate(degToRad(90)) // Rotate around current origin
            //ctx.moveTo(xMid, 0)
            ctx.moveTo(0, 0)
            ctx.lineTo(0, -yMid) // origin 12 o'clock
            //ctx.lineTo(xMid, 0)
            ctx.resetTransform() // Reset origin
            console.log(`deg to rad: ${degToRad(90)}`)
            //canvas.requestPaint()
            //ctx.quadraticCurveTo(20, -20, 60, 50)
            ctx.stroke() // Actually draw the path
            ctx.closePath()
            */



            // Draw indicators on the clock
            // Keep in mind that up is -y and down is +y
            // This function works by drawing the indicator at 12 o'clock but rotating the canvas before hand to the desired 
            // degree.  This allows for the indicators to to be drawn at any desired degree
            const drawIndicator = (degrees) => {
                ctx.beginPath()
                ctx.translate(xMid, yMid) // Move origin from 0,0 to center
                ctx.rotate(degToRad(degrees)) // Rotate the canvas around current origin
                ctx.moveTo(0, -(yMid - indicatorOuterPadding)) // Start drawing here at top middle edge with desired padding (if canvas was not rotated)
                ctx.lineTo(0, -(yMid - indicatorLength)) // Draw towards center taking into account the desired indicator length
                ctx.stroke() // Actually draw the path
                ctx.resetTransform() // Reset origin to 0,0
                ctx.closePath()
            }

            drawIndicator(0) // 12 o'clock
            drawIndicator(30) // 1 o'clock
            drawIndicator(60) // 2 o'clock
        }
    }
}
