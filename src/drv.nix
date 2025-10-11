{ lib, python3Packages }:

let
  pname = "nfsm";
in
python3Packages.buildPythonApplication {
  inherit pname;
  version = "0.0.1";
  pyproject = false;
  propagatedBuildInputs = [ ];
  dontUnpack = true;
  installPhase = "install -Dm755 ${./${pname}.py} $out/bin/${pname}";

  meta = {
    description = "Niri FullScreen Manager Daemon (nfsm)";
    homepage = "https://github.com/gvolpe/nfsm";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ gvolpe ];
    mainProgram = pname;
    platforms = lib.platforms.linux;
  };
}
