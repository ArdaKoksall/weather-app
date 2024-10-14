# Weather App

A Flutter-based weather application that fetches the current weather based on the user's location and displays it with appropriate animations.

## Features

- Fetches current location using Geolocator.
- Retrieves weather data from OpenWeatherMap API.
- Displays weather information with Lottie animations based on weather conditions and time of day.

## Technologies Used

- Dart
- Flutter
- Geolocator
- HTTP
- Lottie

## Getting Started

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart SDK: Included with Flutter
- OpenWeatherMap API Key: [Get API Key](https://home.openweathermap.org/users/sign_up)

### Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/ArdaKoksall/weather-app.git
    cd weather-app
    ```

2. Install dependencies:
    ```sh
    flutter pub get
    ```

3. Add your OpenWeatherMap API key in the code:
    ```dart
    const String apiKey = 'YOUR_API_KEY';
    ```

### Running the App

1. Connect your device or start an emulator.
2. Run the app:
    ```sh
    flutter run
    ```

## Usage

- The app will automatically fetch the user's location and display the current weather.
- Weather conditions are displayed with appropriate Lottie animations.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.