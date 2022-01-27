using Pkg
Pkg.activate(".")

using PackageCompiler

create_sysimage(; sysimage_path="Base16.so", incremental=false)
