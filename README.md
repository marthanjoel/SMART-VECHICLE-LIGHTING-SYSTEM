<<<<<<< HEAD
# smart_vehicle_lighting_system

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
=======
# SMART-VECHICLE-LIGHTING-SYSTEM
Smart Vehicle Lighting System – Arduino Project
Project Overview

This project is a Smart Vehicle Lighting System using Arduino.
The system automatically turns vehicle lights ON at night and OFF during the day.
It also allows the driver to manually adjust brightness using a rotary encoder.



Aim / Purpose

Automatically control vehicle lights based on ambient light.

Allow manual brightness adjustment for better visibility and safety.

Save energy by turning lights off during the day.







Components

Arduino Uno – main controller

Photoresistor (LDR) – detects day and night

Rotary Encoder – adjusts brightness

RGB LED (SMD) – acts as vehicle headlight

Resistors and jumper wires – for safe connections





How It Works

The photoresistor senses the surrounding light:

Bright → system detects day → lights OFF

Dark → system detects night → lights ON

The rotary encoder lets the driver adjust the brightness:

Turn clockwise → increase brightness

Turn anti-clockwise → decrease brightness

The RGB LED represents the vehicle lights.

The Arduino reads sensor values and controls the LED accordingly.


Demo Steps

Cover the photoresistor → lights turn ON, Serial shows NIGHT.

Remove hand → lights turn OFF, Serial shows DAY.

Turn the rotary encoder → brightness changes.



Applications

Smart cars for automatic headlight control

Street lighting that adjusts to ambient light

Energy-saving lighting systems



Conclusion

This system is simple, efficient, and safe.
It automatically controls vehicle lighting and gives the driver manual control of brightness.
>>>>>>> 2315bbccb64bddd8b8c05f5f71960721ebb7ca10
