# Weather Service Application
view:

## Technologies Used

### APIs & Packages
* **HTTP:** For internet/API connections.
* **Geolocator:** For retrieving location data to get weather info.

### Framework
* **Flutter:** Great for building iOS, Android, and web applications from a single codebase.

### UI
* **Animations:** Native animations without external dependencies.

---

## About the Project

I decided to add an in-app mobile simulator to the project to help desktop users visualize how the app looks. This allows users to switch between different mobile views without having to download a heavy external emulator or simulator.

I simply added the `http` and `geolocator` dependencies to my `pubspec.yaml` file and imported them into my `service.dart` file.

> **Note:** The Geolocator API provides extra information like latitude and longitude. This information might differ slightly from your device's native weather app. This is because mobile phones use native GPS, while this project fetches data from the OpenWeather API.

> **Permissions:** I configured the permission classes to ask users for their real location. Otherwise, system security (especially on Apple devices) might block the app or flag it as unsafe for the user.
