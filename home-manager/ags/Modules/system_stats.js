import Widget from 'resource:///com/github/Aylur/ags/widget.js';

// Look here instead https://github.com/Aylur/dotfiles/blob/main/ags/js/variables.js
const CPU = () => Widget.Label()
    .poll(1000, self => {
        self.label = Utils.exec('')
    })