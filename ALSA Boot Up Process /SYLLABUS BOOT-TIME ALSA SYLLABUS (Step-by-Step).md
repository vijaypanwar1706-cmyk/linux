# BOOT-TIME ALSA SYLLABUS (Step-by-Step)

------

## 📍 PHASE 1: Linux Kernel Boot Basics (Audio Context)

⏱️ Day 1

### Topics

- Raspberry Pi 4 boot chain (GPU → kernel)
- Kernel decompression & early init
- `start_kernel()` overview
- Where **sound subsystem** sits in kernel init

### Outcome

✔️ पता चलेगा ALSA **boot में कहाँ enter करता है**

------

## 📍 PHASE 2: Device Tree & Audio Nodes

⏱️ Day 2

### Topics

- `bcm2711.dtb` loading
- WM8960 device tree overlay
- Audio related DT nodes:
  - `i2c`
  - `sound`
  - `codec`
  - `cpu-dai`
- `compatible = "wlf,wm8960"`

### Key Questions Answered

- Kernel को कैसे पता चलता है **WM8960 लगा है**
- DT vs driver matching कैसे होता है

------

## 📍 PHASE 3: ALSA Core Initialization (Kernel)

⏱️ Day 3

### Topics

- ALSA core entry point
- `sound/core/`
- Key structures:
  - `snd_card`
  - `snd_device`
- `snd_init()` role
- `/proc/asound` creation timing

### Logs to Track

```
dmesg | grep -i alsa
```

### Outcome

✔️ ALSA framework **ready state** में कैसे जाता है

------

## 📍 PHASE 4: ASoC Framework Boot Flow (MOST IMPORTANT)

⏱️ Day 4–5

### Topics

- What is ASoC and why needed
- ASoC components:
  - **CPU DAI** (BCM2835 I2S)
  - **Codec DAI** (WM8960)
  - **Machine driver**
- Boot order:
  1. Platform driver
  2. Codec driver
  3. Machine driver
- `snd_soc_register_card()`

### Kernel Paths

```
sound/soc/
 ├── soc-core.c
 ├── soc-dapm.c
 ├── soc-pcm.c
```

### Outcome

✔️ Sound card **bind होकर alive** कैसे होती है

------

## 📍 PHASE 5: WM8960 Codec Driver Boot Time

⏱️ Day 6

### Topics

- `wm8960.c` probe function
- I2C detection
- `regmap` initialization
- Codec reset sequence
- Default register programming

### Important Functions

- `wm8960_probe()`
- `snd_soc_component_register()`

### Outcome

✔️ WM8960 **power-up state में कैसे configure होता है**

------

## 📍 PHASE 6: I2S + Clock Setup During Boot

⏱️ Day 7

### Topics

- BCM2835 I2S init
- MCLK/BCLK/LRCLK setup
- Clock dependency order
- When clocks are **enabled vs idle**

### Outcome

✔️ Boot के समय clocks क्यों दिखते हैं लेकिन audio नहीं चलता

------

## 📍 PHASE 7: Sound Card Registration

⏱️ Day 8

### Topics

- `snd_card_register()`
- Card name assignment
- `/dev/snd/` node creation
- `card0`, `pcmC0D0p`

### Logs

```
dmesg | grep -i wm8960
dmesg | grep -i sound
```

### Outcome

✔️ Boot complete होते ही sound card ready क्यों दिखती है

------

## 📍 PHASE 8: Userspace ALSA Init (Boot Time Only)

⏱️ Day 9

### Topics

- `udev` rules for sound
- `/lib/udev/rules.d/`
- `alsactl restore` role
- When mixer defaults are applied

❌ Playback start नहीं
 ✅ Just state restore

------

## 📍 PHASE 9: Boot Log Tracing & Debugging

⏱️ Day 10

### Topics

- `printk()` placement
- `dynamic_debug`
- `earlycon`
- Time-stamping ALSA events

### Skills You Gain

✔️ हर ALSA step **time-wise map** कर पाओगे

------

# 🧪 Final Outcome (What You’ll Be Able To Explain)

आप confidently बता पाओगे:

- ALSA kernel में **exact कब initialize होता है**
- WM8960 **probe क्यों/कब fail करता है**
- Sound card boot में दिखती है लेकिन आवाज़ क्यों नहीं
- DT गलती हो तो boot में क्या break होता है
- ALSA vs ASoC boundary

------

# 📌 Next Step (Optional)

अगर आप चाहें तो अगला step मैं ऐसे कर सकता हूँ:

- **Actual boot log (dmesg) → line-by-line explanation**
- **WM8960 driver source walkthrough**
- **ALSA init timing measurement (ms level)**

बस बताइए 👍