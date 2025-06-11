# PIYP - Photos In Your Pocket

A modern, cross-platform mobile and desktop application to organize your photo library from any web source (WebDAV support). Built with Flutter for seamless multi-platform experience.

## ✨ Features

- 📱 **Cross-platform**: Runs on iOS, Android, macOS, Windows, and Linux
- 🌐 **WebDAV Support**: Connect to any WebDAV server (Nextcloud, ownCloud, etc.)
- 🖼️ **Smart Gallery**: Grid view with date-based organization
- 🗂️ **EXIF Data**: Automatic extraction and display of photo metadata
- 📍 **GPS Support**: View photo locations on an interactive map
- 🎬 **Video Support**: Play and organize videos alongside photos
- 💾 **Local Caching**: Efficient thumbnail generation and caching
- 🔄 **Auto-sync**: Automatic synchronization with remote sources
- 🌙 **Dark/Light Theme**: Follows system theme preferences
- 🚀 **Modern UI**: Clean, Material Design 3 interface

## 🚀 Getting Started

### Prerequisites

First install the required tools:

- [Bash (v5)](https://www.gnu.org/software/bash/)
- [mise](https://mise.jdx.dev/) (for development environment management)

### Development Setup

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/piyp.git
   cd piyp
   ```

2. **Install development tools**

   ```bash
   mise plugins install android-sdk https://github.com/Syquel/mise-android-sdk.git
   mise install java yq jq  # Install first as they are required by other tools
   mise install
   ```

3. **Configure Android (if building for Android)**

   ```bash
   sdkmanager "platform-tools" "build-tools;33.0.3" "platforms;android-33"
   yes | flutter doctor --android-licenses
   ```

4. **Install dependencies**

   ```bash
   flutter pub get
   ```

5. **Generate database code**
   ```bash
   dart run build_runner build
   ```

### Running the App

```bash
flutter run
```

For specific platforms:

```bash
flutter run -d macos     # macOS
flutter run -d windows   # Windows
flutter run -d linux     # Linux
flutter run -d chrome    # Web (for development)
```

## 📱 Setting Up Your Photo Source

1. **Launch PIYP** and navigate to Settings
2. **Add WebDAV Server** with your credentials:
   - Server Name: Give it a memorable name
   - Server URL: Your WebDAV endpoint (e.g., `https://cloud.example.com/remote.php/dav/files/username/`)
   - Username: Your WebDAV username
   - Password: Your WebDAV password
   - Folder Path: Optional subfolder path
3. **Test Connection** and start syncing your photos!

### Supported WebDAV Providers

- ✅ Nextcloud
- ✅ ownCloud
- ✅ Box.com
- ✅ pCloud
- ✅ Any standard WebDAV server

## 🛠️ Development

### Project Structure

```
lib/
├── main.dart              # App entry point
├── router.dart           # Navigation configuration
├── database/             # Database schema and queries
├── classes/              # Data models
├── settings/             # Settings and configuration
└── [other_features]/     # Feature-specific modules
```

### Building for Production

**Android APK:**

```bash
flutter build apk --release
```

**iOS App:**

```bash
flutter build ios --release
```

**Desktop Apps:**

```bash
flutter build macos --release    # macOS
flutter build windows --release  # Windows
flutter build linux --release    # Linux
```

## 🐛 Troubleshooting

### Android Emulator Setup

Create and launch an Android emulator:

```bash
sdkmanager "system-images;android-33;google_apis;x86_64"
avdmanager create avd --name Pixel_8_Pro_AVD --package "system-images;android-33;google_apis;x86_64" --device "pixel_8_pro"
flutter emulators --launch Pixel_8_Pro_AVD
```

### Gradle Issues

If you encounter Gradle-related errors:

```bash
rm -rf ~/.gradle/ ~/.pub-cache
flutter clean
flutter pub get
```

### Flutter Installation

For Flutter installation issues, refer to:

- [Official Flutter Installation Guide](https://docs.flutter.dev/get-started/install)
- [asdf-flutter Troubleshooting](https://github.com/asdf-community/asdf-flutter?tab=readme-ov-file#troubleshooting)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- WebDAV community for the protocol specification
- All contributors who make this project better
