@[Link("dl")]
lib LibC
  fun dlclose(handle : Void*) : Int
  fun dlerror : Char*
  fun dlopen(file : Char*, mode : Int) : Void*
  fun dlsym(handle : Void*, name : Char*) : Void*
  fun dlvsym(handle : Void*, name : Char*, version : Char*) : Void*
  fun dladdr(address : Void*, info : DlInfo*) : Int
end