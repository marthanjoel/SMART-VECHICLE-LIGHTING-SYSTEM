# 🚗💡 Smart Vehicle Lighting System

A smart vehicle lighting prototype developed using an Arduino UNO R3 and a Flutter application.

The system automatically controls vehicle lighting according to the surrounding light level. An LDR/photoresistor is used to detect the environment, while an RGB LED represents the vehicle lighting system.

A rotary control can be used to adjust the lighting brightness.

## Features

- Automatic vehicle lighting
- LDR/photoresistor light detection
- RGB LED lighting
- Adjustable brightness
- Arduino serial communication
- Flutter monitoring interface
- USB communication between Arduino and Flutter
- GitHub Actions APK build

## Hardware

| Component | Arduino Pin |
|---|---|
| LDR / Photoresistor | A0 |
| RGB LED Red | D5 |
| RGB LED Green | D6 |
| RGB LED Blue | D9 |
| Rotary CLK | D3 |
| Rotary DT | D2 |

## Lighting Logic

The Arduino reads the LDR value.

When the environment becomes dark:

```text
LDR → Arduino → RGB LED ON
