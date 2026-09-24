# Flutter Counter: State Management Examples (BLoC, Cubit, Streams & RxDart)

The classic Flutter **counter app**, built several ways so you can compare state management
approaches side by side. Each folder is a separate Flutter project that you can run on its own.

| Project | Approach | What it teaches |
| --- | --- | --- |
| [`counter_app`](#1-counter_app-bloc--cubit) | **BLoC** and **Cubit** (`flutter_bloc`) | Events vs. methods, `BlocConsumer`, reacting to state with dialogs and navigation |
| [`counter_stream`](#2-counter_stream-cubit--connectivity--routing) | **Cubit + StreamSubscription**, `connectivity_plus` | One Cubit listening to another, live connection status, sharing state across routes |
| [`counter_reactive`](#3-counter_reactive-rxdart) | **RxDart** `BehaviorSubject` + `StreamBuilder` | Reactive streams without any BLoC library |

## Table of contents

- [Prerequisites](#prerequisites)
- [Getting started](#getting-started)
- [Repository structure](#repository-structure)
- [1. counter_app: BLoC & Cubit](#1-counter_app-bloc--cubit)
- [2. counter_stream: Cubit + connectivity + routing](#2-counter_stream-cubit--connectivity--routing)
- [3. counter_reactive: RxDart](#3-counter_reactive-rxdart)
- [Comparing the approaches](#comparing-the-approaches)
- [Testing](#testing)
- [Known issues](#known-issues)

## Prerequisites

- **Flutter 3.x up to 3.7** (Dart 2.18 or 2.19). All three projects declare
  `sdk: '>=2.18.x <3.0.0'`, so Flutter 3.10+ (Dart 3) will refuse to run them unless you
  raise that constraint. Use [FVM](https://fvm.app/) to install an older version alongside
  your normal one, e.g. `fvm install 3.7.12`.
- An editor: [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)
  with the Flutter and Dart plugins.
- An emulator, simulator or physical device.

Check your setup with:

```bash
flutter doctor
```

## Getting started

```bash
git clone https://github.com/PwS/counter.git
cd counter

# pick one project
cd counter_app          # or counter_stream, counter_reactive
flutter pub get
flutter run
```

Each project is independent, so run `flutter pub get` in each folder you want to try.
In VS Code or Android Studio, open the **project folder** (e.g. `counter_app/`), not the
repository root, so the IDE finds its `pubspec.yaml`.

## Repository structure

```text
counter/
├── counter_app/          # BLoC & Cubit
│   └── lib/
│       ├── main.dart                 # Picks which version to run (BLoC by default)
│       ├── blocs/counter/            # CounterBloc: event, state, bloc
│       ├── cubits/                   # CounterCubit: state, cubit
│       ├── ui/
│       │   ├── ui_counter_bloc.dart  # App + home page using CounterBloc
│       │   └── ui_counter_cubit.dart # App + two home pages using CounterCubit
│       └── other_page.dart           # Page opened when the counter reaches -1
├── counter_stream/       # Cubit + connectivity + named routes
│   └── lib/
│       ├── main.dart                 # Provides both cubits above MaterialApp
│       ├── logic/cubit/
│       │   ├── counter_cubit.dart    # CounterCubit (listens to InternetCubit)
│       │   ├── counter_state.dart
│       │   └── internet/             # InternetCubit + states
│       └── presentation/
│           ├── router/app_router.dart  # '/', '/second', '/third'
│           └── screens/              # Home, Second, Third screens
└── counter_reactive/     # RxDart
    └── lib/
        ├── main.dart
        ├── state_management/counter_rx/counter_rx.dart  # BehaviorSubject-based counter
        └── ui/my_home_page.dart      # StreamBuilder UI
```

---

## 1. `counter_app`: BLoC & Cubit

The same counter written two ways with [`flutter_bloc`](https://pub.dev/packages/flutter_bloc),
so you can compare a **Bloc** (event-driven) with a **Cubit** (method-driven).

**Dependencies:** `flutter_bloc ^8.0.1`, `equatable ^2.0.3`

### Behaviour

- **+** / **−** buttons change the counter, which is shown in the middle of the screen.
- When the counter reaches **3**, a dialog shows "Counter is 3".
- When the counter reaches **−1**, the app navigates to **OtherPage**.

Both reactions use a `BlocConsumer`: `listener` handles one-off side effects (dialog,
navigation), and `builder` redraws the number.

### BLoC version (default)

| Part | File | Description |
| --- | --- | --- |
| Events | `blocs/counter/counter_event.dart` | `IncrementCounterEvent`, `DecrementCounterEvent` |
| State | `blocs/counter/counter_state.dart` | `CounterState(counter)`, with `initial()` and `copyWith()` |
| Bloc | `blocs/counter/counter_bloc.dart` | Handles each event with `on<Event>` and emits a new state |
| UI | `ui/ui_counter_bloc.dart` | `MyAppBloc` → `MyHomePageUsingBloc`, which sends events with `BlocProvider.of<CounterBloc>(context).add(...)` |

### Cubit version

| Part | File | Description |
| --- | --- | --- |
| State | `cubits/counter_state.dart` | Same shape as the BLoC state |
| Cubit | `cubits/counter_cubit.dart` | `increment()` and `decrement()` methods that call `emit` directly, with no events |
| UI | `ui/ui_counter_cubit.dart` | `MyAppCubit`, with two equivalent home pages |

The two Cubit home pages differ only in how they reach the Cubit:

| Widget | How it reads the Cubit |
| --- | --- |
| `MyHomePageUsingCubit` | `BlocProvider.of<CounterCubit>(context).increment()` |
| `MyHomePageUsingExtensionContext` (used by `MyAppCubit`) | `context.read<CounterCubit>().increment()`, the shorter extension syntax |

### Switching between the versions

`lib/main.dart` runs the BLoC version. To run the Cubit version, change it to:

```dart
void main() {
  runApp(const MyAppCubit());
}
```

---

## 2. `counter_stream`: Cubit + connectivity + routing

A counter that **reacts to the device's network connection**. It shows how one Cubit can
listen to another through a `StreamSubscription`, and how a Cubit provided above
`MaterialApp` keeps the same state on every screen.

**Dependencies:** `flutter_bloc ^8.0.1`, `bloc ^8.0.1`, `equatable ^2.0.5`, `connectivity_plus ^2.3.9`

> The package name in `pubspec.yaml` is `counter`, so imports look like
> `package:counter/...`, not `package:counter_stream/...`.

### How the pieces connect

```text
Connectivity().onConnectivityChanged
        │
        ▼
InternetCubit ── emits InternetLoading / InternetConnected(Wifi|Mobile) / InternetDisconnected
        │                    │
        │                    └──▶ HomeScreen shows "Wifi" (green), "Mobile" (red) or "Disconnected" (grey)
        ▼
CounterCubit  ── listens to InternetCubit.stream:
                   Wi-Fi                  → increment()
                   Mobile or Disconnected → decrement()
        │
        ▼
Home / Second / Third screens (all share the same CounterCubit)
```

Both Cubits are created in `main.dart` with `MultiBlocProvider`, **above** `MaterialApp`, so
every route reads the same instances. Each Cubit cancels its subscription in `close()`.

### States

| Cubit | State | Meaning |
| --- | --- | --- |
| `InternetCubit` | `InternetLoading` | No connection event received yet (a spinner is shown) |
| | `InternetConnected(connectionType)` | Connected over `ConnectionType.Wifi` or `ConnectionType.Mobile`. `connectionType` is in `props`, so switching directly between Wi-Fi and mobile is detected as a change |
| | `InternetDisconnected` | No connection |
| `CounterCubit` | `CounterState(counterValue, wasIncremented)` | Current value, and whether the last change was up or down |

### What the screens show

Each change shows an "Incremented!" or "Decremented!" snackbar (based on `wasIncremented`),
and the value is shown with a message:

| Counter value | Text shown |
| --- | --- |
| Below 0 | `BRR, NEGATIVE <value>` |
| Even (0, 2, 4, …) | `YAAAY <value>` |
| 5 | `HMM, NUMBER 5` |
| Any other odd number | `<value>` |

### Routes

Routing uses `onGenerateRoute` in `presentation/router/app_router.dart`:

| Route | Screen | App bar colour | Contents |
| --- | --- | --- | --- |
| `/` (default) | `HomeScreen` | Blue | Connection status, counter, + / − buttons, buttons to the other screens |
| `/second` | `SecondScreen` | Red | Counter only (its buttons are commented out) |
| `/third` | `ThirdScreen` | Green | Counter and + / − buttons |

Change the counter on the third screen and go back: the home screen shows the same value,
because the state lives in the shared `CounterCubit`.

To try the connectivity behaviour, toggle Wi-Fi, mobile data or airplane mode on the
device or emulator.

---

## 3. `counter_reactive`: RxDart

A counter built with plain Dart streams from [`rxdart`](https://pub.dev/packages/rxdart), with
no BLoC library involved.

**Dependencies:** `rxdart ^0.27.5` (`flutter_bloc` and `equatable` are listed in `pubspec.yaml` but not used)

### How it works

- `CounterRx` (`state_management/counter_rx/counter_rx.dart`) holds a
  `BehaviorSubject<int>` **seeded** with the initial count (0 by default).
  A `BehaviorSubject` always replays its latest value to new listeners, so the UI shows `0`
  straight away instead of an empty state.
- `increment()` / `decrement()` update the count and add the new value to the subject.
- `counterObservable` exposes the subject as a `Stream<int>`.
- `MyHomePage` (`ui/my_home_page.dart`) redraws the number with a `StreamBuilder`. You can
  pass your own `CounterRx` to the constructor (useful for tests), or it creates one.

---

## Comparing the approaches

| | BLoC | Cubit | RxDart |
| --- | --- | --- | --- |
| Changing state | Send an **event** (`bloc.add(IncrementCounterEvent())`) | Call a **method** (`cubit.increment()`) | Call a method that adds to a **subject** |
| Boilerplate | Most (events + states + handlers) | Less (states + methods) | Least (one class) |
| Traceability | Every event can be logged and transformed (debounce, etc.) | State changes only | Whatever you log yourself |
| Rebuilding the UI | `BlocBuilder` / `BlocConsumer` | `BlocBuilder` / `BlocConsumer` | `StreamBuilder` |
| Good for | Complex flows where the *reason* for a change matters | Most screens | Stream-heavy logic, or avoiding a state management package |

## Testing

Each project has a `test/widget_test.dart`:

```bash
cd counter_app   # or counter_stream, counter_reactive
flutter test
```

These are still Flutter's default "Counter increments smoke test", not tests of each
project's own behaviour. `counter_stream`'s version can't pass as written: it looks for the
text `0`, but that screen shows `YAAAY 0`, and it uses the real `Connectivity`, which needs a
mock in tests.

## Known issues

- **`counter_reactive`: the subject is never closed.** `CounterRx.dispose()` exists but
  isn't called, because `MyHomePage` is a `StatelessWidget`. That's fine for a single-screen
  demo, but in a real app create it in a `StatefulWidget` and dispose it in `dispose()`.
- **All projects use pre-Dart 3 constraints and a few deprecated APIs** (e.g.
  `textTheme.headline3` / `headline4`, now `displaySmall` / `headlineMedium`). They build
  on Flutter 3.7 and need small updates to run on current Flutter.
