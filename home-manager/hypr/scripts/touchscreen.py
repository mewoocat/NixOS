from threading import Thread
import struct
import os
from datetime import datetime

### GENERAL VARIABLES

# Literal screen resolution
# TODO: Get screen resolution automatically
screen_width = 2560.0
screen_height = 1440.0
# Touch resolution (can be found using evtest)
# TODO: Get touch resolution automatically
touch_width = 3976.0
touch_height = 2128.0

# Key values (can be found using evtest)
super_key_index = 125
shift_key_index = 42

# You might have to give user access to these devices
# TODO: Make a more permanent solution - this implementation resets after a reboot
touch_device = "/dev/input/event4"
keyboard_device = "/dev/input/event3"

# Reads device input
f = open(touch_device, "rb")
f_keys = open(keyboard_device, "rb")

# Stores if keys are pressed
key_amount = 256
keys = [False] * key_amount

### FINGER REPRESENTATION

class Finger:
    def __init__(self, id, mov_fun, down_fun):
        self.mov_fun = mov_fun
        self.down_fun = down_fun

        self.id = id
        self.pos_x = 0
        self.pos_y = 0
        self.vel_x = 0
        self.vel_y = 0
        self.down = False
        self.first_down = False
        self.first_up = False

    def update_x(self, x):
        x = x * screen_width / touch_width
        self.vel_x = x - self.pos_x
        self.vel_y = 0
        self.pos_x = x
        self.first_down = False
        self.first_up = False
        self.mov_fun(self)

    def update_y(self, y):
        y = y * screen_height / touch_height
        self.vel_y = y - self.pos_y
        self.vel_x = 0
        self.pos_y = y
        self.first_down = False
        self.first_up = False
        self.mov_fun(self)

    def update_down(self, down):
        self.cum_vel_x = 0
        self.cum_vel_y = 0
        if down and not self.down:
            self.first_down = True
        if not down:
            self.first_down = False
        if not down and self.down:
            self.first_up = True
        if down:
            self.first_up = False
        self.down = down
        self.down_fun(self)

    def print(self):
        print("Finger " + str(self.id) + ": " + "(" + str(self.screen_x) + ", " +
              str(self.screen_y) + ")[" + str(self.down) + "] FirstDown: " + str(self.first_down) + ", FirstUp: " + str(self.first_up))

def position_listener(finger):
    if keys[super_key_index] and not keys[shift_key_index]:
        if finger.down and not finger.first_down:
            resize_active(finger.vel_x, finger.vel_y)
    if keys[super_key_index] and keys[shift_key_index]:
        if finger.down and not finger.first_down:
            pass # move_active(finger.vel_x, finger.vel_y)


def down_listener(finger):
    if keys[super_key_index] and keys[shift_key_index]:
        if finger.first_down or finger.first_up:
            if finger.first_up:
                move_active_exact(finger.pos_x, finger.pos_y)
            toggle_floating_active()


max_finger_amount = 5
finger_count = 0
fingers = []
for x in range(max_finger_amount):
    fingers.append(Finger(x, position_listener, down_listener))

### KEYBOARD LOGIC

def get_keys():
    global keys
    while 1:
        input = read_line(f_keys)
        if input[1] == 1 and input[2] < key_amount:
            if input[3] == 0:
                keys[input[2]] = False
            elif input[3] == 1:
                keys[input[2]] = True

# TOUCHSCREEN LOGIC

def get_touch():
    global finger_count
    while 1:
        input = read_line(f)
        if input[1] == 1:
            # Singletouch detection
            if input[2] == 330:
                if input[3] == 0:
                    for finger in fingers:
                        finger.update_down(False)
                    finger_count = 0
                elif input[3] == 1:
                    fingers[0].update_down(True)
        if input[1] == 3:
            handle_multitouch(input)
            # Singletouch movement
            if input[2] == 53:
                fingers[0].update_x(input[3])
            if input[2] == 54:
                fingers[0].update_y(input[3])

        elif input[1] == 4:
            pass #print(finger_count)

def handle_multitouch(input):
    # TODO: I have no idea how the multitouch-protocol handles counting pointers, figure it out!
    global finger_count
    if input[2] == 47:
        finger_index = input[3]
        if finger_index + 1 > finger_count:
            finger_count = finger_index + 1
            fingers[finger_index].update_down(True)
        line_1 = read_line(f)
        line_2 = read_line(f)
        if (line_1[1] == 3 and line_1[2] == 53) and finger_index == 0:
            fingers[finger_index].update_x(line_1[3])
        if (line_2[1] == 3 and line_2[2] == 54) and finger_index == 0:
            fingers[finger_index].update_y(line_2[3])

### CONTROLLING HYPRLAND

def toggle_floating_active():
    os.system("hyprctl dispatch togglefloating active")

def move_active(x, y):
    os.system("hyprctl dispatch moveactive " + str(int(x)) + " " + str(int(y)))

def move_active_exact(x, y):
    os.system("hyprctl dispatch moveactive exact " + str(int(x)) + " " + str(int(y)))

def resize_active(x, y):
    os.system("hyprctl dispatch resizeactive " +
              str(int(x)) + " " + str(int(y)))

### READING TOUCHSCREEN DATA

def read_timestamp(f):
    return struct.unpack('2l', f.read(16))


def read_type(f):
    return struct.unpack('1h', f.read(2))[0]


def read_code(f):
    return struct.unpack('1h', f.read(2))[0]


def read_data(f):
    return struct.unpack('1i', f.read(4))[0]


def read_line(f):
    return (read_timestamp(f), read_type(f), read_code(f), read_data(f))

### THREADS FOR KEYBOARD AND TOUCH INPUT

t1 = Thread(target=get_touch)
t2 = Thread(target=get_keys)

t1.start()
t2.start()

t1.join()
t2.join()
