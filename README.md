# Matrimonial App Simulation

This iOS app simulates a matrimonial platform, designed to showcase user match cards similar to those found on Shaadi.com. The app uses the provided API to fetch and display user profiles, allowing users to accept or decline matches. It is built with SwiftUI for a modern, responsive interface and incorporates offline persistence using local storage.

## Features

- **Remote User Fetching**: Integrates with the [RandomUser API](https://randomuser.me/api/?results=10) to fetch user profiles.
- **Infinite Scroll**: Implements infinite scrolling to load additional user profiles as the user scrolls through the list.
- **Match Cards**: User profiles are displayed as cards with images, basic details, and action buttons (Accept and Decline). 
- **Offline Persistence**: User actions (Accept/Decline) are stored locally using Swift Data. The app seamlessly handles offline mode, allowing users to interact with profiles without an internet connection.
- **Error Handling**: Robust error handling for API calls, local storage, and network connectivity.

## Architecture

The app follows the **Model-View-ViewModel (MVVM)** architecture to ensure clean separation of concerns, making the codebase easier to maintain and scale. 

## Libraries Used

- **Nuke**: For efficient image loading and caching.
- **SwiftData**: For offline caching and persistent local storage.
- **Combine**: For managing data flow and providing better error handling in asynchronous operations.

## Tools & Technologies

- **Xcode 16 (Beta)**: Developed using the latest version to leverage new features.
- **Swift 5**: The app is written entirely in Swift.
- **Postman**: Utilized for testing API calls.
- **Git**: Version control for tracking progress and collaboration.

## Requirements

- **iOS Version**: The app supports a minimum deployment version of **iOS 17** due to its reliance on SwiftData.
- **Xcode**: Requires **Xcode 16 (Beta)** for building and running the project. It may not be compatible with earlier versions of Xcode.

## Setup & Installation

1. **Clone the Repository**:
   ```bash
   git clone <repository-link>
   ```
2. Open in Xcode: Open the project in Xcode 16 (Beta).
3. Run the App: Build and run the app on a device or simulator with iOS 17 or higher.
