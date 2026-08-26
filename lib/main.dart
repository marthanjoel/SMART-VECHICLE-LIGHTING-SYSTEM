 import 'package:flutter/material.dart';

void main() {
  runApp(const SmartVehicleLightingApp());
}

class SmartVehicleLightingApp extends StatelessWidget {
  const SmartVehicleLightingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Vehicle Lighting',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const SmartLightingHomePage(),
    );
  }
}

class SmartLightingHomePage extends StatefulWidget {
  const SmartLightingHomePage({super.key});

  @override
  State<SmartLightingHomePage> createState() =>
      _SmartLightingHomePageState();
}

class _SmartLightingHomePageState extends State<SmartLightingHomePage> {
  bool automaticMode = true;
  bool isNight = false;
  double brightness = 50;
  double ldrValue = 800;

  bool get lightsOn {
    if (automaticMode) {
      return isNight;
    }
    return brightness > 0;
  }

  void toggleDayNight() {
    setState(() {
      isNight = !isNight;

      if (isNight) {
        ldrValue = 150;
      } else {
        ldrValue = 850;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color lightColor =
        lightsOn ? Colors.yellow : Colors.grey.shade700;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SMART VEHICLE LIGHTING SYSTEM'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            // VEHICLE LIGHT DISPLAY
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.directions_car,
                      size: 100,
                      color: Colors.blue,
                    ),

                    const SizedBox(height: 10),

                    Text(
                      lightsOn
                          ? 'VEHICLE LIGHTS ON'
                          : 'VEHICLE LIGHTS OFF',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: lightsOn
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildHeadlight(lightColor),
                        _buildHeadlight(lightColor),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // SYSTEM STATUS
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      isNight
                          ? Icons.nightlight_round
                          : Icons.wb_sunny,
                    ),
                    title: const Text('AMBIENT LIGHT STATUS'),
                    subtitle: Text(
                      isNight ? 'NIGHT DETECTED' : 'DAY DETECTED',
                    ),
                  ),

                  const Divider(),

                  ListTile(
                    leading: const Icon(Icons.sensors),
                    title: const Text('LDR SENSOR VALUE'),
                    trailing: Text(
                      ldrValue.toStringAsFixed(0),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // AUTOMATIC MODE
            Card(
              child: SwitchListTile(
                secondary: const Icon(Icons.auto_mode),
                title: const Text('AUTOMATIC LIGHTING MODE'),
                subtitle: Text(
                  automaticMode
                      ? 'Automatic day/night control active'
                      : 'Manual lighting control active',
                ),
                value: automaticMode,
                onChanged: (value) {
                  setState(() {
                    automaticMode = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 20),

            // BRIGHTNESS CONTROL
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.brightness_6),
                        SizedBox(width: 10),
                        Text(
                          'ROTARY ENCODER - BRIGHTNESS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Text(
                      '${brightness.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Slider(
                      min: 0,
                      max: 100,
                      divisions: 20,
                      label: '${brightness.toStringAsFixed(0)}%',
                      value: brightness,
                      onChanged: automaticMode
                          ? null
                          : (value) {
                              setState(() {
                                brightness = value;
                              });
                            },
                    ),

                    Text(
                      automaticMode
                          ? 'Disable automatic mode to adjust brightness manually'
                          : 'Use the slider to simulate the rotary encoder',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // DAY / NIGHT SIMULATION BUTTON
            ElevatedButton.icon(
              onPressed: automaticMode ? toggleDayNight : null,
              icon: Icon(
                isNight
                    ? Icons.wb_sunny
                    : Icons.nightlight_round,
              ),
              label: Text(
                isNight
                    ? 'SIMULATE DAYLIGHT'
                    : 'SIMULATE DARKNESS',
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
              ),
            ),

            const SizedBox(height: 15),

            // FINAL STATUS
            Card(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    const Text(
                      'SYSTEM STATUS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      lightsOn
                          ? 'LIGHTING SYSTEM ACTIVE'
                          : 'LIGHTING SYSTEM INACTIVE',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: lightsOn
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeadlight(Color color) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: lightsOn
            ? [
                BoxShadow(
                  color: Colors.yellow.withOpacity(0.5),
                  blurRadius: 25,
                  spreadRadius: 10,
                ),
              ]
            : [],
      ),
      child: const Icon(
        Icons.lightbulb,
        size: 40,
        color: Colors.white,
      ),
    );
  }
}