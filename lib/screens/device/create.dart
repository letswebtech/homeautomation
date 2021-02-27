import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/auth.dart';
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
    } else {
      _id = null;
      _name = null;
      _description = null;
      _user = [];
      _room = [];
      _is_favorite = false;
      _is_active = true;
      _component = [];
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
          return UpdateDeviceComponent(index, context);
        },
      ).then((value) => {setState(() {})});

  _addDeviceComponent(BuildContext context) => showDialog(
        context: context,
        builder: (context) {
          return UpdateDeviceComponent(null, context);
        },
      ).then((value) => {setState(() {})});

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
    final userProfile = Provider.of<Auth>(context, listen: false).userProfile;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Appliances', style: kHeadingLableTextStyle),
            if (userProfile.uid == kAdminUID)
              IconButton(
                  icon: Icon(FontAwesomeIcons.plus),
                  onPressed: () {
                    _addDeviceComponent(context);
                  }),
          ],
        ),
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
                isActive: false,
                onTap: () async {
                  _updatedDeviceComponent(context, index);
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
                        await Provider.of<Devices>(context, listen: false)
                            .createDevice(device);
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
  UpdateDeviceComponent(this.deviceComponentIndex, this.ctx);
  final int deviceComponentIndex;
  final BuildContext ctx;

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
  DeviceComponent newComponent = DeviceComponent(
    name: "",
    description: "",
    type: "Others",
    gpio: 4,
    isInput: true,
    isFavorite: false,
    isActive: true,
  );
  Widget _buildName() {
    return TextFormField(
      decoration: kTextFieldStyle.copyWith(labelText: "Name"),
      initialValue: widget.deviceComponentIndex == null
          ? ""
          : _component[widget.deviceComponentIndex].name,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      focusNode: _nameDeviceComponentFocusNode,
      onFieldSubmitted: (_value) {
        FocusScope.of(context)
            .requestFocus(_descriptionDeviceComponentFocusNode);
      },
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is Required';
        }
        if (widget.deviceComponentIndex == null) {
          newComponent = DeviceComponent(
            name: value,
            description: newComponent.description,
            type: newComponent.type,
            gpio: newComponent.gpio,
            isInput: newComponent.isInput,
            isFavorite: newComponent.isFavorite,
            isActive: newComponent.isActive,
          );
        } else {
          _component[widget.deviceComponentIndex].name = value;
        }
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
      initialValue: widget.deviceComponentIndex == null
          ? ""
          : _component[widget.deviceComponentIndex].description,
      textInputAction: TextInputAction.next,
      focusNode: _descriptionDeviceComponentFocusNode,
      onFieldSubmitted: (_value) {
        FocusScope.of(context).requestFocus(_typeDeviceComponentFocusNode);
      },
      validator: (String value) {
        if (widget.deviceComponentIndex == null) {
          newComponent = DeviceComponent(
            name: newComponent.name,
            description: value,
            type: newComponent.type,
            gpio: newComponent.gpio,
            isInput: newComponent.isInput,
            isFavorite: newComponent.isFavorite,
            isActive: newComponent.isActive,
          );
        } else {
          _component[widget.deviceComponentIndex].description = value;
        }
        return null;
      },
    );
  }

  Widget _buildGpio() {
    final userProfile = Provider.of<Auth>(context, listen: false).userProfile;
    if(userProfile.uid != kAdminUID){
      return Text("");
    }

    return TextFormField(
      decoration: kTextFieldStyle.copyWith(labelText: "GPIO"),
      keyboardType: TextInputType.number,
      initialValue: widget.deviceComponentIndex == null
          ? "22"
          : _component[widget.deviceComponentIndex].gpio.toString(),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_value) {},
      validator: (String value) {
        if (int.tryParse(value) == null) {
          return "Must be an integer";
        }

        if (widget.deviceComponentIndex == null) {
          newComponent = DeviceComponent(
            name: newComponent.name,
            description: newComponent.description,
            type: newComponent.type,
            gpio: int.parse(value),
            isInput: newComponent.isInput,
            isFavorite: newComponent.isFavorite,
            isActive: newComponent.isActive,
          );
        } else {
          _component[widget.deviceComponentIndex].gpio = int.parse(value);
        }
        return null;
      },
    );
  }

  Widget _buildType() {
    
    return DropdownButtonFormField(
      decoration: kTextFieldStyle.copyWith(labelText: "Type"),
      value: widget.deviceComponentIndex == null
          ? null
          : _component[widget.deviceComponentIndex].type,
      items: kAppliance.map<DropdownMenuItem<String>>((String _value) {
        return DropdownMenuItem<String>(
          value: _value,
          child: Text(_value),
        );
      }).toList(),
      onChanged: (_value) {
        FocusScope.of(context)
            .requestFocus(_is_favoriteDeviceComponentFocusNode);
      },
      focusNode: _typeDeviceComponentFocusNode,
      validator: (String value) {
        if (value == null) {
          return 'Type is Required';
        }
        if (widget.deviceComponentIndex == null) {
          newComponent = DeviceComponent(
            name: newComponent.name,
            description: newComponent.description,
            type: value,
            gpio: newComponent.gpio,
            isInput: newComponent.isInput,
            isFavorite: newComponent.isFavorite,
            isActive: newComponent.isActive,
          );
        } else {
          _component[widget.deviceComponentIndex].type = value;
        }
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
          value: widget.deviceComponentIndex == null
              ? false
              : _component[widget.deviceComponentIndex].isFavorite,
          activeColor: Colors.green,
          onChanged: (bool isSwitched) {
            FocusScope.of(context)
                .requestFocus(_is_activeDeviceComponentFocusNode);
            setState(() {
              if (widget.deviceComponentIndex == null) {
                newComponent = DeviceComponent(
                  name: newComponent.name,
                  description: newComponent.description,
                  type: newComponent.type,
                  gpio: newComponent.gpio,
                  isInput: newComponent.isInput,
                  isFavorite: isSwitched,
                  isActive: newComponent.isActive,
                );
              } else {
                _component[widget.deviceComponentIndex].isFavorite = isSwitched;
              }
            });
          },
        )
      ],
    );
  }

  Widget _buildInput() {
    final userProfile = Provider.of<Auth>(context, listen: false).userProfile;
    if(userProfile.uid != kAdminUID){
      return Text("");
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Input",
          style: kHeadingLableTextStyle,
        ),
        Switch.adaptive(
          value: widget.deviceComponentIndex == null
              ? false
              : _component[widget.deviceComponentIndex].isInput,
          activeColor: Colors.green,
          onChanged: (bool isSwitched) {
            setState(() {
              if (widget.deviceComponentIndex == null) {
                newComponent = DeviceComponent(
                  name: newComponent.name,
                  description: newComponent.description,
                  type: newComponent.type,
                  gpio: newComponent.gpio,
                  isInput: isSwitched,
                  isFavorite: newComponent.isFavorite,
                  isActive: newComponent.isActive,
                );
              } else {
                _component[widget.deviceComponentIndex].isInput = isSwitched;
              }
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
          value: widget.deviceComponentIndex == null
              ? false
              : _component[widget.deviceComponentIndex].isActive,
          activeColor: Colors.green,
          onChanged: (bool isSwitched) {
            setState(() {
              if (widget.deviceComponentIndex == null) {
                newComponent = DeviceComponent(
                  name: newComponent.name,
                  description: newComponent.description,
                  type: newComponent.type,
                  gpio: newComponent.gpio,
                  isInput: isSwitched,
                  isFavorite: newComponent.isFavorite,
                  isActive: newComponent.isActive,
                );
              } else {
                _component[widget.deviceComponentIndex].isActive = isSwitched;
              }
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
      title: widget.deviceComponentIndex == null
          ? Text("Create Appliance")
          : Text("Update Appliance"),
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
                      _buildGpio(),
                      _buildInput(),
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
                      //create new device
                      if (widget.deviceComponentIndex == null) {
                        _component.add(newComponent);
                      }
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
