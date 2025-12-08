{inputs, ...}:
# NixOS systems
{
  scythe = import ./scythe {inputs = inputs;};
  obsidian = import ./obsidian {inputs = inputs;};
  orchid = import ./orchid {inputs = inputs;};
  maple = import ./maple {inputs = inputs;};
  chrysanthemum = import ./chrysanthemum {inputs = inputs;};
}
