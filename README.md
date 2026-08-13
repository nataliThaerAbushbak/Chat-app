# Chat App

A Flutter chat application with Firebase authentication and real-time
messaging. Users can create an account, sign in, view their conversations, and
send one-to-one messages stored in Cloud Firestore.

## Features

- Email and password registration
- Firebase Authentication sign in and sign out
- User profiles saved in Cloud Firestore
- Real-time chat message streams
- Conversation list for the signed-in user
- Light theme with custom app styling

## Tech Stack

- Flutter
- Dart
- Firebase Core
- Firebase Authentication
- Cloud Firestore
- GetX
- Provider

## Project Structure

```text
lib/
  controllers/       Authentication state and actions
  models/            App user and message models
  screens/Auth/      Login and registration screens
  screens/chats/     Chat list and chat conversation screens
  services/          Firebase auth and chat services
  theme/             App theme configuration
  main.dart          App entry point and auth routing
```

## Getting Started

1. Clone the repository.

   ```bash
   git clone https://github.com/nataliThaerAbushbak/Chat-app.git
   cd Chat-app
   ```

2. Install dependencies.

   ```bash
   flutter pub get
   ```

3. Configure Firebase for your target platforms.

   This project uses Firebase Authentication and Cloud Firestore. Make sure
   your Firebase project is connected and the platform configuration files are
   present before running the app.

4. Run the app.

   ```bash
   flutter run
   ```

## Firebase Data

The app stores user profiles in the `users` collection and chat data in the
`chats` collection. Each chat document contains participant IDs and a
`messages` subcollection for the conversation messages.

## Notes

- Enable Email/Password sign-in in Firebase Authentication.
- Create the required Cloud Firestore database before testing messages.
- Review Firestore security rules before using the app outside development.
