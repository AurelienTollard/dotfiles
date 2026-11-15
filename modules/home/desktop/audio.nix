# EasyEffects speaker tuning for the Galaxy Book6 Pro's down-firing speakers.
#
# The CS35L57 amps already load Samsung's protection/calibration firmware, but Linux
# lacks the Dolby layer Windows adds on top. This preset stands in for it:
#   EQ (high-pass + tone + resonance notches) -> bass enhancer -> compressor -> limiter
#
# Bands 5-7 are free notch slots for chassis resonances: find a rattling frequency
# (EasyEffects > Test Signals, or a sine sweep), then set a band there with negative gain.
# Tweaks made in the GUI are live but not saved here; copy final values back into this file.
{ config, lib, ... }:
let
  band = type: frequency: gain: q: {
    inherit
      type
      frequency
      gain
      q
      ;
    mode = "RLC (BT)";
    slope = if type == "Hi-pass" then "x2" else "x1";
    solo = false;
    mute = false;
    width = 4.0;
  };

  bands = {
    band0 = band "Hi-pass" 150.0 0.0 0.707; # spare the drivers bass they can't play (main rattle cause)
    band1 = band "Bell" 450.0 (-2.0) 1.2; # tame laptop "boxiness"
    band2 = band "Bell" 3000.0 2.0 1.0; # presence / vocal clarity
    band3 = band "Hi-shelf" 8000.0 2.0 0.707; # air (speakers face the desk)
    band4 = band "Off" 1000.0 0.0 1.0;
    band5 = band "Bell" 800.0 0.0 6.0; # resonance notch slot 1
    band6 = band "Bell" 1200.0 0.0 6.0; # resonance notch slot 2
    band7 = band "Bell" 1600.0 0.0 6.0; # resonance notch slot 3
  };
in
{
  options.galaxybook.speakers.enable = lib.mkEnableOption "EasyEffects speaker tuning for the Galaxy Book6 Pro (enable per host)";

  config = lib.mkIf config.galaxybook.speakers.enable {
    services.easyeffects = {
      enable = true;
      preset = "galaxybook-speakers";

      extraPresets.galaxybook-speakers.output = {
        blocklist = [ ];
        plugins_order = [
          "equalizer#0"
          "bass_enhancer#0"
          "compressor#0"
          "limiter#0"
        ];

        "equalizer#0" = {
          bypass = false;
          input-gain = -3.0; # headroom for the boosts
          output-gain = 0.0;
          mode = "IIR";
          num-bands = 8;
          split-channels = false;
          left = bands;
          right = bands;
        };

        # Psychoacoustic bass: adds harmonics so you "hear" lows the speakers can't reproduce.
        "bass_enhancer#0" = {
          bypass = false;
          input-gain = 0.0;
          output-gain = 0.0;
          amount = 6.0;
          harmonics = 8.5;
          scope = 150.0;
          blend = 0.0;
          floor = 20.0;
          floor-active = false;
        };

        # Even out loudness so quiet parts are audible without cranking the volume.
        "compressor#0" = {
          bypass = false;
          input-gain = 0.0;
          output-gain = 0.0;
          mode = "Downward";
          threshold = -18.0;
          ratio = 3.0;
          attack = 10.0;
          release = 150.0;
          knee = -6.0;
          makeup = 4.0;
          dry = -80.0;
          wet = 0.0;
        };

        # Brick wall so nothing clips into the amps.
        "limiter#0" = {
          bypass = false;
          input-gain = 0.0;
          output-gain = 0.0;
          mode = "Herm Thin";
          threshold = -1.0;
          lookahead = 5.0;
          attack = 5.0;
          release = 20.0; # plugin max
        };
      };
    };
  };
}
