import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

class DeviceComponent {
  final String name;
  final String description;
  final String type;
  final int gpio;
  final bool isInput;
  bool isFavorite;
  bool isActive;

  DeviceComponent(
      {@required this.name,
      this.description,
      @required this.type,
      @required this.gpio,
      @required this.isInput,
      this.isFavorite = false,
      this.isActive = true});
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

  Device(
      {@required this.id,
      @required this.name,
      this.description,
      this.component,
      this.user,
      this.room,
      this.isFavorite = false,
      this.isActive = true});
}

class Devices with ChangeNotifier {
  final String userUID;

  Devices(this.userUID, this._devices);

  List<Device> _devices = [];

  List<Device> get devices {
    return [..._devices];
  }

  List<Device> get favoritesItems {
    return _devices.where((device) => device.isFavorite).toList();
  }

  Device findById(String id) {
    return _devices.firstWhere((device) => device.id == id);
  }

  Future<void> toggleActiveStatus(String id) async {
    _devices.forEach((device) {
      if (device.id == id) {
        device.isActive = true;
      } else {
        device.isActive = false;
      }
    });
    notifyListeners();
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
          print(deviceComponent);
          componentList.add(DeviceComponent(
            name: deviceComponent["name"],
            description: deviceComponent["description"],
            type: deviceComponent["type"],
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
            isActive: device["is_active"],
            room: List<String>.from(device["room"]),
            user: List<String>.from(device["user"]),
            component: componentList,
          ),
        );
      });

      if (loadingDevices.length > 0) {
        loadingDevices.first.isActive = true;
      }
      _devices = loadingDevices;
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

  // Future<void> updateRoom(String id, newRoom) async {
  //   final roomIndex = _rooms.indexWhere((room) => room.id == id);
  //   if (roomIndex >= 0) {
  //     try {
  //       await _firestore.collection("rooms").doc(id).update({
  //         "id": newRoom["id"],
  //         "name": newRoom["name"],
  //         "description": newRoom["description"],
  //         "image_url": newRoom["image_url"],
  //         "type": newRoom["type"],
  //         "is_favorite": newRoom["is_favorite"],
  //         "status": newRoom["status"],
  //         "user_uid": userUID,
  //       });

  //       _rooms[roomIndex] = Room(
  //         id: id,
  //         name: newRoom["name"],
  //         imageUrl: newRoom["image_url"],
  //         type: _returnRoomType(newRoom["type"])['type'],
  //         imageIcon: _returnRoomType(newRoom["type"])['imageIcon'],
  //         description: newRoom["description"],
  //         isFavorite: newRoom["is_favorite"],
  //         status: newRoom["status"],
  //         userUID: userUID,
  //       );
  //       notifyListeners();
  //     } catch (error) {
  //       throw error;
  //     }
  //   } else {
  //     print('...');
  //   }
  // }

  // Future<void> deleteProduct(String id) async {
  //   final url =
  //       'https://flutter-app-47e55.firebaseio.com/products/$id.json?auth=$authToken';
  //   final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
  //   var existingProduct = _items[existingProductIndex];

  //   //remove localy
  //   _items.removeAt(existingProductIndex);
  //   notifyListeners();

  //   ///remove from server
  //   final response = await http.delete(url);

  //   if (response.statusCode >= 400) {
  //     _items.insert(existingProductIndex, existingProduct);
  //     notifyListeners();
  //     throw HttpException('Could not delete product');
  //   }

  //   existingProduct = null;
  // }
}
