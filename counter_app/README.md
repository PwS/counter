# counter_app: BLoC & Cubit

The Flutter counter written twice with `flutter_bloc`: once as a **Bloc** (events) and once as a
**Cubit** (methods). Reaching **3** shows a dialog, and reaching **−1** opens another page.

```bash
flutter pub get
flutter run
```

`lib/main.dart` runs the BLoC version. Use `runApp(const MyAppCubit())` for the Cubit version.

See the [main README](../README.md#1-counter_app-bloc--cubit) for the full walkthrough.
