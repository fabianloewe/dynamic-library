require "spec"
require "../src/dynamic-library"
require "dir"

$dir : String = Dir.current + "/spec/test-lib"
system "gcc -c -fPIC -o #{$dir}/test-lib.o #{$dir}/test-lib.c"
system "gcc -shared -fPIC -Wl,-soname,libcrystal-test-lib.so.1 -o #{$dir}/libtest-lib.so.1.0.0 #{$dir}/test-lib.o -lc"