import 'package:flutter/material.dart';
import 'package:zapt_sdk_flutter/zapt_sdk_flutter_controller.dart';

class Toolbox extends StatelessWidget {
  const Toolbox(
      {super.key,
      required this.mapZoom,
      required this.onZoomChange,
      required this.currentFloorId,
      required this.onFloorChange,
      required this.onChangeRotation,
      required this.onChangeMapCenter,
      required this.onChangePoiToHighlight,
      required this.rotation,
      required this.mapCenter,
      required this.poiToHighlight,
      this.disableControls = false,
      this.zaptSDKController});

  final ZaptSDKController? zaptSDKController;

  final void Function(double) onZoomChange;
  final void Function(double) onChangeRotation;
  final void Function(int) onFloorChange;
  final void Function(MapCenter) onChangeMapCenter;
  final void Function(String) onChangePoiToHighlight;

  final double mapZoom;
  final double rotation;
  final int currentFloorId;
  final MapCenter mapCenter;
  final bool disableControls;
  final String poiToHighlight;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
              10, 10, 10, MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  const Text("Map Zoom"),
                  Slider(
                    value: mapZoom,
                    min: 0,
                    max: 6,
                    onChanged: disableControls ? null : onZoomChange,
                    label: mapZoom.toString(),
                  )
                ],
              ),
              MapOption(
                disabled: disableControls,
                textFields: [
                  CustomTextField(
                      disabled: disableControls,
                      value: currentFloorId.toString(),
                      labelText: "Floor ID.",
                      onChange: (value) => onFloorChange(int.parse(value)),
                      width: 135)
                ],
                onPressed: () => zaptSDKController?.setFloor(currentFloorId),
                buttonLabel: "Set Floor",
              ),
              MapOption(
                disabled: disableControls,
                textFields: [
                  CustomTextField(
                      disabled: disableControls,
                      value: rotation.toString(),
                      labelText: "Map Rotation",
                      onChange: (value) =>
                          onChangeRotation(double.parse(value)),
                      width: 135)
                ],
                onPressed: () => zaptSDKController?.setRotation(rotation),
                buttonLabel: "Set Rotation",
              ),
              MapOption(
                  disabled: disableControls,
                  onPressed: () => zaptSDKController?.setCenter(mapCenter),
                  buttonLabel: "Set Center",
                  textFields: [
                    CustomTextField(
                        disabled: disableControls,
                        value: mapCenter.x.toString(),
                        labelText: "X",
                        onChange: (value) {
                          mapCenter.x = int.parse(value);
                          onChangeMapCenter(mapCenter);
                        },
                        width: 45),
                    CustomTextField(
                        disabled: disableControls,
                        value: mapCenter.y.toString(),
                        labelText: "Y",
                        onChange: (value) {
                          mapCenter.y = int.parse(value);
                          onChangeMapCenter(mapCenter);
                        },
                        width: 45),
                    CustomTextField(
                        disabled: disableControls,
                        value: mapCenter.zoom.toString(),
                        labelText: "Z",
                        onChange: (value) {
                          mapCenter.zoom = double.parse(value);
                          onChangeMapCenter(mapCenter);
                        },
                        width: 45)
                  ]),
              MapOption(
                disabled: disableControls,
                onPressed: () => zaptSDKController?.highlightInterestById(
                    poiToHighlight, true),
                buttonLabel: "Highlight POI",
                textFields: [
                  CustomTextField(
                      type: TextInputType.text,
                      disabled: disableControls,
                      labelText: "POI. ID.",
                      onChange: (value) => onChangePoiToHighlight(value),
                      width: 135,
                      value: poiToHighlight)
                ],
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  onPressed: disableControls
                      ? null
                      : () {
                          zaptSDKController?.removeHighlightInterest(true);
                          Navigator.pop(context);
                        },
                  child: const Text("Remove POI Highlight"),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: disableControls
                      ? null
                      : () {
                          zaptSDKController?.resetMapView();
                          Navigator.pop(context);
                        },
                  child: const Text('Reset map view'),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class RoutesToolbox extends StatelessWidget {
  const RoutesToolbox(
      {super.key,
      required this.routeOriginCoordinates,
      required this.routeDestinationCoordinates,
      required this.routePOIDestination,
      required this.routePOIOrigin,
      required this.onChangePOIOrigin,
      required this.onChangePOIDestination,
      required this.onChangeRouteCoordinatesDestination,
      required this.onChangeRouteCoordinatesOrigin,
      this.disableControls = false,
      this.zaptSDKController});

  final ReferencePoint routeOriginCoordinates;
  final ReferencePoint routeDestinationCoordinates;
  final ZaptSDKController? zaptSDKController;
  final String routePOIOrigin;
  final String routePOIDestination;
  final bool disableControls;

  final Function(String) onChangePOIOrigin;
  final Function(String) onChangePOIDestination;
  final Function(ReferencePoint) onChangeRouteCoordinatesOrigin;
  final Function(ReferencePoint) onChangeRouteCoordinatesDestination;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
              10, 10, 10, MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text("Trace Route By Coordinates"),
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Origin Coordinates"),
                          MapOption(
                              disabled: disableControls,
                              showButtonAction: false,
                              onPressed: () =>
                                  zaptSDKController?.createRouteByCoordinates(
                                      routeOriginCoordinates,
                                      routeDestinationCoordinates),
                              buttonLabel: "Trace Route",
                              textFields: [
                                CustomTextField(
                                    disabled: disableControls,
                                    labelText: "X",
                                    onChange: (value) {
                                      routeOriginCoordinates.coordX =
                                          int.parse(value);
                                      onChangeRouteCoordinatesOrigin(
                                          routeOriginCoordinates);
                                    },
                                    width: 50,
                                    value: routeOriginCoordinates.coordX
                                        .toString()),
                                CustomTextField(
                                    disabled: disableControls,
                                    labelText: "Y",
                                    onChange: (value) {
                                      routeOriginCoordinates.coordY =
                                          int.parse(value);
                                      onChangeRouteCoordinatesOrigin(
                                          routeOriginCoordinates);
                                    },
                                    width: 50,
                                    value: routeOriginCoordinates.coordY
                                        .toString()),
                                CustomTextField(
                                    disabled: disableControls,
                                    labelText: "Floor",
                                    onChange: (value) {
                                      routeOriginCoordinates.floor =
                                          int.parse(value);
                                      onChangeRouteCoordinatesOrigin(
                                          routeOriginCoordinates);
                                    },
                                    width: 65,
                                    value:
                                        routeOriginCoordinates.floor.toString())
                              ]),
                        ],
                      ),
                      Column(children: [
                        const Text("Destination Coordinates"),
                        MapOption(
                            disabled: disableControls,
                            showButtonAction: false,
                            onPressed: () {
                              zaptSDKController?.createRouteByCoordinates(
                                  routeOriginCoordinates,
                                  routeDestinationCoordinates);
                            },
                            buttonLabel: "Trace Route",
                            textFields: [
                              CustomTextField(
                                  disabled: disableControls,
                                  labelText: "X",
                                  onChange: (value) {
                                    routeDestinationCoordinates.coordX =
                                        int.parse(value);
                                    onChangeRouteCoordinatesDestination(
                                        routeDestinationCoordinates);
                                  },
                                  width: 50,
                                  value: routeDestinationCoordinates.coordX
                                      .toString()),
                              CustomTextField(
                                  disabled: disableControls,
                                  labelText: "Y",
                                  onChange: (value) {
                                    routeDestinationCoordinates.coordY =
                                        int.parse(value);
                                    onChangeRouteCoordinatesDestination(
                                        routeDestinationCoordinates);
                                  },
                                  width: 50,
                                  value: routeDestinationCoordinates.coordY
                                      .toString()),
                              CustomTextField(
                                  disabled: disableControls,
                                  labelText: "Z",
                                  onChange: (value) {
                                    routeDestinationCoordinates.floor =
                                        int.parse(value);
                                    onChangeRouteCoordinatesDestination(
                                        routeDestinationCoordinates);
                                  },
                                  width: 65,
                                  value: routeDestinationCoordinates.floor
                                      .toString())
                            ]),
                      ]),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ElevatedButton(
                        onPressed: disableControls
                            ? null
                            : () {
                                zaptSDKController?.createRouteByCoordinates(
                                    routeOriginCoordinates,
                                    routeDestinationCoordinates);
                                Navigator.pop(context);
                              },
                        child: const Text("Trace Route")),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text("Trace routes by POI IDs"),
              ),
              MapOption(
                  disabled: disableControls,
                  onPressed: () => zaptSDKController?.createRouteByIds(
                      routePOIOrigin, routePOIDestination),
                  buttonLabel: "Trace Route",
                  textFields: [
                    CustomTextField(
                      disabled: disableControls,
                      type: TextInputType.text,
                      labelText: "From POI",
                      onChange: onChangePOIOrigin,
                      width: 100,
                      value: routePOIOrigin,
                    ),
                    CustomTextField(
                      disabled: disableControls,
                      type: TextInputType.text,
                      labelText: "To POI",
                      onChange: onChangePOIDestination,
                      width: 100,
                      value: routePOIDestination,
                    ),
                  ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      onPressed: disableControls
                          ? null
                          : () {
                              zaptSDKController?.removeRoute();
                              Navigator.pop(context);
                            },
                      child: const Text("Cancel Route")),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

class MapOption extends StatelessWidget {
  const MapOption(
      {super.key,
      required this.onPressed,
      required this.buttonLabel,
      required this.textFields,
      this.showButtonAction = true,
      this.disabled = false});

  final Function() onPressed;
  final String buttonLabel;
  final List<Widget> textFields;
  final bool disabled;
  final bool showButtonAction;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [...textFields];
    if (showButtonAction) {
      children.add(ElevatedButton(
          onPressed: disabled
              ? null
              : () {
                  onPressed();
                  Navigator.pop(context);
                },
          child: Text(buttonLabel)));
    }
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        children: children,
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.labelText,
      required this.onChange,
      required this.width,
      required this.value,
      this.disabled = false,
      this.type = TextInputType.number});

  final Function(String) onChange;
  final String labelText;
  final double width;
  final String value;
  final bool disabled;
  final TextInputType type;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 40,
      child: TextFormField(
        enabled: !disabled,
        keyboardType: type,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(1.0),
          labelText: labelText,
          border: const OutlineInputBorder(gapPadding: 0),
        ),
        onChanged: onChange,
        initialValue: value,
      ),
    );
  }
}
