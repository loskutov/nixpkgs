{ stdenv, fetchFromGitHub, cmake, enableShared ? true }:

stdenv.mkDerivation rec {
  version = "5.2.1";
  name = "fmt-${version}";

  src = fetchFromGitHub {
    owner = "fmtlib";
    repo = "fmt";
    rev = "${version}";
    sha256 = "1cd8yq8va457iir1hlf17ksx11fx2hlb8i4jml8gj1875pizm0pk";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DFMT_TEST=TRUE"
    "-DBUILD_SHARED_LIBS=${if enableShared then "TRUE" else "FALSE"}"
  ];

  enableParallelBuilding = true;

  doCheck = true;
  # preCheckHook ensures the test binaries can find libfmt.so.5
  preCheck = if enableShared
             then "export LD_LIBRARY_PATH=\"$PWD\""
             else "";

  meta = with stdenv.lib; {
    description = "Small, safe and fast formatting library";
    longDescription = ''
      fmt (formerly cppformat) is an open-source formatting library. It can be
      used as a fast and safe alternative to printf and IOStreams.
    '';
    homepage = http://fmtlib.net/;
    downloadPage = https://github.com/fmtlib/fmt/;
    maintainers = [ maintainers.jdehaas ];
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
