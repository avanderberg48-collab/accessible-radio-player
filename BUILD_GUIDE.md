# How to Build the Accessible Radio Player APK

This guide provides multiple methods to build the APK for the Accessible Radio Player app.

## Method 1: Using Codemagic (Recommended - Free)

Codemagic offers free builds for Flutter apps with GitHub integration.

### Steps:

1. **Sign up for Codemagic**
   - Visit: https://codemagic.io/signup
   - Sign up with your GitHub account (free)

2. **Add the Repository**
   - Click "Add application"
   - Select "GitHub"
   - Choose the repository: `accessible-radio-player`

3. **Configure Build**
   - The `codemagic.yaml` file is already in the repository
   - Codemagic will automatically detect it

4. **Start Build**
   - Click "Start new build"
   - Select "master" branch
   - Wait for the build to complete (usually 10-15 minutes)

5. **Download APK**
   - Once complete, click on the build
   - Go to "Artifacts" tab
   - Download `app-release.apk`

## Method 2: Using AppCircle (Alternative Free Option)

AppCircle also provides free Flutter builds.

### Steps:

1. **Sign up for AppCircle**
   - Visit: https://appcircle.io/
   - Create a free account

2. **Connect Repository**
   - Click "Add New App"
   - Connect your GitHub account
   - Select the `accessible-radio-player` repository

3. **Configure Build Profile**
   - Platform: Android
   - Build Mode: Release
   - Flutter Version: 3.24.5

4. **Start Build**
   - Click "Start Build"
   - Wait for completion

5. **Download APK**
   - Download from the Artifacts section

## Method 3: Local Build (If you have a computer)

If you have access to a Windows, Mac, or Linux computer:

### Prerequisites:
- Install Flutter SDK: https://docs.flutter.dev/get-started/install
- Install Android Studio: https://developer.android.com/studio

### Steps:

1. **Clone the Repository**
   ```bash
   git clone https://github.com/avanderberg48-collab/accessible-radio-player.git
   cd accessible-radio-player
   ```

2. **Get Dependencies**
   ```bash
   flutter pub get
   ```

3. **Build APK**
   ```bash
   flutter build apk --release
   ```

4. **Find APK**
   - Location: `build/app/outputs/flutter-apk/app-release.apk`

## Method 4: Using GitHub Codespaces (Online, Free)

GitHub Codespaces provides a free online development environment.

### Steps:

1. **Open Repository in Codespaces**
   - Go to: https://github.com/avanderberg48-collab/accessible-radio-player
   - Click the green "Code" button
   - Select "Codespaces" tab
   - Click "Create codespace on master"

2. **Install Flutter in Codespace**
   ```bash
   git clone https://github.com/flutter/flutter.git -b stable
   export PATH="$PATH:`pwd`/flutter/bin"
   flutter doctor
   ```

3. **Install Android SDK**
   ```bash
   mkdir -p android-sdk/cmdline-tools
   cd android-sdk/cmdline-tools
   wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
   unzip commandlinetools-linux-11076708_latest.zip
   mv cmdline-tools latest
   cd ../../
   export ANDROID_SDK_ROOT=$PWD/android-sdk
   export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin
   ```

4. **Accept Licenses and Install Build Tools**
   ```bash
   sdkmanager --licenses
   sdkmanager "platform-tools" "platforms;android-36" "build-tools;36.0.0"
   ```

5. **Build APK**
   ```bash
   cd accessible-radio-player
   flutter pub get
   flutter build apk --release
   ```

6. **Download APK**
   - Right-click on `build/app/outputs/flutter-apk/app-release.apk`
   - Select "Download"

## Troubleshooting

### Build Fails with Gradle Error
- Ensure you're using Java 17
- Clear Gradle cache: `flutter clean`

### SDK License Error
- Run: `flutter doctor --android-licenses`
- Accept all licenses

### Out of Memory Error
- Add to `android/gradle.properties`:
  ```
  org.gradle.jvmargs=-Xmx2048m
  ```

## Repository Link

https://github.com/avanderberg48-collab/accessible-radio-player

## Support

If you encounter issues, please open an issue on the GitHub repository.
