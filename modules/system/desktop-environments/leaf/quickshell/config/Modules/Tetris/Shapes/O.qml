import "../"

Shape {
    id: root
    property string color: "red"
    blockDefs: [
        BlockDef { xPos: 4; yPos: 0; style: root.color },
        BlockDef { xPos: 5; yPos: 0; style: root.color },
        BlockDef { xPos: 4; yPos: 1; style: root.color },
        BlockDef { xPos: 5; yPos: 1; style: root.color }
    ]
    orientations: []
}
