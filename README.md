# Pizza App

A Flutter food delivery app built with Firebase, BLoC state management, and a clean multi-package architecture.

---

## Demo


https://github.com/user-attachments/assets/c309eb35-09f8-469c-a1c4-ed2f2694a980


---

## Features

- **Authentication** — Sign up & sign in with Firebase Auth, with real-time password strength feedback
- **Menu browsing** — Browse pizzas, beverages, starters, and desserts fetched from Firestore
- **Product details** — View nutritional macros, spice level, veg/non-veg badge, and discounted pricing
- **Cart management** — Add, remove, increment, and decrement items with live total calculation
- **Checkout & payment** — Mock payment flow with an interactive credit card preview and input formatting
- **Persistent state** — BLoC-powered state across screens with proper provider scoping

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter |
| State management | flutter_bloc / BLoC |
| Backend | Firebase (Auth, Firestore, Storage) |
| Architecture | Clean architecture with local packages |
| Packages | `user_repository`, `pizza_repository` |

---

## Project Structure

```
pizza_app/
├── lib/
│   ├── blocs/              # Authentication BLoC
│   ├── components/         # Reusable widgets
│   └── screens/
│       ├── auth/           # Sign in / Sign up
│       ├── home/           # Pizza grid
│       ├── landing/        # Category hub & full menu
│       ├── cart/           # Cart management
│       ├── category/       # Filtered category view
│       └── payment/        # Checkout screen
└── packages/
    ├── pizza_repository/   # Firestore pizza data layer
    └── user_repository/    # Firebase Auth & user data layer
```

---

## Getting Started

### Prerequisites

- Flutter SDK `>=3.2.3`
- A Firebase project with Authentication, Firestore, and Storage enabled

### Setup

1. **Clone the repo**
   ```bash
   git clone https://github.com/your-username/pizza_app.git
   cd pizza_app
   ```

2. **Add Firebase config files**
   - Android: place `google-services.json` in `android/app/`
   - iOS: place `GoogleService-Info.plist` in `ios/Runner/`
   - Generate `lib/firebase_options.dart` with the FlutterFire CLI:
     ```bash
     flutterfire configure
     ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

---

## Firestore Data Model

The app reads from a `menu_items` collection. Each document should have:

```json
{
  "pizzaId": "string",
  "name": "string",
  "description": "string",
  "category": "pizza | beverage | starter | dessert",
  "picture": "url",
  "price": 12,
  "discount": 10,
  "isVeg": true,
  "spiceLevel": 1,
  "macros": {
    "calories": 300,
    "proteins": 12,
    "fats": 8,
    "carbs": 40
  }
}
```

---

