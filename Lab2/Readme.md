## Lab 2: Four Digit Hex Counter
- Build a four-digit (16-bit) counter to display its value on 7-segment displays 
- The counter module generates a 16-bit count value using bits 23 to 38 of the 39-bit binary counter at a frequency of 100 MHz / 223 ≈ 12 Hz with a complete cycle taking approximately 164 / 12 ≈ 5461 seconds or 91 minutes
- The binary counter bits 17 and 18 generate a 0 to 3 count sequence at a frequency of 100 MHz / 217 ≈ 763 Hz
- The sequence repeats at a frequency of approximately 763 Hz / 4 ≈ 191 Hz that is fast enough to eliminate any visual flicker in the displays.
- This multiplexing is fast enough (at least 60 complete cycles per second) to appear as if all four displays are continuously illuminated – each with their own four bits of information.
- The mpx output from the new counter module now drives the dig input of the leddec module.
- The mpx signal is also used to select which 4-bits of the 16-bit count output should be sent to the data input of the leddec module.
- By time multiplexing the 7-segment displays that share the same cathode lines (CA to CG), four different digits can appear on one display at a time.
  - Turn on display 0 for a few milliseconds by enabling its common anode AN0 and decoding count (0~3) to drive the cathode lines.
  - Switch to display 1 for a few milliseconds by turning off AN0, turning on AN1 and decoding count (4~7) to drive the cathode lines.
  - Shift to display 2 for a few milliseconds and then finally display 3 for a few milliseconds, after that go back and start again at display 0.
  - Each digit is thus illuminated only one quarter of the time

![Screenshot 2022-03-02 193307](https://user-images.githubusercontent.com/78381247/156476594-78df74cb-41a3-415b-b494-1d9a875361ea.png)
![IMG_0198 (1)](https://user-images.githubusercontent.com/78381247/156476741-9f74d1fa-abb4-47d5-8931-d4d8ddb4acb3.gif)
