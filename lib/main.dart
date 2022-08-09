import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter/webview_flutter.dart';
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
  WebViewController? controller;
  int _selectedIndex = 0;
  final _zaptSDKPlugin = ZaptSdkFlutter();
  Map<String, String> options = {
    'floorId': '1',
    'zoom': '-3',
    'embed': 'true',
    'markerX': '1710',
    'markerY': '810',
    'markerZ': '1'
  };
  final String placeId = "-ltvysf4acgzdxdhf81y";

  final List<Widget> _telas = [];

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    _zaptSDKPlugin.requestPermissionsBackground({});
    initScreens();
    getMapLink(placeId, options);
  }

  void initScreens() {
    _telas.add(ZaptMap(placeId: placeId, options: options));
    _telas.add(WebView(
      onWebViewCreated: (WebViewController webViewController) {
        controller = webViewController;
        if (_mapLink.isNotEmpty) {
          _zaptSDKPlugin.requestPermissions();
          webViewController.loadUrl(_mapLink);
        }
      },
      onPageFinished: ((String url) => initListenBeacons()),
      javascriptMode: JavascriptMode.unrestricted,
    ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
    if (mapLink.isNotEmpty) {
      controller?.loadUrl(mapLink);
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
              child: _telas[_selectedIndex],
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.map), label: "Zapt Map"),
                BottomNavigationBarItem(icon: Icon(Icons.web), label: "WebView")
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            )));
  }
}
