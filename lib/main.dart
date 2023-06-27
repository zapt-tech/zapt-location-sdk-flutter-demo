import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zapt_sdk_flutter/zapt_sdk_flutter.dart';
import 'package:zapt_sdk_flutter/zapt_sdk_flutter_controller.dart';
import 'package:flutter_zapt_sdk_demo/map_controls.dart';

void main() {
  runApp(const Example());
}

class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  final _zaptSdkFlutterPlugin = ZaptSdkFlutter();
  Map<String, String> options = {
    'floorId': '1',
    'embed': 'true',
    'displayFloorsButton': 'false',
    'displayListButton': 'false',
    'displayLocationButton': 'false'
  };
  final String placeId = "-ltvysf4acgzdxdhf81y";
  bool _mapIsLoading = false;
  ZaptSDKController? _controller;

  double _mapZoom = 0;
  double _mapRotation = 0;
  int _mapFloor = 0;
  MapCenter _mapCenter = MapCenter(x: 1640, y: 2064, zoom: -3);

  String _poiToHighlight = "-mtcd5jwpv3bukpewpu_";
  String _routePOIDestination = "-mtc1mhp6t5hwg9zdidy";
  String _routePOIOrigin = "-ltfb2qqdg6jgwqhf1_i";
  ReferencePoint _routeOriginCoordinates =
      ReferencePoint(coordX: 340, coordY: 1450, floor: 1);
  ReferencePoint _routeDestinationCoordinates =
      ReferencePoint(coordX: 1870, coordY: 480, floor: 1);

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    await _zaptSdkFlutterPlugin.initialize(placeId);
    Map<String, String> dialogOptions = {
      'titleAlert': 'Esse app necessita de acesso a localização',
      'messageAlert':
          'Para te apresentarmos notificações por proximidades necessitamos da permissão de localização sempre',
      'titleNoGranted':
          'Funcionalidade limitada sem a permissão de localização',
      'messageNoGranted':
          'Como a permissão de localização o tempo todo não foi concedida esse ap não vai te enviar as melhores notificações por proximidade. Para alterar a permissão acesse: Configurações -> Aplicativos -> Permissões e conceda a permissão total'
    };
    await _zaptSdkFlutterPlugin.requestPermissions();
    //Uncomment this to background location
    //await _zaptSdkFlutterPlugin.requestPermissionsBackground(dialogOptions);
    await _zaptSdkFlutterPlugin.setDisableSyncingForAnalytics(false);
    await _zaptSdkFlutterPlugin.setDisableSyncingForPositioning(true);
    String mapLink = "";
    mapLink = await _zaptSdkFlutterPlugin
            .getMapLink({'placeId': placeId, 'options': options}) ??
        '';
    debugPrint(mapLink);

    await _zaptSdkFlutterPlugin.addBeaconListener(_updateBeacons);
  }

  void _updateBeacons(beacons) {
    if (beacons.isNotEmpty) {
      String beaconsJSON = jsonEncode(beacons);
      // debugPrint("Beacons received $beaconsJSON");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Builder(builder: (BuildContext context) {
      return Scaffold(
        floatingActionButton: Stack(
          children: [
            Positioned(
              right: 10,
              bottom: 150,
              child: FloatingActionButton(
                onPressed: () => _zaptSdkFlutterPlugin.stop(),
                child: const Icon(
                  Icons.stop,
                  size: 24,
                ),
              ),
            ),
            Positioned(
              right: 10,
              bottom: 80,
              child: FloatingActionButton(
                onPressed: () => _openRoutesOptions(context),
                child: const Icon(
                  Icons.room,
                  size: 24,
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              right: 10,
              child: FloatingActionButton(
                onPressed: () => _openMapOptions(context),
                child: const Icon(
                  Icons.tune,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
        body: ZaptMap(
          placeId: placeId,
          options: options,
          onCreated: (controller) {
            setState(() {
              _controller = controller;
            });
          },
          onChangeMapStatus: (loading) => setState(() {
            _mapIsLoading = loading;
          }),
          onCancelRoute: () => debugPrint("Route canceled"),
          // Passing this attribute disables popup when clicking on the POI
          onMapClick: (interestClicked, clickedPoint, clickInsidePOI) {
            debugPrint("Interest Id clicked ${interestClicked.id}");
            debugPrint("Clicked inside POI area $clickInsidePOI");
            debugPrint(
                "Clicked point: X: ${clickedPoint.x}  Y: ${clickedPoint.y}");
          },
        ),
      );
    }));
  }

  void _openRoutesOptions(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) => RoutesToolbox(
              disableControls: _mapIsLoading,
              zaptSDKController: _controller,
              routePOIOrigin: _routePOIOrigin,
              routePOIDestination: _routePOIDestination,
              routeDestinationCoordinates: _routeDestinationCoordinates,
              routeOriginCoordinates: _routeOriginCoordinates,
              onChangePOIOrigin: (value) =>
                  setState(() => {_routePOIOrigin = value}),
              onChangePOIDestination: (value) =>
                  setState(() => {_routePOIDestination = value}),
              onChangeRouteCoordinatesOrigin: (routeCoordinates) =>
                  setState(() => {_routeOriginCoordinates = routeCoordinates}),
              onChangeRouteCoordinatesDestination: (routeCoordinates) =>
                  setState(
                      () => {_routeDestinationCoordinates = routeCoordinates}),
            ));
  }

  void _openMapOptions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => Toolbox(
        disableControls: _mapIsLoading,
        zaptSDKController: _controller,
        mapZoom: _mapZoom,
        rotation: _mapRotation,
        currentFloorId: _mapFloor,
        mapCenter: _mapCenter,
        poiToHighlight: _poiToHighlight,
        onZoomChange: (zoom) {
          _controller?.setZoom(zoom);
          setState(() {
            _mapZoom = zoom;
          });
        },
        onFloorChange: (currentFloor) => setState(() {
          _mapFloor = currentFloor;
        }),
        onChangeMapCenter: (mapCenter) => setState(() {
          _mapCenter = mapCenter;
        }),
        onChangeRotation: (rotation) => setState(() {
          _mapRotation = rotation;
        }),
        onChangePoiToHighlight: (poiId) => setState(() {
          _poiToHighlight = poiId;
        }),
      ),
    );
  }
}
