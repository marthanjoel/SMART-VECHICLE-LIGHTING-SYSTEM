import 'dart:async';
import 'dart:typed_data';

import 'package:flserial/flserial.dart';

class ArduinoService {
  ArduinoService._();

  static final ArduinoService instance =
      ArduinoService._();

  final FlSerial _serial = FlSerial();

  StreamSubscription<SerialEvent>? _subscription;

  final StreamController<String> _dataController =
      StreamController<String>.broadcast();

  bool _connected = false;
  String? _connectedPort;

  String _receiveBuffer = '';

  bool get isConnected => _connected;

  String? get connectedPort => _connectedPort;

  Stream<String> get dataStream =>
      _dataController.stream;

  Future<List<String>> scanPorts() async {
    final ports = await FlSerial.availablePorts();

    return ports
        .map((port) => port.path.toString())
        .toList();
  }

  Future<bool> connect(
    String port, {
    int baudRate = 9600,
  }) async {
    await _subscription?.cancel();

    _receiveBuffer = '';

    _subscription = _serial.events.listen(
      (event) {
        if (event.type == SerialEventType.disconnected) {
          _connected = false;
          _connectedPort = null;
          _receiveBuffer = '';

          _dataController.add(
            'ARDUINO_DISCONNECTED',
          );

          return;
        }

        if (event.type == SerialEventType.error) {
          _dataController.add(
            'ERROR:${event.data}',
          );

          return;
        }

        if (event.type == SerialEventType.data) {
          _handleIncomingData(event.data);
        }
      },
    );

    final config = SerialConfig(
      baudRate: baudRate,
      dataBits: 8,
      stopBits: 1,
      parity: 0,
      flowControl: 0,
    );

    try {
      final success = await _serial.open(
        port,
        config,
      );

      if (success) {
        _connected = true;
        _connectedPort = port;

        _dataController.add(
          'ARDUINO_CONNECTED',
        );
      }

      return success;
    } catch (e) {
      _connected = false;
      _connectedPort = null;

      _dataController.add(
        'ERROR:$e',
      );

      return false;
    }
  }

  void _handleIncomingData(dynamic data) {
    if (data == null) {
      return;
    }

    String incoming;

    if (data is Uint8List) {
      incoming = String.fromCharCodes(data);
    } else if (data is List<int>) {
      incoming = String.fromCharCodes(data);
    } else {
      incoming = data.toString();
    }

    _receiveBuffer += incoming;

    // Arduino sends messages ending with \n.
    while (_receiveBuffer.contains('\n')) {
      final newlineIndex =
          _receiveBuffer.indexOf('\n');

      final line =
          _receiveBuffer.substring(0, newlineIndex);

      _receiveBuffer =
          _receiveBuffer.substring(newlineIndex + 1);

      final cleanLine =
          line.replaceAll('\r', '').trim();

      if (cleanLine.isNotEmpty) {
        _dataController.add(cleanLine);
      }
    }
  }

  void send(String command) {
    if (!_connected) {
      return;
    }

    final message = '$command\n';

    _serial.write(
      Uint8List.fromList(
        message.codeUnits,
      ),
    );
  }

  Future<void> disconnect() async {
    await _serial.close();

    _connected = false;
    _connectedPort = null;
    _receiveBuffer = '';

    _dataController.add(
      'ARDUINO_DISCONNECTED',
    );
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    await _serial.close();
    await _serial.dispose();
    await _dataController.close();
  }
}
