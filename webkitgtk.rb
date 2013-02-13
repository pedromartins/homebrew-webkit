require 'formula'

# Adapted from https://trac.macports.org/browser/trunk/dports/www/webkit-gtk
# Tested with newer glib and libsoup than currently in homebrew (also in tap).
class Webkitgtk < Formula
  homepage 'http://webkitgtk.org/'
  url 'http://webkitgtk.org/releases/webkitgtk-1.10.2.tar.xz'
  sha1 '733ca23157eb8dd072d57becf325799c00bde630'

  depends_on 'pkg-config' => :build
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build

  depends_on :x11
  depends_on 'xz'
  depends_on 'zlib'
  depends_on 'libsoup'
  depends_on 'glib'
  depends_on 'gstreamer'
  depends_on 'gst-plugins-base'
  depends_on 'gtk-doc'
  depends_on 'icu4c'

  fails_with :clang do
    build 421
  end

  def install
    system 'sed -i -e "s/echo -n/\/bin\/echo -n/g" Source/WebCore/GNUmakefile.am'
    system 'sed -i -e "s/PLATFORM(MAC)/OS(DARWIN)/g" Source/WTF/wtf/InlineASM.h \
                Source/JavaScriptCore/heap/VTableSpectrum.cpp \
                Source/JavaScriptCore/jit/ThunkGenerators.cpp \
                Source/JavaScriptCore/tools/CodeProfile.cpp'
    system 'sed -i -e "s/OS(MAC_OS_X)/PLATFORM(MAC)/" Source/WTF/wtf/ThreadingPthreads.cpp'
    system "autoreconf -fvi -I Source/autotools"
    system "./configure", "--disable-debug",
                          "--disable-jit", # https://bugs.webkit.org/show_bug.cgi?id=99732
                          "--with-gtk=2.0", "--disable-webkit2",
                          "--prefix=#{prefix}"
    system "make install V=1"
  end

  def patches
    DATA
  end

end

__END__

--- a/configure.ac	2012-08-06 06:45:10.000000000 -0700
+++ b/configure.ac	2012-08-17 16:40:51.000000000 -0700
@@ -409,10 +409,6 @@ AC_MSG_RESULT([$with_unicode_backend])
 if test "$with_unicode_backend" = "icu"; then
     # TODO: use pkg-config (after CFLAGS in their .pc files are cleaned up)
     case "$host" in
-        *-*-darwin*)
-            UNICODE_CFLAGS="-I$srcdir/Source/JavaScriptCore/icu -I$srcdir/Source/WebCore/icu"
-            UNICODE_LIBS="-licucore"
-            ;;
         *-*-mingw*)
             UNICODE_CFLAGS=""
             UNICODE_LIBS="-licui18n -licuuc"
