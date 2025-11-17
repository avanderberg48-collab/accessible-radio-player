# Accessible Radio Player - User Guide

## Welcome!

Thank you for using the Accessible Radio Player! This app was designed specifically with accessibility in mind, providing full support for blind and visually impaired users.

## Features

### 📻 Radio Streaming
- Stream online radio stations from anywhere in the world
- Support for MP3, AAC, and other common streaming formats
- Stable playback with buffering management

### 📝 Station Management
- Add unlimited radio stations
- Edit station names and URLs
- Delete stations you no longer need
- Mark favorites for quick access

### 🎙️ Recording
- Record live radio streams
- Save recordings to your device
- Manage and delete old recordings
- High-quality audio recording

### ♿ Accessibility
- Full Text-to-Speech (TTS) support
- Compatible with Android TalkBack
- Large, easy-to-tap buttons
- High contrast interface
- Voice announcements for all actions

## Getting Started

### Installation

1. Download the APK file
2. On your Android device, go to **Settings → Security**
3. Enable **Install from Unknown Sources**
4. Open the APK file and tap **Install**
5. Grant all requested permissions for full functionality

### First Launch

When you first open the app, you'll see two default radio stations:
- BBC Radio 1
- NPR News

You can play these immediately or add your own stations.

## How to Use

### Adding a Radio Station

1. From the home screen, tap the **"Add Station"** button (bottom right)
2. Enter the **Station Name** (e.g., "My Favorite Radio")
3. Enter the **Stream URL** (e.g., "http://stream.example.com/radio.mp3")
4. Tap **"Add Station"**

**Finding Stream URLs:**
- Visit the radio station's website
- Look for "Listen Live" or "Stream URL"
- Copy the direct link (usually ends in .mp3, .aac, or .pls)

### Playing a Station

1. From the home screen, tap on any station
2. The player will open and start playing automatically
3. Use the large play/pause button to control playback

### Recording a Station

1. While a station is playing, tap **"Start Recording"**
2. A red indicator will show that recording is active
3. Tap **"Stop Recording"** when finished
4. Your recording is automatically saved

### Viewing Recordings

1. From the home screen, tap the **menu icon** (top right)
2. Select **"Recordings"**
3. See all your saved recordings with date and file size
4. Tap a recording to select it
5. Use the delete button to remove unwanted recordings

### Editing a Station

1. From the home screen, find the station you want to edit
2. Tap the **three-dot menu** (⋮) next to the station
3. Select **"Edit"**
4. Update the name or URL
5. Tap **"Update Station"**

### Deleting a Station

1. From the home screen, find the station you want to delete
2. Tap the **three-dot menu** (⋮) next to the station
3. Select **"Delete"**
4. Confirm the deletion

### Marking Favorites

1. Tap the **heart icon** next to any station
2. The heart will turn red to indicate it's a favorite
3. Tap again to remove from favorites

## Accessibility Features

### For TalkBack Users

The app is fully compatible with Android TalkBack:

1. **Enable TalkBack**: Settings → Accessibility → TalkBack
2. **Navigate**: Swipe left/right to move between elements
3. **Activate**: Double-tap to select
4. **Listen**: The app announces all actions and screen changes

### Voice Announcements

The app provides voice feedback for:
- Screen navigation ("Navigated to Home screen")
- Station selection ("Selected BBC Radio 1")
- Playback status ("Playing BBC Radio 1", "Paused")
- Recording status ("Recording started", "Recording stopped")
- Actions completed ("Station added successfully")
- Errors ("Error: Failed to play station")

### Large Text Support

The app respects your device's text size settings:
- Go to **Settings → Display → Font size**
- Increase the text size
- The app will automatically adjust

## Permissions

The app requires the following permissions:

- **Internet**: To stream online radio
- **Microphone**: To record radio streams
- **Storage**: To save recordings
- **Foreground Service**: To keep playing in the background
- **Wake Lock**: To prevent the device from sleeping during playback

## Tips and Tricks

### Finding Radio Stations

**Popular Sources:**
- **TuneIn**: https://tunein.com
- **Radio Garden**: http://radio.garden
- **Internet Radio**: https://www.internet-radio.com

**How to Get Stream URLs:**
1. Visit the radio station's website
2. Right-click on "Listen Live" button
3. Select "Copy Link Address"
4. Paste into the app

### Saving Data

- Radio streams use data - connect to Wi-Fi when possible
- A typical stream uses about 1 MB per minute
- Recordings are saved locally and don't use cloud storage

### Battery Optimization

- The app may be stopped by aggressive battery savers
- Go to **Settings → Battery → Battery Optimization**
- Find "Accessible Radio Player"
- Select "Don't optimize"

## Troubleshooting

### Station Won't Play

**Possible Solutions:**
- Check your internet connection
- Verify the stream URL is correct
- Try a different station to test
- Some stations may be geo-restricted

### Recording Not Working

**Possible Solutions:**
- Grant microphone permission in app settings
- Check available storage space
- Ensure the station is playing before recording

### App Stops in Background

**Possible Solutions:**
- Disable battery optimization for the app
- Check that foreground service permission is granted
- Some devices have aggressive task killers - check manufacturer settings

### No Sound

**Possible Solutions:**
- Check device volume
- Ensure media volume (not ringtone) is up
- Try restarting the app
- Check if other apps can play audio

### TalkBack Not Working

**Possible Solutions:**
- Ensure TalkBack is enabled in device settings
- Restart the app after enabling TalkBack
- Check TalkBack volume settings

## Frequently Asked Questions

**Q: Can I use this app offline?**
A: No, the app requires an internet connection to stream radio. However, you can play saved recordings offline.

**Q: How much storage do recordings use?**
A: Approximately 1 MB per minute of recording, depending on quality.

**Q: Can I share my stations with friends?**
A: Currently, you need to manually share the stream URL. A future update may add station export.

**Q: Does the app work on tablets?**
A: Yes, the app works on any Android device running Android 5.0 or later.

**Q: Can I play in the background?**
A: Yes, the app continues playing when you switch to other apps or lock your screen.

**Q: Is my data private?**
A: Yes, all stations and recordings are stored locally on your device. No data is sent to external servers.

## Support

If you encounter issues or have suggestions:
- Open an issue on GitHub: https://github.com/avanderberg48-collab/accessible-radio-player
- Check the BUILD_GUIDE.md for technical help

## Credits

Developed with accessibility in mind for the blind and visually impaired community.

Built with Flutter and open-source libraries:
- just_audio - Audio playback
- flutter_tts - Text-to-speech
- record - Audio recording
- provider - State management

## Version

Version 1.0.0 - Initial Release

---

Enjoy your accessible radio experience! 📻♿
