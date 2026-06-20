{inputs, ...}: {
  imports = [
    inputs.bongocat.homeModule.default
  ];
  programs.wayland-bongocat = {
    enable = true;
    autostart = true;
    inputDevices = [
      "/dev/input/event0"
      "/dev/input/event3"
      "/dev/input/event13"
    ];
    overlayPosition = "bottom";
    overlayHeight = 300;

    catXOffset = 520;
    catYOffset = 0;
    catAlign = "center";
  };
}
