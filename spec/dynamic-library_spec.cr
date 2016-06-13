require "./spec_helper"

describe "DynamicLibrary" do
  # TODO: Write tests

  describe ".open" do
    it "should open the library 'libtest-lib.so'" do
      DynamicLibrary.open "#{$dir}/libtest-lib.so.1.0.0" do |library|
        library.open?.should be_true
      end
    end
  end

  describe ".addr" do
    it "should find a symbol for the address of 'DynamicLibrary.addr'" do
      DynamicLibrary.open "#{$dir}/libtest-lib.so.1.0.0" do |library|
        symbol = library.symbol "add"
        DynamicLibrary.addr(symbol).nil?.should be_false
      end
    end
  end

  describe ".addr" do
    it "should not find a symbol for a random address" do
      expect_raises AddressNotFoundError do
        DynamicLibrary.addr(Pointer(Void).new)
      end
    end
  end

  describe ".addr?" do
    it "should find a symbol for the address of 'DynamicLibrary.addr'" do
      DynamicLibrary.open "#{$dir}/libtest-lib.so.1.0.0" do |library|
        symbol = library.symbol "add"
        DynamicLibrary.addr?(symbol).nil?.should be_false
      end
    end
  end

  describe ".addr?" do
    it "should not find a symbol for a random address" do
      DynamicLibrary.addr?(Pointer(Void).new).should be_nil
    end
  end

  describe "#initialize" do
    it "should create a DynamicLibrary instance" do
      library = DynamicLibrary.new "#{$dir}/libtest-lib.so.1.0.0"
      library.open?.should be_true
    end
  end

  describe "#initialize" do
    it "should raise on creating an instance for a non-existing library" do
      expect_raises LibraryNotOpenedError do
        library = DynamicLibrary.new "#some_lib.so"
      end
    end
  end

  describe "#close" do
    it "should close the library 'libtest-lib.so'" do
      library = DynamicLibrary.new "#{$dir}/libtest-lib.so.1.0.0"
      library.close
      library.open?.should be_false
    end
  end

  describe "#symbol" do
    it "should find the symbol 'add'" do
      library = DynamicLibrary.new "#{$dir}/libtest-lib.so.1.0.0"
      symbol = library.symbol "add"
      symbol.null?.should be_false
      
      func = Proc(Int32, Int32, Int32).new(symbol, Pointer(Void).null)
      func.call(1, 2).should eq 3  
    end
  end

  describe "#symbol" do
    it "should not find the symbol 'nothing'" do
      library = DynamicLibrary.new "#{$dir}/libtest-lib.so.1.0.0"
      expect_raises SymbolNotFoundError do
        library.symbol("nothing") 
      end
    end
  end

  describe "#symbol?" do
    it "should find the symbol 'add'" do
      library = DynamicLibrary.new "#{$dir}/libtest-lib.so.1.0.0"
      symbol = library.symbol? "add"
      symbol.null?.should be_false

      func = Proc(Int32, Int32, Int32).new(symbol, Pointer(Void).null)
      func.call(1, 2).should eq 3  
    end
  end

  describe "#symbol?" do
    it "should not find the symbol 'nothing'" do
      library = DynamicLibrary.new "#{$dir}/libtest-lib.so.1.0.0"
      library.symbol?("nothing").null?.should be_true
    end
  end
end
