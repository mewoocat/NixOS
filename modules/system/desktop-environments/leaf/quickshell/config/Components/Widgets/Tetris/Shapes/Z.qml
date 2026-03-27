import "../"

Shape {
    id: root
    property string color: "green"
    orientations: [
        [
            {x: 0, y: 1},
            {x: 1, y: 1},
            {x: 1, y: 2},
            {x: 2, y: 2},
        ],
        [
            {x: 1, y: 0},
            {x: 0, y: 1},
            {x: 1, y: 1},
            {x: 0, y: 2},
        ],
    ]
}
