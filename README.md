# Flutter Task - Ksawery Kondrat - Aplikacja Mobilna Wizard Form

Aplikacja mobilna stworzona w Flutter w ramach zadania rekrutacyjnego.

## Instrukcja uruchomienia

#### Wymagania wstępne

1. **Flutter SDK** (wersja 3.35.2 lub nowsza)
2. **Git** 
3. **Google Chrome** (do uruchomienia w przeglądarce)
4. **Android Studio** (do uruchomienia na emulatorze Android)

#### Pobranie projektu

```bash
# Sklonuj repozytorium
git clone git@github.com:ksewkoWiW/flutterTaskKsewko.git

# Przejdź do katalogu projektu
cd flutterTaskKsewko

# Pobierz zależności
flutter pub get
```

#### Sprawdzenie konfiguracji Flutter

```bash
# Sprawdź konfigurację Flutter
flutter doctor

# Sprawdź dostępne urządzenia
flutter devices
```

## Uruchomienie w przeglądarce Chrome

```bash
flutter run -d chrome
```

##  Uruchomienie na emulatorze Android Studio

#### Utworzenie wirtualnego urządzenia (AVD)

1. **W Android Studio:**
   - `Tools` → `Device Manager` (lub `AVD Manager`)
   - Kliknij `Create Virtual Device`
   - Wybierz urządzenie
   - Wybierz najnowszą wersję Android (API 34+)
   - Nazwij urządzenie i kliknij `Finish`

#### Uruchomienie emulatora
```bash
# Sprawdź dostępne emulatory
flutter emulators

flutter emulators --launch <emulator_id>

# LUB uruchom przez Android Studio
# Kliknij przycisk ▶️ obok nazwy emulatora w Device Manager
```

#### Uruchomienie aplikacji
```bash
# Sprawdź czy emulator jest widoczny
flutter devices

# Uruchom aplikację na emulatorze
flutter run -d <emulator-id>
# Przykład: flutter run -d emulator-5554
```

## Testowanie aplikacji
Napisałem kilka symboliczych testów :)

#### Uruchomienie testów
```bash
flutter test
```

## Oczekiwane wyniki

Po zakończeniu wypełniania formularza w konsoli pojawi się JSON z odpowiedziami o strukturze:

```json
{
  "userId": "user123",
  "timestamp": "2025-08-28T...",
  "responses": {
    "stage_0_step_0": {
      "stepType": "video_step",
      "completed": true,
      ...
    },
    "stage_0_step_1": {
      "stepType": "wheel_step", 
      "painLevel": 5,
      ...
    },
    "stage_0_step_2": {
      "stepType": "pain_choice_step",
      "selectedChoice": {...},
      ...
    }
  },
  "completedAt": "...",
  "totalStages": 3,
  "totalSteps": 3
}
```

**Autor:** Ksawery Kondrat
**Data:** 28 sierpnia 2025  
**Flutter:** 3.35.2  
**Platformy:** Chrome Web, Android Studio Virtual Device
