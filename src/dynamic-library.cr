require "./dynamic-library/*"

# Represents a dynamic loadable library.
class DynamicLibrary
  property name  = ""
  property flags = 0

  @opened = false
  @handle = Pointer(Void).null

  # Opens the specified library and lets you operate on it in a block.
  # Afterwards the library gets closed.
  #
  # ```
  # DynamicLibrary.open "some_lib.so" do |library|
  #   if symbol = library.symbol "some_symbol"
  #     ...
  #   elsif symbol = library.symbol "some_other_symbol"
  #     ...
  #   end
  # end
  # ```
  def self.open(name : String, flags = LibC::RTLD_LAZY | LibC::RTLD_GLOBAL, &block)
    library = DynamicLibrary.new name, flags
    yield library
    library.close
  end

  # Searchs for a symbol at or after the specfied address.
  # Raises a `AddressNotFoundError` exception if failed.
  #
  # ```
  # begin
  #   dl_info = DynamicLibrary.addr pointer
  # rescue e
  #   puts e
  # end
  # ```
  def self.addr(addr : Void*)
    if LibC.dladdr(addr, out info) > 0
      info
    else
      raise AddressNotFoundError.new "The address #{addr} was not matched to any symbol"
    end
  end

  # Searchs for a symbol at or after the specfied address.
  # Returns nil if failed.
  #
  # ```
  # if dl_info = DynamicLibrary.addr? pointer
  #   ...
  # end
  # ```
  def self.addr?(addr : Void*)
    if LibC.dladdr(addr, out info) > 0
      info
    else 
      nil
    end
  end

  # Loads the library.
  # Because it uses the `DynamicLibrary#open` method
  # the `LibraryNotOpenedError` exception could be raised.
  def initialize(@name, @flags = LibC::RTLD_LAZY | LibC::RTLD_GLOBAL)
    open @name, @flags
  end

  # Unloads the library.
  # The `DynamicLibrary#close` method gets called.
  def finalize
    close
  end

  # Opens a library. 
  # This function can be used to reopen a library if it was closed. 
  # Raises a `LibraryNotOpenedError` exception if failed.
  #
  # ```
  # library = DynamicLibrary.new "some_lib.so"
  # ...
  # if some_condition
  #   library.close
  # end
  # ...
  # library.open "some_other_lib.so"
  # ```
  def open(name : String, flags = LibC::RTLD_LAZY | LibC::RTLD_GLOBAL)
    @handle = LibC.dlopen name, flags
    if handle = @handle
      @opened = true
    else
      raise LibraryNotOpenedError.new(String.new LibC.dlerror)
    end
  end

  # Opens a library. 
  # This function can be used to reopen a library if it was closed. 
  # Returns false if failed.
  #
  # ```
  # library = DynamicLibrary.new "some_lib.so"
  # ...
  # if some_condition
  #   library.close
  # end
  # ...
  # if library.open? "some_other_lib.so"
  #   ...
  # end
  # ```
  def open?(name : String, flags = LibC::RTLD_LAZY | LibC::RTLD_GLOBAL)
    @handle = LibC.dlopen name, flags
    if handle = @handle
      @opened = true
      true
    else
      false
    end
  end

  # Checks if the library was successfully opened
  #
  # ```
  # library = DynamicLibrary.new "some_lib.so"
  # if library.open?
  #   ...
  # end
  # ```
  def open?
    @opened
  end

  # Closes the library 
  #
  # ```
  # library = DynamicLibrary.new "some_lib.so"
  # ...
  # library.close
  # ```
  def close
    if opened = @opened
      LibC.dlclose @handle
      @opened = false
    end
  end

  # Resolves a symbol in the library and raises on error.
  # Raises a `SymbolNotFoundError` exception.
  #
  # ```
  # library = DynamicLibrary.new "some_lib.so"
  # begin
  #   symbol = library.symbol "some_symbol"
  #   ...
  # rescue e
  #   puts e
  # end
  # ```
  def symbol(name : String, version = "")
    if version.empty?
      if sym = LibC.dlsym @handle, name
        sym
      else
        raise SymbolNotFoundError.new(String.new LibC.dlerror)
      end
    else
      if sym = LibC.dlvsym @handle, name, version
        sym
      else
        raise SymbolNotFoundError.new(String.new LibC.dlerror)
      end
    end
  end

  # Resolves a symbol in the library and returns a null Pointer(Void) on error
  #
  # ```
  # library = DynamicLibrary.new "some_lib.so"
  # if symbol = library.symbol? "some_symbol"
  #   ...
  # end
  # ```
  def symbol?(name : String, version = "")
    if version.empty?
      LibC.dlsym @handle, name
    else
      LibC.dlvsym @handle, name, version
    end
  end
end