import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

class DeviceComponent {
  String name;
  String description;
  String type;
  int gpio;
  bool isInput;
  bool status;
  bool isFavorite;
  bool isActive;
  final String deviceID;

  DeviceComponent(
      {@required this.name,
      this.description,
      @required this.type,
      @required this.gpio,
      @required this.isInput,
      this.isFavorite = false,
      this.isActive = true,
      this.status = false,
      this.deviceID});
}

class Device {
  final String id;
  final String name;
  final String description;
  final List<DeviceComponent> component;
  final List<String> user;
  final List<String> room;
  bool isFavorite;
  bool isActive;
  bool status;

  Device({
    @required this.id,
    @required this.name,
    this.description,
    this.component,
    this.user,
    this.room,
    this.isFavorite = false,
    this.status = false,
    this.isActive = true,
  });
}

class Devices with ChangeNotifier {
  final String userUID;

  Devices(this.userUID, this._devices);

  List<Device> _devices = [];

  List<DeviceComponent> _componentList = [];

  List<Device> get devices {
    return [..._devices];
  }

  List<DeviceComponent> get deviceComponents {
    return [..._componentList];
  }

  List<Device> get favoritesItems {
    return _devices.where((device) => device.isFavorite).toList();
  }

  Device findById(String id) {
    return _devices.firstWhere((device) => device.id == id);
  }

  Future<void> fetchAndSetDevices() async {
    try {
      //final extractData = await _firestore.collection("devices").get();
      final extractData = await _firestore
          .collection("devices")
          .where("user", arrayContainsAny: [userUID]).get();

      final List<Device> loadingDevices = [];
      extractData.docs.forEach((deviceSnapshot) {
        final device = deviceSnapshot.data();
        final List<DeviceComponent> componentList = [];

        device["component"].forEach((deviceComponent) {
          componentList.add(DeviceComponent(
            deviceID: deviceSnapshot.id,
            name: deviceComponent["name"],
            description: deviceComponent["description"],
            type: deviceComponent["type"],
            status: false,
            gpio: deviceComponent["gpio"],
            isInput: deviceComponent["is_input"],
            isActive: deviceComponent["is_active"],
            isFavorite: deviceComponent["is_favorite"],
          ));
        });

        loadingDevices.add(
          Device(
            id: deviceSnapshot.id,
            name: device["name"],
            description: device["description"],
            isFavorite: device["is_favorite"],
            status: false,
            isActive: device["is_active"],
            room: List<String>.from(device["room"]),
            user: List<String>.from(device["user"]),
            component: componentList,
          ),
        );
      });

      _devices = loadingDevices;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchAndSetComponents([deviceID]) async {
    try {
      final List<DeviceComponent> loadingComponentList = [];

      _devices.forEach((device) {
        bool deviceFound;
        if (deviceID != null) {
          deviceFound = device.id == deviceID ? true : false;
        } else {
          deviceFound = true;
        }

        if (deviceFound) {
          device.component.forEach((deviceComponent) {
            loadingComponentList.add(DeviceComponent(
              deviceID: device.id,
              name: deviceComponent.name,
              description: deviceComponent.description,
              type: deviceComponent.type,
              gpio: deviceComponent.gpio,
              status: deviceComponent.status,
              isInput: deviceComponent.isInput,
              isActive: deviceComponent.isActive,
              isFavorite: deviceComponent.isFavorite,
            ));
          });
        }
      });

      _componentList = loadingComponentList;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addAndVerifyDevice(deviceID) async {
    try {
      await _firestore.collection("devices").doc(deviceID).update({
        "user": FieldValue.arrayUnion([userUID])
      });

      final deviceData =
          await _firestore.collection("devices").doc(deviceID).get();
      final device = deviceData.data();

      final newDevice = Device(
        id: deviceID,
        name: device["name"],
        description: device["description"],
        isFavorite: device["is_favorite"],
        isActive: device["is_active"],
        room: device["room"],
        user: device["user"],
        component: device["component"],
      );

      _devices.add(newDevice);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> createDevice(device) async {
    try {
      final tempComponent = [];
      device["component"].forEach((component) {
        tempComponent.add({
          "name": component.name,
          "description": component.description,
          "type": component.type,
          "gpio": component.gpio,
          "is_input": component.isInput,
          "is_favorite": component.isFavorite,
          "is_active": component.isActive
        });
      });

      final deviceSnapshot = await _firestore.collection("devices").add({
        "name": device["name"],
        "description": device["description"],
        "is_favorite": device["is_favorite"],
        "is_active": device["is_active"],
        "room": device["room"],
        "user": device["user"],
        "component": tempComponent,
      });

      final newDevice = Device(
        id: deviceSnapshot.id,
        name: device["name"],
        description: device["description"],
        isFavorite: device["is_favorite"],
        isActive: device["is_active"],
        room: device["room"],
        user: device["user"],
        component: device["component"],
      );

      _devices.add(newDevice);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateDevice(String id, newDevice) async {
    final deviceIndex = _devices.indexWhere((device) => device.id == id);
    if (deviceIndex >= 0) {
      try {
        final tempComponent = [];
        newDevice["component"].forEach((component) {
          tempComponent.add({
            "name": component.name,
            "description": component.description,
            "type": component.type,
            "gpio": component.gpio,
            "is_input": component.isInput,
            "is_favorite": component.isFavorite,
            "is_active": component.isActive
          });
        });

        await _firestore.collection("devices").doc(id).update({
          "name": newDevice["name"],
          "description": newDevice["description"],
          "is_favorite": newDevice["is_favorite"],
          "is_active": newDevice["is_active"],
          "room": newDevice["room"],
          "user": newDevice["user"],
          "component": tempComponent,
        });

        _devices[deviceIndex] = Device(
          id: id,
          name: newDevice["name"],
          description: newDevice["description"],
          isFavorite: newDevice["is_favorite"],
          isActive: newDevice["is_active"],
          room: newDevice["room"],
          user: newDevice["user"],
          component: newDevice["component"],
        );
        notifyListeners();
      } catch (error) {
        throw error;
      }
    } else {
      print('...');
    }
  }

  //get live status of devices
  liveDeviceStatus(dataArr) async {
    try {
      final deviceIndex =
          _devices.indexWhere((device) => device.id == dataArr["deviceUID"]);
      if (deviceIndex >= 0) {
        final gpioStatus = jsonDecode(dataArr["gpioStatus"]);
        final List<DeviceComponent> tempComponent = [];
        _devices[deviceIndex].component.forEach((component) {
          var compIndex = gpioStatus[0]["gpio"].indexOf(component.gpio.toInt());
          if (compIndex >= 0) {
            tempComponent.add(DeviceComponent(
              deviceID: component.deviceID,
              name: component.name,
              description: component.description,
              type: component.type,
              gpio: component.gpio,
              status: gpioStatus[0]["status"][compIndex] == 1,
              isInput: component.isInput,
              isActive: component.isActive,
              isFavorite: component.isFavorite,
            ));
          }
        });

        _devices[deviceIndex] = Device(
          id: _devices[deviceIndex].id,
          name: _devices[deviceIndex].name,
          description: _devices[deviceIndex].description,
          isFavorite: _devices[deviceIndex].isFavorite,
          isActive: _devices[deviceIndex].isActive,
          room: _devices[deviceIndex].room,
          status: true,
          user: _devices[deviceIndex].user,
          component: tempComponent,
        );
        await fetchAndSetComponents(_devices[deviceIndex].id);
      }
    } catch (error) {
      throw error;
    }
  }
}
