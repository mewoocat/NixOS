{inputs, ...}:
# NixOS systems
{
  scythe = import ./scythe {inputs = inputs;};
  obsidian = import ./obsidian {inputs = inputs;};
  chrysanthemum = import ./chrysanthemum {inputs = inputs;};
}
