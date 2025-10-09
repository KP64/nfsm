{ libnotify, socat, writeShellApplication }:

writeShellApplication {
  name = "nfsm-cli";
  runtimeInputs = [ libnotify socat ];
  text = ''
    SOCKET=''${NFSM_SOCKET:-/run/user/1000/nfsm.sock}
    trap 'notify-send --icon="${./assets/icon.png}" --app-name="NFSM" "Niri FullScreen Manager" "Failed to connect to NFSM_SOCKET: $SOCKET" && niri msg action fullscreen-window' ERR
    echo 'FullscreenRequest' | socat - UNIX-CONNECT:"$SOCKET"
  '';
}
