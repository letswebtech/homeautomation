import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../widgets/device_item_card.dart';
import '../../providers/rooms.dart';
import '../../providers/devices.dart';
import '../../widgets/form_submit_button.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../../containts.dart';

String _id;
  String _name;
  String _description;
  List<DeviceComponent> _component;
  List<String> _user;
  List<String> _room;
  bool _is_favorite;
  bool _is_active;


class CreateDeviceScreen extends StatelessWidget {
  static const routeName = 'device/create';

  @override
  Widget build(BuildContext context) {
    final deviceID = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(deviceID == null ? "Create Device" : "Edit Device"),
      ),
      body: MainPage(deviceID),
    );
  }
}

class MainPage extends StatefulWidget {
  final String deviceID;

  MainPage(this.deviceID);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  
  List<Room> rooms;

  @override
  void initState() {
    rooms = Provider.of<Rooms>(context, listen: false).rooms;

    Device device = null;
    if (widget.deviceID != null) {
      Device device = Provider.of<Devices>(context, listen: false)
          .findById(widget.deviceID);
      _id = device.id;
      _name = device.name;
      _description = device.description;
      _component = device.component;
      _user = device.user;
      _room = device.room;
      _is_favorite = device.isFavorite;
      _is_active = device.isActive;
    }
    super.initState();
  }

  final _nameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _is_favoriteFocusNode = FocusNode();
  final _is_activeFocusNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _updatedDeviceComponent(BuildContext context, int index) => showDialog(
        context: context,
        builder: (context) {
          return UpdateDeviceComponent(index);
        },
      );

  Widget _buildName() {
    return TextFormField(
      decoration: kTextFieldStyle.copyWith(labelText: "Name"),
      initialValue: _name,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      focusNode: _nameFocusNode,
      onFieldSubmitted: (_value) {
        FocusScope.of(context).requestFocus(_descriptionFocusNode);
      },
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is Required';
        }
        _name = value;
        return null;
      },
    );
  }

  Widget _buildDescription() {
    return TextFormField(
      decoration: kTextFieldStyle.copyWith(labelText: "Description"),
      keyboardType: TextInputType.text,
      minLines: 2,
      maxLines: 5,
      initialValue: _description,
      textInputAction: TextInputAction.next,
      focusNode: _descriptionFocusNode,
      onFieldSubmitted: (_value) {
        //FocusScope.of(context).requestFocus(_image_urlFocusNode);
      },
      validator: (String value) {
        _description = value;
        return null;
      },
    );
  }

  Widget _buildRoom() {
    final _items =
        rooms.map((room) => MultiSelectItem<Room>(room, room.name)).toList();

    final _selectedItems = [];
    rooms.forEach((room) {
      if (_room.contains(room.id.toString())) {
        _selectedItems.add(room);
      }
    });

    return MultiSelectDialogField(
        items: _items,
        title: Text("Rooms"),
        selectedColor: Colors.white,
        initialValue: _selectedItems,
        decoration: BoxDecoration(
          color: kCardColor,
          border: Border.all(width: 2, color: Colors.grey),
        ),
        buttonText: Text("Room"),
        onConfirm: (results) {
          _room = [];
          results.forEach((result) {
            _room.add(result.id.toString());
          });
        });
  }

  Widget _buildAppliance() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Appliances', style: kHeadingLableTextStyle),
        SizedBox(height: 20),
        Container(
          height: _component.length > 3 ? 220 : 110,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _component.length > 3 ? 2 : 1),
            scrollDirection: Axis.horizontal,
            itemCount: _component.length,
            itemBuilder: (_, int index) {
              return DeviceItemCard(
                icon: kApplianceList[_component[index].type]["icon"],
                roomName: _component[index].name,
                statusMessage: "",
                isActive: false,
                onTap: () async {
                  _updatedDeviceComponent(context, index);
                  // await devicesData.toggleActiveStatus(devicesData.devices[index].id);
                  // Navigator.of(context).pushNamed(CreateDeviceScreen.routeName,
                  //     arguments: devicesData.devices[index].id);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFavorite() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Favorite",
          style: kHeadingLableTextStyle,
        ),
        Switch.adaptive(
          focusNode: _is_favoriteFocusNode,
          value: _is_favorite,
          activeColor: Colors.green,
          onChanged: (bool isSwitched) {
            FocusScope.of(context).requestFocus(_is_activeFocusNode);
            setState(() {
              _is_favorite = isSwitched;
            });
          },
        )
      ],
    );
  }

  Widget _buildActive() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Active",
          style: kHeadingLableTextStyle,
        ),
        Switch.adaptive(
          focusNode: _is_activeFocusNode,
          value: _is_active,
          activeColor: Colors.green,
          onChanged: (bool isSwitched) {
            setState(() {
              _is_active = isSwitched;
            });
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildName(),
                    _buildDescription(),
                    SizedBox(height: 20),
                    _buildRoom(),
                    SizedBox(height: 20),
                    _buildAppliance(),
                    _buildFavorite(),
                    _buildActive(),
                  ],
                ),
              ),
              FormSubmitButton(
                  lable: "Submit",
                  onPress: () async {
                    if (!_formKey.currentState.validate()) {
                      return;
                    }

                    _formKey.currentState.save();

                    try {
                      Map<String, dynamic> device = {
                        "id": _id,
                        "name": _name,
                        "description": _description,
                        "component": _component,
                        "user": _user,
                        "room": _room,
                        "is_favorite": _is_favorite,
                        "is_active": _is_active
                      };
                      Scaffold.of(context).hideCurrentSnackBar();
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Success',
                            style: kHeadingLableTextStyle.copyWith(
                                color: Colors.white),
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                      if (_id == null) {
                        //TODO : Add new device
                      } else {
                        await Provider.of<Devices>(context, listen: false)
                            .updateDevice(_id, device);
                      }
                      Navigator.of(context).pop();
                    } catch (error) {
                      var errorMessage = error.toString();
                      Scaffold.of(context).hideCurrentSnackBar();
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            errorMessage,
                            style: kHeadingLableTextStyle.copyWith(
                                color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class UpdateDeviceComponent extends StatefulWidget {

  UpdateDeviceComponent(this.deviceComponentIndex);
  final int deviceComponentIndex; 
  
  @override
  _UpdateDeviceComponentState createState() => _UpdateDeviceComponentState();
}

class _UpdateDeviceComponentState extends State<UpdateDeviceComponent> {
  final GlobalKey<FormState> _formDeviceComponentKey = GlobalKey<FormState>();

  final _nameDeviceComponentFocusNode = FocusNode();
  final _descriptionDeviceComponentFocusNode = FocusNode();
  final _typeDeviceComponentFocusNode = FocusNode();
  final _is_favoriteDeviceComponentFocusNode = FocusNode();
  final _is_activeDeviceComponentFocusNode = FocusNode();


  Widget _buildName() {
    return TextFormField(
      decoration: kTextFieldStyle.copyWith(labelText: "Name"),
      initialValue: _component[widget.deviceComponentIndex].name,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      focusNode: _nameDeviceComponentFocusNode,
      onFieldSubmitted: (_value) {
        FocusScope.of(context).requestFocus(_descriptionDeviceComponentFocusNode);
      },
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is Required';
        }
        _component[widget.deviceComponentIndex].name = value;
        return null;
      },
    );
  }

  Widget _buildDescription() {
    return TextFormField(
      decoration: kTextFieldStyle.copyWith(labelText: "Description"),
      keyboardType: TextInputType.text,
      minLines: 2,
      maxLines: 5,
      initialValue: _component[widget.deviceComponentIndex].description,
      textInputAction: TextInputAction.next,
      focusNode: _descriptionDeviceComponentFocusNode,
      onFieldSubmitted: (_value) {
        FocusScope.of(context).requestFocus(_typeDeviceComponentFocusNode);
      },
      validator: (String value) {
        _component[widget.deviceComponentIndex].description = value;
        return null;
      },
    );
  }

  Widget _buildType() {
    return DropdownButtonFormField(
      decoration: kTextFieldStyle.copyWith(labelText: "Type"),
      value:  _component[widget.deviceComponentIndex].type,
      items: kAppliance.map<DropdownMenuItem<String>>((String _value) {
        return DropdownMenuItem<String>(
          value: _value,
          child: Text(_value),
        );
      }).toList(),
      onChanged: (_value) {
        FocusScope.of(context).requestFocus(_is_favoriteDeviceComponentFocusNode);
      },
      focusNode: _typeDeviceComponentFocusNode,
      validator: (String value) {
        if (value == null) {
          return 'Type is Required';
        }
         _component[widget.deviceComponentIndex].type = value;
        return null;
      },
    );
  }

  Widget _buildFavorite() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Favorite",
          style: kHeadingLableTextStyle,
        ),
        Switch.adaptive(
          focusNode: _is_favoriteDeviceComponentFocusNode,
          value: _component[widget.deviceComponentIndex].isFavorite,
          activeColor: Colors.green,
          onChanged: (bool isSwitched) {
            FocusScope.of(context).requestFocus(_is_activeDeviceComponentFocusNode);
            setState(() {
              _component[widget.deviceComponentIndex].isFavorite = isSwitched;
            });
          },
        )
      ],
    );
  }

  Widget _buildActive() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Active",
          style: kHeadingLableTextStyle,
        ),
        Switch.adaptive(
          focusNode: _is_activeDeviceComponentFocusNode,
          value: _component[widget.deviceComponentIndex].isActive,
          activeColor: Colors.green,
          onChanged: (bool isSwitched) {
            setState(() {
              _component[widget.deviceComponentIndex].isActive = isSwitched;
            });
          },
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Update Appliance"),
      content: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Form(
                  key: _formDeviceComponentKey,
                  child: Column(
                    children: <Widget>[
                      _buildName(),
                      _buildDescription(),
                      _buildType(),
                      _buildFavorite(),
                      _buildActive(),
                    ],
                  ),
                ),
                FormSubmitButton(
                    lable: "Submit",
                    onPress: () async {
                      if (!_formDeviceComponentKey.currentState.validate()) {
                        return;
                      }
                      _formDeviceComponentKey.currentState.save();
                      Scaffold.of(context).hideCurrentSnackBar();
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Success',
                              style: kHeadingLableTextStyle.copyWith(
                                  color: Colors.white)),
                          backgroundColor: Colors.green));
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
