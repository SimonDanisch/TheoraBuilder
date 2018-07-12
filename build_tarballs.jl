# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "libtheora"
version = v"1.1.1"

# Collection of sources required to build libtheora
sources = [
    "https://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.xz" =>
    "f36da409947aa2b3dcc6af0a8c2e3144bc19db2ed547d64e9171c59c66561c61",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd libtheora-1.1.1/
sed -i 's/png_\(sizeof\)/\1/g' examples/png2theora.c
./configure --disable-examples --prefix=$prefix --host=$target --disable-oggtest --disable-static
make -j${ncore}
make install
exit

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    MacOS(:x86_64),
    Linux(:armv7l, :glibc, :eabihf),
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libtheora", :libtheora)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/staticfloat/OggBuilder/releases/download/v1.3.3-6/build_Ogg.v1.3.3.jl",
    "https://github.com/JuliaIO/LibVorbisBuilder/releases/download/v1.3.6/build_libvorbis.v1.3.6.jl"
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

