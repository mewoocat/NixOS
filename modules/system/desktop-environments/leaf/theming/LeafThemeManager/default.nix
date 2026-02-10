{
  lib,
  rustPlatform,
}:

# Explanation of this "finalAttrs" pattern
# 
# Note that like `stdenv.mkDerivation`, `buildRustPackage` can take in an attribute set or a function.
# In the case of a function (like here), it will actually call the function with an argument that
# represents the final state of the package.  We can use this to reference other properties in the same
# attribute set which for example, can be useful to reuse the version value elsewhere in the set to
# reduce duplication of string literals.
# See: https://github.com/NixOS/nixpkgs/blob/master/doc/stdenv/stdenv.chapter.md#fixed-point-arguments-of-mkderivation-mkderivation-recursive-attributes
#
# Also note that (finalAttrs: { ... }) is a function call which calls the function with no arguments.
# In this case the function will evaluate to a lambda function.  Which is used as the input to
# `buildRustPackage`.
#
# Additionally, since Nix uses lazy evaluation, a function can be called with itself as an argument (what
# mkDerivation does to get the final state).  This works since the attributes on the set are not evaluated
# until needed.  So until an attribute that references the argument (finalAttrs in this case) is access, 
# the attribute contains an unevaluated expression also know as a thunk.  Since the provided function is 
# called with itself, it can reference literal values from other properties on itself.
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "leaf-theme-manager";
  version = "0.0.1";

  src = ./.;

  #cargoHash = "";
  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  meta = {
    description = "";
    homepage = "";
    license = lib.licenses.unlicense;
    maintainers = [ ];
  };
})
