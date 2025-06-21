import "../"

Shape {
    id: root
    property string color: "green"
    blockDefs: [
        BlockDef { xPos: 4; yPos: 0; style: root.color },
        BlockDef { xPos: 5; yPos: 0; style: root.color },
        BlockDef { xPos: 5; yPos: 1; style: root.color },
        BlockDef { xPos: 6; yPos: 1; style: root.color }
    ]
    rotations: []
}
