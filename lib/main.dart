import 'dart:async';

import 'package:flutter/material.dart';
import 'services/arduino_service.dart';

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

class _SmartLightingHomePageState
    extends State<SmartLightingHomePage> {
  final ArduinoService _arduino = ArduinoService.instance;

  StreamSubscription<String>? _subscription;

  List<String> ports = [];

  String? selectedPort;

  bool connecting = false;

  bool arduinoConnected = false;

  bool lightsOn = false;

  bool automaticMode = true;

  int ldrValue = 0;

  int brightness = 120;

  @override
  void initState() {
    super.initState();

    _subscription = _arduino.dataStream.listen(
      _processArduinoData,
    );

    _scanPorts();
  }

  Future<void> _scanPorts() async {
    try {
      final foundPorts = await _arduino.scanPorts();

      if (!mounted) return;

      setState(() {
        ports = foundPorts;

        if (ports.isNotEmpty &&
            (selectedPort == null ||
                !ports.contains(selectedPort))) {
          selectedPort = ports.first;
        }
      });
    } catch (e) {
      debugPrint('Port scan error: $e');
    }
  }

  Future<void> _connectArduino() async {
    if (selectedPort == null) {
      _showMessage('No Arduino port selected.');
      return;
    }

    setState(() {
      connecting = true;
    });

    final success = await _arduino.connect(
      selectedPort!,
      baudRate: 9600,
    );

    if (!mounted) return;

    setState(() {
      connecting = false;
      arduinoConnected = success;
    });

    if (success) {
      _showMessage(
        'Arduino connected on $selectedPort',
      );
    } else {
      _showMessage(
        'Could not connect to Arduino.',
      );
    }
  }

  Future<void> _disconnectArduino() async {
    await _arduino.disconnect();

    if (!mounted) return;

    setState(() {
      arduinoConnected = false;
    });
  }

  void _processArduinoData(String data) {
    final lines = data.split('\n');

    for (final rawLine in lines) {
      final line = rawLine.trim();

      if (line.isEmpty) continue;

      debugPrint('Arduino: $line');

      if (line == 'ARDUINO_CONNECTED') {
        if (mounted) {
          setState(() {
            arduinoConnected = true;
          });
        }
      } else if (line == 'ARDUINO_DISCONNECTED') {
        if (mounted) {
          setState(() {
            arduinoConnected = false;
          });
        }
      } else if (line.startsWith('LDR:')) {
        final value = int.tryParse(
          line.substring(4).trim(),
        );

        if (value != null && mounted) {
          setState(() {
            ldrValue = value;
          });
        }
      } else if (line.startsWith('LIGHTS:')) {
        final state = line.substring(7).trim();

        if (mounted) {
          setState(() {
            lightsOn = state == 'ON';
          });
        }
      } else if (line.startsWith('BRIGHTNESS:')) {
        final value = int.tryParse(
          line.substring(11).trim(),
        );

        if (value != null && mounted) {
          setState(() {
            brightness = value.clamp(0, 255);
          });
        }
      } else if (line.startsWith('MODE:')) {
        final mode = line.substring(5).trim();

        if (mounted) {
          setState(() {
            automaticMode = mode == 'AUTO';
          });
        }
      } else if (line.startsWith('Brightness:')) {
        final value = int.tryParse(
          line.substring(11).trim(),
        );

        if (value != null && mounted) {
          setState(() {
            brightness = value.clamp(0, 255);
          });
        }
      }
    }
  }

  void _setBrightness(double value) {
    final int pwm = value.round().clamp(0, 255);

    setState(() {
      brightness = pwm;
    });

    if (arduinoConnected) {
      _arduino.send('BRIGHTNESS:$pwm');
    }
  }

  void _turnLightsOn() {
    if (!arduinoConnected) return;

    _arduino.send('LIGHTS_ON');
  }

  void _turnLightsOff() {
    if (!arduinoConnected) return;

    _arduino.send('LIGHTS_OFF');
  }

  void _setAutomatic(bool value) {
    setState(() {
      automaticMode = value;
    });

    if (!arduinoConnected) return;

    if (value) {
      _arduino.send('AUTO_ON');
    } else {
      _arduino.send('AUTO_OFF');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  String _lightDescription() {
    if (!arduinoConnected) {
      return 'WAITING FOR ARDUINO';
    }

    if (lightsOn) {
      return 'VEHICLE LIGHTS ON';
    }

    return 'VEHICLE LIGHTS OFF';
  }

  Color _statusColor() {
    if (!arduinoConnected) {
      return Colors.orange;
    }

    if (lightsOn) {
      return Colors.green;
    }

    return Colors.red;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double brightnessPercent =
        (brightness / 255) * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SMART VEHICLE LIGHTING SYSTEM',
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            // ==============================
            // ARDUINO CONNECTION
            // ==============================
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    Row(
                      children: [
                        Icon(
                          arduinoConnected
                              ? Icons.usb
                              : Icons.usb_off,
                          color: arduinoConnected
                              ? Colors.green
                              : Colors.red,
                        ),

                        const SizedBox(width: 10),

                        const Expanded(
                          child: Text(
                            'ARDUINO CONNECTION',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor()
                                .withValues(alpha: 0.15),
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: Text(
                            arduinoConnected
                                ? 'CONNECTED'
                                : 'DISCONNECTED',
                            style: TextStyle(
                              color: _statusColor(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [

                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue:
                                ports.contains(selectedPort)
                                    ? selectedPort
                                    : null,

                            decoration:
                                const InputDecoration(
                              labelText: 'Arduino Port',
                              border: OutlineInputBorder(),
                            ),

                            items: ports.map(
                              (port) {
                                return DropdownMenuItem(
                                  value: port,
                                  child: Text(port),
                                );
                              },
                            ).toList(),

                            onChanged: (value) {
                              setState(() {
                                selectedPort = value;
                              });
                            },
                          ),
                        ),

                        const SizedBox(width: 10),

                        IconButton(
                          onPressed: _scanPorts,
                          icon: const Icon(
                            Icons.refresh,
                          ),
                          tooltip: 'Scan ports',
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: connecting
                            ? null
                            : arduinoConnected
                                ? _disconnectArduino
                                : _connectArduino,

                        icon: Icon(
                          arduinoConnected
                              ? Icons.link_off
                              : Icons.link,
                        ),

                        label: Text(
                          connecting
                              ? 'CONNECTING...'
                              : arduinoConnected
                                  ? 'DISCONNECT ARDUINO'
                                  : 'CONNECT ARDUINO',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==============================
            // LIGHT DISPLAY
            // ==============================
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
                      _lightDescription(),

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _statusColor(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,

                      children: [
                        _buildHeadlight(),
                        _buildHeadlight(),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Text(
                      '${brightnessPercent.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Text(
                      'CURRENT BRIGHTNESS',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==============================
            // SENSOR STATUS
            // ==============================
            Card(
              child: Column(
                children: [

                  ListTile(
                    leading: Icon(
                      ldrValue < 600
                          ? Icons.nightlight_round
                          : Icons.wb_sunny,
                    ),

                    title: const Text(
                      'AMBIENT LIGHT STATUS',
                    ),

                    subtitle: Text(
                      !arduinoConnected
                          ? 'Arduino not connected'
                          : ldrValue < 600
                              ? 'NIGHT DETECTED'
                              : 'DAY DETECTED',
                    ),
                  ),

                  const Divider(),

                  ListTile(
                    leading: const Icon(
                      Icons.sensors,
                    ),

                    title: const Text(
                      'LDR SENSOR VALUE',
                    ),

                    trailing: Text(
                      arduinoConnected
                          ? '$ldrValue'
                          : '--',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const Divider(),

                  ListTile(
                    leading: const Icon(
                      Icons.brightness_6,
                    ),

                    title: const Text(
                      'ARDUINO BRIGHTNESS',
                    ),

                    trailing: Text(
                      '$brightness / 255',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const Divider(),

                  ListTile(
                    leading: const Icon(
                      Icons.settings,
                    ),

                    title: const Text(
                      'LIGHTING MODE',
                    ),

                    trailing: Text(
                      automaticMode
                          ? 'AUTO'
                          : 'MANUAL',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ==============================
            // AUTOMATIC MODE
            // ==============================
            Card(
              child: SwitchListTile(
                secondary: const Icon(
                  Icons.auto_mode,
                ),

                title: const Text(
                  'AUTOMATIC LIGHTING MODE',
                ),

                subtitle: Text(
                  automaticMode
                      ? 'Arduino controls lights from LDR'
                      : 'Manual lighting control',
                ),

                value: automaticMode,

                onChanged: _setAutomatic,
              ),
            ),

            const SizedBox(height: 20),

            // ==============================
            // BRIGHTNESS
            // ==============================
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [

                    const Row(
                      children: [
                        Icon(
                          Icons.brightness_6,
                        ),

                        SizedBox(width: 10),

                        Text(
                          'BRIGHTNESS CONTROL',
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Text(
                      '${brightnessPercent.toStringAsFixed(0)}%',

                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Slider(
                      min: 0,
                      max: 255,
                      divisions: 51,

                      value: brightness
                          .toDouble()
                          .clamp(0, 255),

                      label: '$brightness',

                      onChanged:
                          arduinoConnected
                              ? _setBrightness
                              : null,
                    ),

                    const Text(
                      'Brightness is synchronized with the Arduino.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==============================
            // MANUAL CONTROLS
            // ==============================
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [

                    const Text(
                      'MANUAL LIGHT CONTROL',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [

                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed:
                                arduinoConnected
                                    ? _turnLightsOn
                                    : null,

                            icon: const Icon(
                              Icons.lightbulb,
                            ),

                            label: const Text(
                              'LIGHTS ON',
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed:
                                arduinoConnected
                                    ? _turnLightsOff
                                    : null,

                            icon: const Icon(
                              Icons.lightbulb_outline,
                            ),

                            label: const Text(
                              'LIGHTS OFF',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==============================
            // FINAL STATUS
            // ==============================
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [

                    const Text(
                      'SYSTEM STATUS',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      !arduinoConnected
                          ? 'ARDUINO NOT CONNECTED'
                          : lightsOn
                              ? 'LIGHTING SYSTEM ACTIVE'
                              : 'LIGHTING SYSTEM INACTIVE',

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                        color: _statusColor(),
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

  Widget _buildHeadlight() {
    return Container(
      width: 70,
      height: 70,

      decoration: BoxDecoration(
        color: lightsOn
            ? Colors.yellow
            : Colors.grey.shade700,

        shape: BoxShape.circle,

        boxShadow: lightsOn
            ? [
                BoxShadow(
                  color:
                      Colors.yellow.withValues(
                    alpha: 0.5,
                  ),
                  blurRadius: 25,
                  spreadRadius: 10,
                ),
              ]
            : [],
      ),

      child: Icon(
        Icons.lightbulb,
        size: 40,
        color: lightsOn
            ? Colors.white
            : Colors.grey.shade400,
      ),
    );
  }
}
