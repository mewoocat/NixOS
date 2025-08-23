import Quickshell
import QtQuick
import qs.Services as Services

Item {
    id: root
    anchors.fill: parent

    property var date: Services.Time.date
    readonly property int degreesInSecond: 6
    property int tickOuterPadding: 24
    property int handOuterPadding: 24
    property int majorTickLength: 8
    property int minorTickLength: 4
    property int secondHandLength: 28
    property int minuteHandLength: 24
    property int hourHandLength: 16
    property int xMid: root.width / 2
    property int yMid: root.height / 2

    onDateChanged: canvasHands.requestPaint()

    function degToRad(degrees) {
        return (Math.PI / 180) * degrees
    }

    // Draw a tick indicator
    // Keep in mind that up is -y and down is +y
    // This function works by drawing the indicator at 12 o'clock but rotating the canvas before hand to the desired 
    // degree.  This allows for the indicators to to be drawn at any desired degree
    function drawTick(degrees, length, ctx) {
        ctx.beginPath()
        ctx.translate(xMid, yMid) // Move origin from 0,0 to center
        ctx.rotate(degToRad(degrees)) // Rotate the canvas around current origin
        ctx.moveTo(0, -(yMid - root.tickOuterPadding)) // Start drawing here at top middle edge with desired padding (if canvas was not rotated)
        ctx.lineTo(0, -(yMid - root.tickOuterPadding - length)) // Draw towards center taking into account the desired indicator length
        ctx.stroke() // Actually draw the path
        ctx.resetTransform() // Reset origin to 0,0
        ctx.closePath()
    }

    // Draw a hand indicator
    // Keep in mind that up is -y and down is +y
    // This function works by drawing the indicator at 12 o'clock but rotating the canvas before hand to the desired 
    // degree.  This allows for the indicators to to be drawn at any desired degree
    function drawHand(degrees, length, ctx) {
        ctx.beginPath()
        ctx.translate(xMid, yMid) // Move origin from 0,0 to center
        ctx.rotate(degToRad(degrees)) // Rotate the canvas around current origin
        ctx.moveTo(0, 0) // Start at center
        ctx.lineTo(0, -length) // Draw towards the top middle edge with desired length (if canvas was not rotated)
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

            // Tick
            root.drawTick(0, root.majorTickLength, ctx) // 12 o'clock
            root.drawTick(30, root.minorTickLength, ctx) // 1 o'clock
            root.drawTick(60, root.minorTickLength, ctx) // 2 o'clock
            root.drawTick(90, root.majorTickLength, ctx) // 3 o'clock
            root.drawTick(120, root.minorTickLength, ctx) // 4 o'clock
            root.drawTick(150, root.minorTickLength, ctx) // 5 o'clock
            root.drawTick(180, root.majorTickLength, ctx) // 6 o'clock
            root.drawTick(210, root.minorTickLength, ctx) // 7 o'clock
            root.drawTick(240, root.minorTickLength, ctx) // 8 o'clock
            root.drawTick(270, root.majorTickLength, ctx) // 9 o'clock
            root.drawTick(300, root.minorTickLength, ctx) // 10 o'clock
            root.drawTick(330, root.minorTickLength, ctx) // 11 o'clock

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
            ctx.strokeStyle = '#ffffff'
            ctx.lineWidth = 4
            ctx.lineCap = "round"

            ctx.clearRect(0, 0, root.width, root.height) // Clear the pixels under the rect
            
            // Hands
            const seconds = root.date.getSeconds()
            root.drawHand(Math.ceil(root.date.getHours() / 12 * 360), root.hourHandLength, ctx) // hours
            root.drawHand(Math.ceil(root.date.getMinutes() / 60 * 360), root.minuteHandLength, ctx) // minutes
            ctx.lineWidth = 2
            root.drawHand(seconds * root.degreesInSecond, root.secondHandLength, ctx) // second
        }
    }
}
