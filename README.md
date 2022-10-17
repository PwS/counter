## Counter
Variant For Example Flutter Apps (Counter)

## File or Application needed
* [Visual Studio Code](https://code.visualstudio.com/) - Editor
* [Android Studio](https://developer.android.com/studio) - IDE
* [Chocolatey](https://chocolatey.org/) - Package Manager
* [Dart](https://dart.dev/) - Language For Logic
* [Flutter](https://flutter.dev/) - Framework

## Structure Tree
# Counter App (Bloc & Cubit)
```bash
├── lib
    ├── blocs
    │   └── counter
    │       ├── counter_bloc.dart
    │       ├── counter_event.dart
    │       └── counter_state.dart
    ├── cubits
    │   ├── counter_cubit.dart
    │   └── counter_state.dart
    ├── main.dart
    ├── other_page.dart
    └── ui
        ├── ui_counter_bloc.dart
        └── ui_counter_cubit.dart
```

# Counter App (Listen To Connection Status)
```bash
   ├── lib
       ├── logic
       │   └── cubit
       │       ├── counter_cubit.dart
       │       ├── counter_state.dart
       │       └── internet
       │           ├── internet_cubit.dart
       │           └── internet_state.dart
       ├── main.dart
       └── presentation
           ├── router
           │   └── app_router.dart
           └── screens
               ├── home_screen.dart
               ├── second_screen.dart
               └── third_screen.dart
```

# Counter App (With RxDart)
```bash
├── lib
    ├── main.dart
    ├── state_management
    │   └── counter_rx
    │       └── counter_rx.dart
    └── ui
        └── my_home_page.dart
```
