import Quickshell
import QtQuick
import "../Services/" as Services

Item {
    id: root
    anchors.fill: parent

    property var date: Services.Time.date
    readonly property int degreesInSecond: 6
    property int indicatorLength: 30
    property int indicatorOuterPadding: 25
    property int xMid: root.width / 2
    property int yMid: root.height / 2

    onDateChanged: canvasHands.requestPaint()

    function degToRad(degrees) {
        return (Math.PI / 180) * degrees
    }

    // Draw indicators on the clock (i.e. ticks, hands, etc.)
    // Keep in mind that up is -y and down is +y
    // This function works by drawing the indicator at 12 o'clock but rotating the canvas before hand to the desired 
    // degree.  This allows for the indicators to to be drawn at any desired degree
    function drawIndicator(degrees, ctx) {
        ctx.beginPath()
        ctx.translate(xMid, yMid) // Move origin from 0,0 to center
        ctx.rotate(degToRad(degrees)) // Rotate the canvas around current origin
        ctx.moveTo(0, -(yMid - indicatorOuterPadding)) // Start drawing here at top middle edge with desired padding (if canvas was not rotated)
        ctx.lineTo(0, -(yMid - indicatorLength)) // Draw towards center taking into account the desired indicator length
        ctx.stroke() // Actually draw the path
        ctx.resetTransform() // Reset origin to 0,0
        ctx.closePath()
    }



    // Background
    Canvas {
        id: canvasBg
        anchors.fill: parent
        // When it's time to render the canvas
        onPaint: {
            // Generate a 2d context to draw in
            let ctx = canvasBg.getContext("2d")
            ctx.fillStyle = "#00ff00"
            ctx.strokeStyle = '#0ff000'
            ctx.lineWidth = 2
            ctx.lineCap = "round" 

            // Ticks
            root.drawIndicator(0, ctx) // 12 o'clock
            root.drawIndicator(30, ctx) // 1 o'clock
            root.drawIndicator(60, ctx) // 2 o'clock
            root.drawIndicator(90, ctx) // 3 o'clock
            root.drawIndicator(120, ctx) // 4 o'clock
            root.drawIndicator(150, ctx) // 5 o'clock
            root.drawIndicator(180, ctx) // 6 o'clock
            root.drawIndicator(210, ctx) // 7 o'clock
            root.drawIndicator(240, ctx) // 8 o'clock
            root.drawIndicator(270, ctx) // 9 o'clock
            root.drawIndicator(300, ctx) // 10 o'clock
            root.drawIndicator(330, ctx) // 11 o'clock

        }
    }

    // Hands
    Canvas {
        id: canvasHands
        anchors.fill: parent
        // When it's time to render the canvas
        onPaint: {
            // Generate a 2d context to draw in
            let ctx = canvasHands.getContext("2d")
            ctx.fillStyle = "#00ff00"
            ctx.strokeStyle = '#0ff000'
            ctx.lineWidth = 2
            ctx.lineCap = "round"

            ctx.clearRect(0, 0, root.width, root.height) // Clear the pixels under the rect
            
            ctx.strokeStyle = '#ffffff'
            // Hands
            root.drawIndicator(root.date.getSeconds() * 6, ctx) // second
        }
    }
}
