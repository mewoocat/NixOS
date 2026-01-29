{inputs, ...}:
# NixOS systems
{
  scythe = import ./scythe { inherit inputs; };
  obsidian = import ./obsidian { inherit inputs; };
  orchid = import ./orchid { inherit inputs; };
  maple = import ./maple { inherit inputs; };
  chrysanthemum = import ./chrysanthemum { inherit inputs; };
}
