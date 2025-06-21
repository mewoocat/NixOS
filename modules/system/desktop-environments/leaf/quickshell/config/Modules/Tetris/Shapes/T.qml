import "../"

Shape {
    id: root
    property string color: "purple"
    blockDefs: [
        BlockDef { xPos: 4; yPos: 0; style: root.color },
        BlockDef { xPos: 5; yPos: 0; style: root.color },
        BlockDef { xPos: 6; yPos: 0; style: root.color },
        BlockDef { xPos: 5; yPos: 1; style: root.color }
    ]
    // Orientations
    rotations: [
        // Default
        [
            {x: 0, y: 0},
            {x: 1, y: 0},
            {x: 2, y: 0},
            {x: 1, y: 1},
        ],
        [
            {x: 1, y: -1},
            {x: 1, y: 0},
            {x: 1, y: 1},
            {x: 0, y: 1},
        ],
    ]
}
