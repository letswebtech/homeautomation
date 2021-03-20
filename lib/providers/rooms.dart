import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'devices.dart';

final _firestore = FirebaseFirestore.instance;

enum RoomType {
  Bedroom,
  DrawingRoom,
  DinningRoom,
  LivingRoom,
  Kitchen,
  Store,
  Balcony,
  Corridor,
  Garage,
  BathRoom,
  WashRoom,
  Others
}

Map<String, dynamic> _returnRoomType(String type) {
  if (type == "Bedroom") {
    return {
      "imageIcon": AssetImage("assets/images/room/bed-icon.png"),
      "type": RoomType.Bedroom
    };
  } else if (type == "DinningRoom") {
    return {
      "imageIcon": AssetImage("assets/images/room/dinning-icon.png"),
      "type": RoomType.DinningRoom
    };
  } else if (type == "DrawingRoom") {
    return {
      "imageIcon": AssetImage("assets/images/room/room-icon.png"),
      "type": RoomType.DrawingRoom
    };
  } else if (type == "LivingRoom") {
    return {
      "imageIcon": AssetImage("assets/images/room/living-icon.png"),
      "type": RoomType.LivingRoom
    };
  } else if (type == "Kitchen") {
    return {
      "imageIcon": AssetImage("assets/images/room/kitchen-icon.png"),
      "type": RoomType.Kitchen
    };
  } else if (type == "Store") {
    return {
      "imageIcon": AssetImage("assets/images/room/store-icon.png"),
      "type": RoomType.Store
    };
  } else if (type == "Balcony") {
    return {
      "imageIcon": AssetImage("assets/images/room/balcony-icon.png"),
      "type": RoomType.Balcony
    };
  } else if (type == "Corridor") {
    return {
      "imageIcon": AssetImage("assets/images/room/room-icon.png"),
      "type": RoomType.Corridor
    };
  } else if (type == "Garage") {
    return {
      "imageIcon": AssetImage("assets/images/room/garage-icon.png"),
      "type": RoomType.Garage
    };
  } else if (type == "BathRoom") {
    return {
      "imageIcon": AssetImage("assets/images/room/bathroom-icon.png"),
      "type": RoomType.BathRoom
    };
  } else if (type == "WashRoom") {
    return {
      "imageIcon": AssetImage("assets/images/room/washroom-icon.png"),
      "type": RoomType.WashRoom
    };
  } else {
    return {
      "imageIcon": AssetImage("assets/images/room/room-icon.png"),
      "type": RoomType.Others
    };
  }
}

class Room with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final RoomType type;
  final bool isFavorite;
  final bool status;
  final String userUID;
  final IconData icon;
  final ImageProvider<Object> imageIcon;
  bool isActive;

  Room(
      {@required this.userUID,
      @required this.id,
      @required this.name,
      this.imageUrl,
      this.description,
      this.type = RoomType.Others,
      this.isFavorite = false,
      this.status = true,
      this.icon,
      this.imageIcon = const AssetImage("assets/images/room/room-icon.png"),
      this.isActive = false});
}

class Rooms with ChangeNotifier {
  final String userUID;

  Rooms(this.userUID, this._rooms);

  List<DeviceComponent> _componentList = [];

  List<DeviceComponent> get deviceComponents {
    return [..._componentList];
  }

  List<Room> _rooms = [];

  List<Room> get rooms {
    return [..._rooms];
  }

  List<Room> get favoritesItems {
    return _rooms.where((room) => room.isFavorite).toList();
  }

  Room findById(String id) {
    return _rooms.firstWhere((room) => room.id == id);
  }

  Future<void> fetchAndSetRooms() async {
    try {
      final extractData = await _firestore
          .collection("rooms")
          .where("user_uid", isEqualTo: userUID)
          .get();

      final List<Room> loadingRooms = [];
      extractData.docs.forEach((roomSnapshot) {
        final room = roomSnapshot.data();
        loadingRooms.add(
          Room(
            id: roomSnapshot.id,
            name: room["name"],
            imageUrl: room["image_url"],
            type: _returnRoomType(room["type"])['type'],
            imageIcon: _returnRoomType(room["type"])['imageIcon'],
            description: room["description"],
            isFavorite: room["is_favorite"],
            status: room["status"],
            userUID: room["user_uid"],
          ),
        );
      });
      if (loadingRooms.length > 0) {
        loadingRooms.first.isActive = true;
      }
      _rooms = loadingRooms;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAndSetComponents([roomID]) async {
    try {
      //final extractData = await _firestore.collection("devices").get();
      final extractData = await _firestore
          .collection("devices")
          .where("user", arrayContainsAny: [userUID]).get();

      final List<DeviceComponent> loadingComponentList = [];

      extractData.docs.forEach((deviceSnapshot) {
        final device = deviceSnapshot.data();

        int roomFound;
        if(roomID != null){
          roomFound = device["room"].indexWhere((room) => room == roomID);
        }else{
          roomFound = 0;
        }
        
        if (roomFound >= 0) {
          device["component"].forEach((deviceComponent) {
            loadingComponentList.add(DeviceComponent(
              deviceID: deviceSnapshot.id,
              name: deviceComponent["name"],
              description: deviceComponent["description"],
              type: deviceComponent["type"],
              gpio: deviceComponent["gpio"],
              isInput: deviceComponent["is_input"],
              isActive: deviceComponent["is_active"],
              isFavorite: deviceComponent["is_favorite"],
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

  Future<void> addRoom(room) async {
    try {
      final roomSnapshot = await _firestore.collection("rooms").add({
        "name": room["name"],
        "description": room["description"],
        "image_url": room["image_url"],
        "type": room["type"],
        "is_favorite": room["is_favorite"],
        "status": room["status"],
        "user_uid": userUID,
      });

      final newRoom = Room(
        id: roomSnapshot.id,
        name: room["name"],
        imageUrl: room["image_url"],
        type: _returnRoomType(room["type"])['type'],
        imageIcon: _returnRoomType(room["type"])['imageIcon'],
        description: room["description"],
        isFavorite: room["is_favorite"],
        status: room["status"],
        userUID: userUID,
      );

      _rooms.add(newRoom);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateRoom(String id, newRoom) async {
    final roomIndex = _rooms.indexWhere((room) => room.id == id);
    if (roomIndex >= 0) {
      try {
        await _firestore.collection("rooms").doc(id).update({
          "name": newRoom["name"],
          "description": newRoom["description"],
          "image_url": newRoom["image_url"],
          "type": newRoom["type"],
          "is_favorite": newRoom["is_favorite"],
          "status": newRoom["status"],
          "user_uid": userUID,
        });

        _rooms[roomIndex] = Room(
          id: id,
          name: newRoom["name"],
          imageUrl: newRoom["image_url"],
          type: _returnRoomType(newRoom["type"])['type'],
          imageIcon: _returnRoomType(newRoom["type"])['imageIcon'],
          description: newRoom["description"],
          isFavorite: newRoom["is_favorite"],
          status: newRoom["status"],
          userUID: userUID,
        );
        notifyListeners();
      } catch (error) {
        throw error;
      }
    } else {
      print('...');
    }
  }

liveDeviceStatus(dataArr) async {
    try {
        final gpioStatus = jsonDecode(dataArr["gpioStatus"]);
        final List<DeviceComponent> tempComponent = [];
        _componentList.forEach((component) {
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
        _componentList = tempComponent;
        notifyListeners();
    } catch (error) {
      throw error;
    }
  }
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
