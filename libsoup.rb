require 'formula'

class Libsoup < Formula
  homepage 'http://live.gnome.org/LibSoup'
  url 'http://ftp.gnome.org/pub/GNOME/sources/libsoup/2.41/libsoup-2.41.5.tar.xz'
  sha256 'cb2baf5c190ef247369f35f42c5d54e7df4465b0d5d111147abf19d4f02b402b'

  depends_on 'xz' => :build
  depends_on 'glib-networking' # Required at runtime for TLS support
  depends_on 'gnutls' # Also required for TLS
  depends_on 'sqlite' # For SoupCookieJarSqlite

  fails_with :clang do
      build 421
      cause <<-EOS.undent
      coding-test.c:69:28: error: format string is not a string literal [-Werror,-Wformat-nonliteral]
          file = g_strdup_printf (file_path, path);
                                  ^~~~~~~~~

      The same error was encountered here:
      http://clang.debian.net/logs/2012-06-23/libsoup2.4_2.38.1-2_unstable_clang.log
      EOS
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-tls-check",
                          "--prefix=#{prefix}",
                          "--without-gnome"
    system "make install"
  end
end
