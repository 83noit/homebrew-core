class Pc6001vx < Formula
  desc "PC-6001 emulator"
  homepage "https://eighttails.seesaa.net/"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_3.8.0_src.tar.gz"
  sha256 "8e649062d410f565bbd92843766bd135676c7a1fc3cd1d941e967658cad17e3f"
  license "LGPL-2.1-or-later"
  head "https://github.com/eighttails/PC6001VX.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "aee07f4792310c51d12c85a460ec600468169c9b584c47f56b1980ef1ad2ab25"
    sha256 cellar: :any, big_sur:       "955a851714857a6316552a47e4456f1767c0031da42eb639f3bd256881f19633"
    sha256 cellar: :any, catalina:      "26437cbcb26ef046a957c42c6a3a2ba1c35ddd35680efb1c9bbeecdf628574ab"
    sha256 cellar: :any, mojave:        "84e0986b4d0db0802f75ed155e18b2fcf8305707ad031696179a51d28c2ff7b5"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "qt@5"
  depends_on "sdl2"

  def install
    # Need to explicitly set up include directories
    ENV.append_to_cflags "-I#{Formula["sdl2"].opt_include}"
    ENV.append_to_cflags "-I#{Formula["ffmpeg"].opt_include}"
    # Turn off errors on C++11 build which used for properly linking standard lib
    ENV.append_to_cflags "-Wno-reserved-user-defined-literal"
    # Use libc++ explicitly, otherwise build fails
    ENV.append_to_cflags "-stdlib=libc++" if ENV.compiler == :clang

    qt5 = Formula["qt@5"].opt_prefix
    system "#{qt5}/bin/qmake", "PREFIX=#{prefix}", "QMAKE_CXXFLAGS=#{ENV.cxxflags}", "CONFIG+=c++11"
    system "make"
    prefix.install "PC6001VX.app"
    bin.write_exec_script "#{prefix}/PC6001VX.app/Contents/MacOS/PC6001VX"
  end
end
