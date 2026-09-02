# 🚗💡 Smart Vehicle Lighting System

A smart vehicle lighting prototype developed using an **Arduino UNO R3** and a **Flutter application**.

The system automatically controls vehicle lighting according to the surrounding light level. An **LDR/photoresistor** detects the amount of light in the environment, while an **RGB LED** represents the vehicle lighting system.

A rotary control is used to adjust the lighting brightness.

---

## 📌 Project Overview

The Smart Vehicle Lighting System is designed to demonstrate automatic vehicle lighting using an Arduino-based control system.

The Arduino continuously monitors the surrounding light level.

### ☀️ Bright Environment

When sufficient light is detected:

* 💡 Vehicle lighting turns OFF
* 📊 The light level is sent through serial communication
* 📱 Flutter can display the current lighting status

### 🌙 Dark Environment

When the environment becomes dark:

* 💡 Vehicle lighting turns ON
* 🔆 The selected brightness is applied
* 📊 The light level is sent to the Flutter application

---

## 🧰 Hardware Required

| Component                |    Quantity |
| ------------------------ | ----------: |
| Arduino UNO R3           |           1 |
| LDR / Photoresistor      |           1 |
| RGB LED                  |           1 |
| Rotary Encoder / Control |           1 |
| Resistors                | As required |
| Breadboard               |           1 |
| Jumper Wires             | As required |
| USB Cable                |           1 |

---

## 🔌 Circuit Connections

| Component           | Arduino Pin |
| ------------------- | ----------- |
| LDR / Photoresistor | A0          |
| RGB LED Red         | D5          |
| RGB LED Green       | D6          |
| RGB LED Blue        | D9          |
| Rotary CLK          | D3          |
| Rotary DT           | D2          |

---

## 💡 How the System Works

The LDR measures the surrounding light level and sends an analog value to the Arduino.

The Arduino compares the measured value with a predefined threshold.

```text
LDR
 │
 ▼
Arduino UNO
 │
 ├── Bright → Lights OFF
 │
 └── Dark → Lights ON
              │
              ▼
           RGB LED
```

The lighting brightness can be adjusted between:

```text
0 - 255
```

---

## 📡 Serial Communication

The Arduino communicates with the Flutter application through USB serial communication.

### Baud Rate

```text
9600
```

Example messages:

```text
LIGHT:ON,LEVEL:450,BRIGHTNESS:120
```

```text
LIGHT:OFF,LEVEL:750,BRIGHTNESS:120
```

The Flutter application reads these messages and uses them to display the actual Arduino lighting status.

---

## 📱 Flutter Application

The Flutter application provides a graphical interface for monitoring the Smart Vehicle Lighting System.

The application can display information such as:

* 🔌 Arduino connection status
* 💡 Lighting status
* ☀️ Light level
* 🔆 Brightness
* 📡 Serial communication status

The Arduino is responsible for reading the physical sensor and controlling the RGB LED.

---

## 📂 Project Structure

```text
SMART-VECHICLE-LIGHTING-SYSTEM/
│
├── android/
├── ios/
├── linux/
├── macos/
├── web/
├── windows/
│
├── lib/
│   ├── main.dart
│   └── services/
│
├── test/
│
├── pubspec.yaml
├── pubspec.lock
├── README.md
│
└── .github/
    └── workflows/
        └── build-apk.yml
```

---

## ⚙️ Flutter Setup

Install the project dependencies:

```bash
flutter pub get
```

Check the project for problems:

```bash
flutter analyze
```

Run the application on Linux:

```bash
LIBGL_ALWAYS_SOFTWARE=1 flutter run -d linux
```

---

## 🔌 Connecting the Arduino

1. Connect the Arduino UNO R3 to the computer using USB.
2. Upload the Smart Vehicle Lighting Arduino program.
3. Close the Arduino Serial Monitor.
4. Start the Flutter application.
5. Select the Arduino serial port.
6. Connect the Arduino.
7. Change the light level or brightness control and observe the Flutter interface.

On Linux, the Arduino may appear as:

```text
/dev/ttyACM0
```

---

## ⚠️ Serial Port Warning

Only one program should use the Arduino serial port at a time.

If the Arduino Serial Monitor is open, close it before connecting the Flutter application.

---

## 🏗️ Android APK

The project includes a GitHub Actions workflow for building the Android release APK.

Workflow:

```text
.github/workflows/build-apk.yml
```

The workflow can:

1. Download the project.
2. Install Flutter.
3. Install dependencies.
4. Build the release APK.
5. Upload the APK as a GitHub Actions artifact.

The generated APK is:

```text
app-release.apk
```

---

## 🔄 Complete System Flow

```text
        ☀️ / 🌙
           │
           ▼
    ┌───────────────┐
    │ LDR Sensor    │
    └───────┬───────┘
            │
            ▼
    ┌───────────────┐
    │ Arduino UNO   │
    │               │
    │ Lighting      │
    │ Controller    │
    └───────┬───────┘
            │
       ┌────┴────┐
       │         │
       ▼         ▼
   RGB LED    USB Serial
                 │
                 ▼
        ┌────────────────┐
        │ Flutter App    │
        │                │
        │ Light Status   │
        │ Light Level    │
        │ Brightness     │
        └────────────────┘
```

---

## 🎯 Project Objectives

The objectives of this project are:

1. Develop an automatic vehicle lighting system.
2. Detect environmental light conditions.
3. Automatically switch vehicle lighting based on the environment.
4. Provide adjustable lighting brightness.
5. Connect Arduino hardware to a Flutter application.
6. Display real-time lighting information.
7. Demonstrate smart vehicle electronics.

---

## 🔮 Future Improvements

Possible future improvements include:

* 🚘 Automatic headlight control
* 🔆 High-beam and low-beam control
* ↔️ Automatic turn indicators
* 🛑 Brake-light integration
* 🌧️ Rain detection
* 📱 Wireless mobile control
* 📶 Bluetooth communication
* 📊 Lighting event history
* 🔋 Battery monitoring
* 🚗 Integration with other vehicle systems

---

## 🛠️ Technologies Used

* Arduino UNO R3
* Arduino IDE
* C/C++
* Flutter
* Dart
* USB Serial Communication
* flserial
* Git
* GitHub
* GitHub Actions

---

## 👨‍💻 Author

**Lutwama Joel**

Electrical Installation Student

Smart Vehicle Systems Project

---

## 📊 Project Status

**Working Prototype ✅**

The system demonstrates automatic lighting control using an LDR, RGB LED, Arduino UNO R3, and Flutter interface.
