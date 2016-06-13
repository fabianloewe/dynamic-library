require "exception"

# Raised by the `DynamicLibrary#symbol` method.
# The message is created by `LibC::dlerror`.
class SymbolNotFoundError < Exception
  def initialize(msg : String)
    super(msg)
  end
end

# Raised by the `DynamicLibrary.addr` method.
class AddressNotFoundError < Exception
  def initialize(msg : String)
    super(msg)
  end
end

# Raised by the `DynamicLibrary#open` method.
# The message is created by `LibC::dlerror`.
class LibraryNotOpenedError < Exception
  def initialize(msg : String)
    super(msg)
  end
end

