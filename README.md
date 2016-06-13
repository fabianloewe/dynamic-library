# dynamic-library

A higher-level class for loading dynamic libraries and resolving symbols in Crystal.

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  dynamic-library:
    github: hyronx/dynamic-library
```


## Usage


```crystal
require "dynamic-library"

library = DynamicLibrary.new "some_lib.so", LibC::RTLD_NOW
if symbol = library.symbol? "add"
  func = Proc(UInt32, UInt32, UInt32).new symbol, Pointer(Void).null
  func.call(1, 2) # -> 3
end

# library.close    (This is optional and otherwise automatically done.)
```

## Contributing

1. Fork it ( https://github.com/hyronx/dynamic-library/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [hyronx](https://github.com/hyronx)  - creator, maintainer
