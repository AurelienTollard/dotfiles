# Web browsers. Profiles, extensions and policies can be declared under each program.
{
  programs.google-chrome = {
    enable = true;
    # Use PipeWire (libcamera) for webcams: the IPU7 camera has no plain V4L2 node.
    commandLineArgs = [ "--enable-features=WebRtcPipeWireCamera" ];
  };
}
