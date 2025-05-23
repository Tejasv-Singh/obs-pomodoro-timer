# OBS Pomodoro Timer 🍅⏰

A comprehensive 60-10 Pomodoro timer Lua script for OBS Studio, perfect for live streaming and productivity sessions. Features a visual progress bar, session counter, sound notifications, and full OBS integration.

![Pomodoro Timer Demo](https://img.shields.io/badge/OBS-Compatible-blue) ![Lua](https://img.shields.io/badge/Lua-Script-green) ![Linux](https://img.shields.io/badge/Arch_Linux-Compatible-orange)

## ✨ Features

- 🎯 **60-10 Pomodoro Cycle**: 60 minutes work, 10 minutes break
- 📊 **Visual Progress Bar**: Text-based progress indicator with `▓▓▓░░░` style
- 🔢 **Session Counter**: Tracks completed vs total sessions (e.g., "3/10 sessions")
- 🔔 **Sound Notifications**: Bell sound at the end of each session/break
- ⏸️ **Pause/Resume**: Full timer control during sessions
- 🎮 **Hotkey Support**: Keyboard shortcuts for all timer functions
- 🖥️ **OBS Integration**: Complete UI in OBS Scripts panel
- 🐧 **Linux Compatible**: Uses `paplay` for Arch Linux sound playback

## 📦 Installation

### Prerequisites
- OBS Studio (any recent version)
- Arch Linux with `paplay` installed (part of PulseAudio)
- Sound file (.wav or .mp3 format)

### Setup Steps

1. **Download the Script**
   ```bash
   wget https://raw.githubusercontent.com/YOUR_USERNAME/obs-pomodoro-timer/main/pomodoro_timer.lua
   ```

2. **Install in OBS Studio**
   - Open OBS Studio
   - Go to `Tools` → `Scripts`
   - Click the `+` button
   - Select `pomodoro_timer.lua`

3. **Create Text Sources in OBS**
   
   Create 4 text sources with these suggested names:
   - `Pomodoro Timer` - Displays countdown (e.g., "45:30")
   - `Pomodoro Label` - Shows current mode ("Work" or "Break")
   - `Session Counter` - Shows progress ("3/10 sessions")
   - `Progress Bar` - Visual progress indicator ("▓▓▓▓░░░░░░")

4. **Configure Script Properties**
   - In Scripts panel, select the Pomodoro Timer script
   - Set your text source names
   - Choose your sound file path
   - Set total sessions count
   - Click "Start Timer" to begin

## 🎮 Usage

### Control Buttons
- **Start Timer**: Begin the Pomodoro cycle
- **Pause/Resume Timer**: Pause or resume the current session
- **Reset Timer**: Reset to the beginning of a work session

### Hotkeys (Optional)
You can assign keyboard shortcuts for:
- Start Pomodoro Timer
- Pause/Resume Pomodoro Timer
- Reset Pomodoro Timer

### Session Flow
1. Timer starts with 60:00 work session
2. Countdown displays live time remaining
3. Progress bar fills as time progresses
4. Bell sound plays when session ends
5. Automatically switches to 10:00 break
6. After break, returns to work session
7. Session counter increments after each work period

## ⚙️ Customization

### Modify Timer Durations
Edit these variables in the script:
```lua
local WORK_DURATION = 60 * 60  -- 60 minutes in seconds
local BREAK_DURATION = 10 * 60 -- 10 minutes in seconds
```

### Customize Progress Bar
Change the progress bar appearance:
```lua
-- Current: ▓▓▓▓░░░░░░
-- You can use: ████▒▒▒▒▒▒ or ■■■■□□□□□□ or any characters you prefer
local progress_text = string.rep("▓", filled_chars) .. string.rep("░", empty_chars)
```

### Different Sound Commands
For other Linux distributions or sound systems:
```lua
-- ALSA: aplay instead of paplay
local command = string.format("aplay '%s' &", sound_file_path)

-- macOS: afplay
local command = string.format("afplay '%s' &", sound_file_path)
```

## 🎨 OBS Scene Setup Examples

### Minimal Setup
```
┌─────────────────────────┐
│        Live Stream      │
│                         │
│  Work     45:30    3/8  │
│  ▓▓▓▓▓▓░░░░░░░░░░░░░░   │
└─────────────────────────┘
```

### Sidebar Layout
```
┌────────────────┬────────┐
│                │ FOCUS  │
│   Main Content │ Work   │
│                │ 45:30  │
│                │ 3/8    │
│                │▓▓▓▓░░░ │
└────────────────┴────────┘
```

## 🔧 Troubleshooting

### Sound Not Playing
- Ensure `paplay` is installed: `pacman -S pulseaudio-utils`
- Test sound file manually: `paplay your_sound_file.wav`
- Check file path is absolute: `/home/user/sounds/bell.wav`

### Text Sources Not Updating
- Verify text source names match exactly (case-sensitive)
- Ensure sources exist before starting the script
- Check OBS Studio logs for any error messages

### Timer Not Starting
- Check that all required text sources are created
- Look for script errors in OBS Tools → Scripts → Script Log

## 📁 File Structure

```
obs-pomodoro-timer/
├── pomodoro_timer.lua      # Main script file
├── README.md              # This file
├── sounds/                # Recommended sound files location
│   ├── bell.wav
│   └── chime.mp3
└── screenshots/           # Demo images (optional)
    └── obs_setup.png
```

## 🤝 Contributing

Contributions are welcome! Here are some ideas:

- [ ] Add support for custom Pomodoro ratios (25-5, 45-15, etc.)
- [ ] Multiple sound options for different session types
- [ ] Integration with productivity apps
- [ ] Statistics tracking and export
- [ ] Different progress bar styles (circular, percentage, etc.)
- [ ] Theme support for different visual styles

### How to Contribute
1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes and test thoroughly
4. Commit your changes: `git commit -m "Add feature description"`
5. Push to your branch: `git push origin feature-name`
6. Create a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built for the OBS Studio community
- Inspired by the Pomodoro Technique by Francesco Cirillo
- Sound notification system optimized for Arch Linux

## 📞 Support

If you encounter any issues or have questions:

1. Check the [Troubleshooting](#-troubleshooting) section
2. Look through existing [Issues](https://github.com/YOUR_USERNAME/obs-pomodoro-timer/issues)
3. Create a new issue with:
   - Your OBS Studio version
   - Operating system details
   - Description of the problem
   - Steps to reproduce

---

**Happy streaming and productive Pomodoro sessions! 🍅✨**
