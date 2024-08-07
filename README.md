# NotesApp

**NotesApp** is a SwiftUI application that allows users to manage notes with functionalities including login with email/password, Google sign-in, and note-taking. It integrates Firebase for authentication and data storage.

## Features

- **Email/Password Authentication**: Users can log in using their email and password.
- **Google Sign-In**: Users can sign in with their Google account.
- **Note Management**: Users can create, edit, delete, and view notes. Each note has a content field and a date associated with it.

## Requirements

- Xcode 13 or later
- iOS 13.0 or later
- CocoaPods for dependency management

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/mpaliichuk/NotesApp.git
cd NotesApp
```

### 2. Set Up Firebase

1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Create a new project or use an existing one.
3. Add an iOS app to your Firebase project and follow the instructions to download `GoogleService-Info.plist`.
4. Add the `GoogleService-Info.plist` to your Xcode project.

### 3. Install CocoaPods Dependencies

1. Ensure you have CocoaPods installed. If not, install it via:

   ```bash
   sudo gem install cocoapods
   ```

2. Navigate to the project directory and set up the CocoaPods dependencies:

   - Create or update the `Podfile` in your project directory with the following content:

     ```ruby
     # Uncomment the next line to define a global platform for your project
     platform :ios, '13.0'

     target 'EmailPassLogin' do
       # Comment the next line if you don't want to use dynamic frameworks
       use_frameworks!

       # Pods for EmailPassLogin
       pod 'FirebaseCore'
       pod 'FirebaseAuth'
       pod 'GoogleSignIn'
       pod 'Firebase/Firestore'
     end
     ```

3. Install the dependencies:

   ```bash
   pod install
   ```

   This will create an `.xcworkspace` file.

4. Open the `.xcworkspace` file in Xcode:

   ```bash
   open EmailPassLogin.xcworkspace
   ```

## Usage

### Running the App

1. Open `EmailPassLogin.xcworkspace` in Xcode.
2. Select the target device or simulator.
3. Press the `Run` button (or `Cmd + R`) to build and run the app.

### Authentication

- **Email/Password Login**: Enter your email and password to log in.
- **Google Sign-In**: Click on the "Sign in with Google" button and follow the authentication flow.

### Notes Management

- **Create a Note**: Enter content in the "Enter your note here..." field and click the plus icon.
- **Edit a Note**: Click the pencil icon to edit the note.
- **Delete a Note**: Click the trash icon to delete the note.
