import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zapt_sdk_flutter/zapt_sdk_flutter.dart';

void main() {
  runApp(const Example());
}

class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  static const stream = EventChannel("ReactNativeZaptSdkBeaconsFound");
  String _mapLink = "";
  int _selectedIndex = 0;
  final _zaptSDKPlugin = ZaptSdkFlutter();
  Map<String, String> options = {
    'floorId': '1',
    'zoom': '0',
    'markerX': '1710',
    'markerY': '810',
    'markerZ': '1'
  };
  final String placeId = "-ltvysf4acgzdxdhf81y";


  @override
  void initState() {
    super.initState();
    _zaptSDKPlugin.requestPermissionsBackground({});
    getMapLink(placeId, options);
  }

  Future<void> getMapLink(placeId, options) async {
    String mapLink = "";
    try {
      await _zaptSDKPlugin.initialize(placeId);
      mapLink = await _zaptSDKPlugin
              .getMapLink({'placeId': placeId, 'options': options}) ??
          "";
    } on PlatformException {
      mapLink = 'Error';
    }
    setState(() {
      _mapLink = mapLink;
    });
  }

  Future<void> initListenBeacons() async {
    await _zaptSDKPlugin.addListener("ReactNativeZaptSdkBeaconsFound");
    stream.receiveBroadcastStream().listen(_updateBeacons);
  }

  void _updateBeacons(beacons) {
    debugPrint(beacons.toString());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Zapt SDK Flutter Example"),
        ),
        body: Center(
          child: ZaptMap(placeId: placeId, options: options),
        ),
      ),
    );
  }
}
