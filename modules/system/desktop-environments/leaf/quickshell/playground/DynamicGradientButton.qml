// From: M7moud El-zayat

import QtQuick
import QtQuick.Shapes
import Quickshell

FloatingWindow {
  color: "black"

  Shape {
    id: shape

    width: 200
    height: 200
    
    preferredRendererType: Shape.CurveRenderer

    anchors.centerIn: parent

    ShapePath {
      strokeWidth: 2

      fillGradient: RadialGradient {
        centerX: mouseArea.mouseX; centerY: mouseArea.mouseY
        centerRadius: Math.sqrt(Math.pow(shape.width, 2) + Math.pow(shape.width, 2))
        focalX: centerX; focalY: centerY
        GradientStop { position: 0; color: "cyan" }
        GradientStop { position: 1; color: Qt.darker("cyan", 4) }
      }

      PathAngleArc {
        centerX: shape.width / 2
        centerY: shape.width / 2
        radiusX: shape.width / 2
        radiusY: shape.width / 2
        sweepAngle: 360
      }
    }

    MouseArea {
      id: mouseArea
      hoverEnabled: true
      anchors.fill: parent
    }
  }
}
