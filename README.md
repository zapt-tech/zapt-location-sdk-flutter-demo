# zapt_sdk_flutter

Flutter plugin for integrating [Zapt Tech](https://zapt.tech/) indoor location and mapping SDKs into iOS and Android apps.

**Current version:** 2.1.1

## Getting started

### Flutter Installation

[Install](https://docs.flutter.dev/get-started/install) the Flutter SDK on your machine.

### Run Example

From the `/example` folder:

```bash
flutter pub get
flutter run
```

### Deploy Package

1. Run `$ npm run deploy:verify` to validate the package before publishing.
2. Run `$ npm run deploy` to publish the package to pub.dev.

### Installing in another project

In the root folder of your Flutter project:

```bash
flutter pub add zapt_sdk_flutter
```

### Requirements

| Requirement                 | Version        |
| --------------------------- | -------------- |
| Flutter                     | 3.0.0+         |
| Xcode                       | 14.0+          |
| iOS deployment target       | iOS 13.0+      |
| Swift Package Manager (SPM) | Recommended    |
| CocoaPods                   | Optional (1.2.0+) — not recommended |
| Java Compiler               | 17             |
| Android SDK (minSdkVersion) | Android API 21 |

### iOS integration

Starting with **2.1.0**, the native iOS layer is integrated via **Swift Package Manager (SPM)**. This is the recommended and default path for new projects.

When you add this plugin and run `flutter pub get`, Flutter resolves the iOS dependencies through SPM automatically — no extra native setup is required in most cases.

#### Swift Package Manager (recommended)

- Ensure your app targets **iOS 13.0+**.
- Use Flutter **3.0+** with a recent Xcode toolchain.
- Build as usual with `flutter run` or `flutter build ios`.

The plugin declares its iOS package in `ios/zapt_sdk_flutter/Package.swift`, which pulls in [ZaptLocation-iOS-SDK](https://github.com/zapt-tech/zapt-location-ios-sdk) and required Flutter plugin dependencies.

#### CocoaPods (optional, not recommended)

CocoaPods support remains available through `ios/zapt_sdk_flutter.podspec` for legacy projects that still rely on a `Podfile`.

**We do not recommend CocoaPods for new integrations.** The CocoaPods trunk registry is [planned to become read-only](https://blog.cocoapods.org/CocoaPods-Specs-Repo/) — no new pod versions will be accepted after **December 2026**. Existing builds may continue to work, but dependencies distributed only through CocoaPods will stop receiving updates. Prefer SPM for all new work.

If you must stay on CocoaPods, keep CocoaPods **1.2.0+** and your existing `pod install` workflow.

### Usage

After the installation is done according to the steps above, just import the package into the desired file.

```dart
import 'package:zapt_sdk_flutter/zapt_sdk_flutter.dart';
```

### Link to location on maps

The function presented just below provides a link that can be used in a WebView or similar HTML rendering component. This link renders a map that shows the user's location in real time.

```dart
final _zaptSdkFlutterPlugin = ZaptSdkFlutter();
Map<String, String> options = {'floorId': '1'};
final String placeId = "-ltvysf4acgzdxdhf81y";

String mapLink = ""
mapLink = await _zaptSdkFlutterPlugin.getMapLink({'placeId': placeId, 'options': options});
```
### ZaptMap Widget

The `ZaptMap` Widget brings a real-time location map implementation, ready to be integrated into the APP.

````dart
import 'package:zapt_sdk_flutter/zapt_sdk_flutter.dart';

class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  Map<String, String> options = {'floorId': '1'};
  final String placeId = "-ltvysf4acgzdxdhf81y";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ZaptMap(
          placeId: placeId,
          options: options, //optional
          onCreated: (controller) => setState((){
          	_controller = controller,
        	}),
        ),
    );
  }
}
````

Note: Both in the `getMapLink` function and in the `ZaptMap` Widget, the `placeID` parameter is required for the Widget to work. If you have not yet received your location's unique identifier (PLACE_ID), please contact us at contato@zapt.tech.

### Controller -  Interacting with map

The ZaptMap Widget returns a controller through the onCreated callback, as shown in the example above. This controller provides methods for interacting with the map:

#### Change Floor

- **setFloor** - This method returns a Future that is resolved as soon as the new floor is initialized.

  Example: 

  ```dart
  zaptController.setFloor(0);
  ```

  

- **setMapId** - This method returns a Future that is resolved as soon as the new map is initialized.

  Example: 

  ```dart
  zaptController.mapId("-ltvysf4acgzdxdhf81y-floor0");
  ```

  

#### Centralize

- **setCenter** - Center the map according to a `MapCenter` instance with horizontal(x) and vertical(y) coordinates. You can pass zoom as an attribute or define it later.

  Example: 

  ```dart
  zaptController.setCenter(MapCenter(x:100, y:100, zoom: 0));
  ```

  

- **highlightInterestById** - It takes the unique id of the POI as a parameter and centers the map on the POI coordinates.

  Example: 

  ```dart
  zaptController.highlightInterestById("-mtcd5jwpv3bukpewpu_");
  ```

  

- **removeHighlightInterest** - Removes the focus from the POI, receives a `bool` as a parameter, which when true returns the map to the center and initial zoom.

  Example: 

  ```dart
  zaptController.removeHighlightInterest();
  ```

#### Set Zoom

- **setZoom** - Receives the zoom value as a parameter. This value must be min ≤ zoom ≤ max, where min and max are defined in the map configuration.

  Example: 

  ```dart
  zaptController.setZoom(0);
  ```

  

#### Rotate Map

- **setRotation** - Receives as a parameter the value of the angle in degrees.

  Example: 

  ```dart
  zaptController.setRotation(180);
  ```

  

#### Start Route

- **createRouteByIds** - It traces a route between two POIs receiving as a parameter the ids of the points of interest of origin and destination respectively.

  Example: 

  ```dart
  zaptController.createRouteByIds("-mtc1mhp6t5hwg9zdidy", "-ltfb2qqdg6jgwqhf1_i");
  ```

  

- **createRouteByCoordinates** - Receives as a parameter an instance of `ReferencePoint` for the origin and one for the destination.

  Example: 

  ```dart
  zaptController.createRouteByIds(
      ReferencePoint(coordX: 340, coordY: 1130, floor: 1),
      ReferencePoint(coordX: 340, coordY: 1130, floor: 1)
  );
  ```

- **removeRoute** - Removes the traced route.

  Example: 

  ```dart
  zaptController.removeRoute();
  ```

### Monitoring Map Events

In the `ZaptMap` Widget it is possible to pass callbacks to listen to map events:

**onChangeMapStatus**

Through this callback it is possible to receive the map loading status as soon as it starts or finishes initializing.

```dart
 ZaptMap(
    ...
    onChangeMapStatus: (loading) => setState((){
      _mapIsLoading = loading;
    }),
  )
```

#### onMapStartsLoading

This callback is called every time a map starts loading. It receives as parameters the ID of the visitable, the ID of the floor that will be loaded, the name of the floor that will be loaded and the loading status of the map.

```dart
ZaptMap(
    ...
    onMapStartsLoading: (mapInfo) {
        debugPrint("Changing to floor name: ${mapInfo.floorName}");
        debugPrint("Changing to floor ID: ${mapInfo.floorId}");
        debugPrint("Changing to place ID: ${mapInfo.placeId}");
 	},
)
```

#### onMapFinishesLoading

This callback is called every time a map finishes loading. It receives as parameters the ID of the visitable, the ID of the floor that was loaded, the name of the floor that was loaded and the loading status of the map.

```dart
ZaptMap(
	...
	onMapFinishesLoading: (mapInfo) {
        debugPrint("Loaded on the floor name: ${mapInfo.floorName}");
        debugPrint("Loaded on the floor ID: ${mapInfo.floorId}");
        debugPrint("Loaded on the place ID: ${mapInfo.placeId}");
    },
)
```

**onCancelRoute**

This callback is called every time a route is canceled.

```dart
 ZaptMap(
    ...
    onCancelRoute: ()=> debugPrint("Route canceled"),
  )
```

#### onMapClick

This callback is called when the map is clicked. It receives as parameters the POI closest to the click, the coordinates of the exact point where the map was clicked and as a third parameter whether the click was inside the POI area.

When passing a function to this callback, the default behavior of opening a popup on the clicked POI ceases to happen.

```dart
 ZaptMap(
    ...
    onMapClick: (interestClicked, clickedPoint, clickInsidePOI) {
      debugPrint("Interest Id clicked ${interestClicked.id}");
      debugPrint("Clicked inside POI area $clickInsidePOI");
      debugPrint(
          "Clicked point: X: ${clickedPoint.x}  Y: ${clickedPoint.y}");
    },
  )
```



### Permissions Request

As soon as the Map is initialized in the APP for the first time, permission will be requested to access the device's location, but if necessary, this permission can be requested at an earlier time through the `requestPermissions()` function.

##### Troubleshooting

If you are experiencing the following error when deploying to iOS **with CocoaPods**:

```swift
error: include of non-modular header inside framework module 'zapt_sdk_flutter.ZaptSdkFlutterPlugin'
```

See the solution in [this link](https://stackoverflow.com/a/30697222). This issue does not apply when using the recommended SPM integration.

### Layout Options 

The `getMapLink` function (second parameter) and the `ZaptMap` Widget (`options` parameter) accept options to customize the map view.

| Name             | Type | Default | Description	|
| ---------------- | ---- | --------| --------------|
| bottomNavigation | bool | true    | If true shows the bottom bar                                 |
| appBar           | bool | true    | If true shows the top bar                                    |
| search           | bool | true    | If true shows search field (on large screens)                |
| splash           | bool | true    | If true shows Zapt Tech splash, if false shows generic splash |
| navBar           | bool | true    | If true shows the nav bar                                    |
| embed            | bool | false   | If true removes all options                                  |

### Functional Options

In addition to the layout options, the options attribute also receives an option for map functionality.

| Name     | Type   | Description                               |
| -------- | ------ | ----------------------------------------- |
| floorId  | string | Gets the ID of the floor on which the map should be launched. See this ID in the [Portal](https://portal.zapt.tech/#/). |
| zoom     | number | Set the initial zoom of the map. The zoom value must be between the minimum and maximum limits defined in the map settings. |
| rotation | number | Defines an initial map rotation angle. This value can be between 0 and 360. |
| poi      | string | Receives the ID of a point of interest and centers the map on it. See this ID in the [Portal](https://portal.zapt.tech/#/). |

### Center by Coordinates

| Name    | Type   | Description                                    |
| ------- | ------ | ---------------------------------------------- |
| centerX | number | Set the initial center of the map horizontally |
| centerY | number | Set the initial center of the map horizontally |

Note: The `centerX` and `centerY` attributes must be used at the same time to work.

### Plot routes with points of interest

| Name    | Type   | Description                                         |
| ------- | ------ | --------------------------------------------------- |
| fromPoi | string | ID of a point of interest for the start of a route. |
| toPoi   | string | ID of a point of interest for the start of a route. |

Note: You can add only the target point parameter. In this case the route will be drawn from the main entrance, if any. If only the starting point is entered, nothing will happen.

### Trace routes with coordinates

| Name            | Type   | Description                                     |
| --------------- | ------ | ----------------------------------------------- |
| fromCoordinateX | number | X coordinate (horizontal) for route origin      |
| fromCoordinateY | number | Y (vertical) coordinate for route origin        |
| fromCoordinateZ | number | Z coordinate (walk) for route origin            |
| toCoordinateX   | number | X coordinate (horizontal) for route destination |
| toCoordinateY   | number | Y (vertical) coordinate for route destination   |
| toCoordinateZ   | number | Z coordinate (walk) for route destination       |

Note: You can add only the target point parameter. In this case the route will be drawn from the main entrance, if any. If only the starting point is entered, nothing will happen.

### Draw marker

| Name    | Type   | Description                                              |
| ------- | ------ | -------------------------------------------------------- |
| markerX | number | X coordinates (horizontal) where marker should be drawn. |
| markerY | number | Y coordinates (horizontal) where marker should be drawn. |
| markerZ | number | Z coordinates (floor) where marker should be drawn.      |
