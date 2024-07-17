# TwelveLakes <div style="float: left;"><img src="https://github.com/Wandersalamander/TwelveLakes/blob/master/resources/drawables/launcher_icon.png" width="40" height="40"/></div> 

TwelveLakes is a Garmin Glance app designed to provide detailed information about alpine lakes directly on your Garmin watch. By leveraging the Alplakes API, TwelveLakes displays one of twelve alpine lakes with essential details for outdoor enthusiasts, hikers, and nature lovers.

## Features

- **Simple Integration:** No API key required to access the Alplakes API.
- **Detailed Information:** Provides comprehensive data about each lake, including:
  - Geneva
  - Garda
  - Zurich
  - Lugano
  - Biel
  - Murten
  - Hallwil
  - Joux
  - Greifensee
  - Ageri
  - St. Moritz
  - Caldonazzo
- **User-Friendly Interface:** Optimized for Garmin watches supporting glances.
- **Real-Time Data:** Fetches the latest information from the Alplakes API.

## Installation

As this is an early version of the app, compilation for specific watches must be manually performed, and the app must be sideloaded onto the watch.

### Requirements

- A Garmin watch that supports glances.
- [Garmin SDK](https://developer.garmin.com/connect-iq/sdk/)

### Steps

1. Install the Garmin SDK.
2. Download this project.
3. Compile the project for your watch.
4. Sideload the `.PRG` file to the Garmin watch (to `GARMIN/APPS/`).

## Usage

1. Open the TwelveLakes app on your Garmin watch.
2. The app will automatically call the Alplakes API and display your favorite and the closest lake.
3. Use the watch interface to navigate and view detailed information.

## API Integration

TwelveLakes utilizes the Alplakes API to fetch real-time data about alpine lakes. The API does not require an API key, ensuring a seamless integration experience.

### Example API Call

The app makes a GET request to the Alplakes API endpoint, see:

[https://api.alplakes.com/lakes](https://www.alplakes.eawag.ch/api)

## Contributing

We welcome contributions from the community! If you'd like to contribute to TwelveLakes, please follow these steps:

1. Fork the repository.
2. Create a new branch: `git checkout -b feature-branch-name`.
3. Make your changes and commit them: `git commit -m 'Add some feature'`.
4. Push to the branch: `git push origin feature-branch-name`.
5. Create a pull request.

## Contact

If you have any questions, suggestions, or feedback, feel free to contact us via this GitHub page.

## Acknowledgements

- Thanks to the Alplakes API team for providing comprehensive and accessible data.
- Thanks to the Garmin Connect IQ team for their support and tools.

Enjoy exploring the beauty of alpine lakes with TwelveLakes on your Garmin watch!
