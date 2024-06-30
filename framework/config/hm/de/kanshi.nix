{
  outputDevice
, outputFreq
, outputHeight
, outputScale
, outputWidth
, outputDeviceLeft
, outputFreqLeft
, outputHeightLeft
, outputScaleLeft
, outputWidthLeft
, outputDeviceRight
, outputFreqRight
, outputHeightRight
, outputScaleRight
, outputWidthRight
, ...
}:

{
  services.kanshi = {
    enable = true;
    settings = [
      {
        profile.name = "laptop";
        profile.outputs = [
          {
            criteria = outputDevice;
            status = "enable";
            mode = "${outputWidth}x${outputHeight}@${outputFreq}Hz";
            position = "0,0";
            scale = builtins.fromJSON outputScale;
          }
        ];
      }
      {
        profile.name = "left-lg";
        profile.outputs = [
          {
            criteria = outputDeviceLeft;
            status = "enable";
            mode = "${outputWidthLeft}x${outputHeightLeft}@${outputFreqLeft}Hz";
            position = "0,0";
            scale = builtins.fromJSON outputScaleLeft;
          }
          {
            criteria = outputDevice;
            status = "enable";
            mode = "${outputWidth}x${outputHeight}@${outputFreq}Hz";
            position = "${outputWidthLeft},0";
            scale = builtins.fromJSON outputScale;
          }
        ];
      }
      {
        profile.name = "right-lg";
        profile.outputs = [
          {
            criteria = outputDevice;
            status = "enable";
            mode = "${outputWidth}x${outputHeight}@${outputFreq}Hz";
            position = "0,0";
            scale = builtins.fromJSON outputScale;
          }
          {
            criteria = outputDeviceRight;
            status = "enable";
            mode = "${outputWidthRight}x${outputHeightRight}@${outputFreqRight}Hz";
            position = "${outputWidth},0";
            scale = builtins.fromJSON outputScaleRight;
          }
        ];
      }
      {
        profile.name = "dual-lg";
        profile.outputs = [
          {
            criteria = outputDeviceLeft;
            status = "enable";
            mode = "${outputWidthLeft}x${outputHeightLeft}@${outputFreqLeft}Hz";
            position = "0,0";
            scale = builtins.fromJSON outputScaleLeft;
          }
          {
            criteria = outputDevice;
            status = "enable";
            mode = "${outputWidth}x${outputHeight}@${outputFreq}Hz";
            position = "${outputWidthLeft},0";
            scale = builtins.fromJSON outputScale;
          }
          {
            criteria = outputDeviceRight;
            status = "enable";
            mode = "${outputWidthRight}x${outputHeightRight}@${outputFreqRight}Hz";
            position = builtins.toString (builtins.fromJSON outputWidthLeft + builtins.fromJSON outputWidth) + ",0";
            scale = builtins.fromJSON outputScaleRight;
          }
        ];
      }
    ];
  };
}
