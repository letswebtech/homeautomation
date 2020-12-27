import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/devices.dart';
import '../../widgets/form_submit_button.dart';

import '../../containts.dart';

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
  String _id;
  String _name;
  String _description;
  List<DeviceComponent> _component;
  List<String> _user;
  List<String> _room;
  bool _is_favorite;
  bool _is_active;

  @override
  void initState() {
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
    return TextFormField(
      decoration: kTextFieldStyle.copyWith(labelText: "Room"),
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
                    _buildRoom(),
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
                      Map<String, dynamic> room = {
                        "id": _id,
                        "name": _name,
                        "description": _description,
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
                        // await Provider.of<Devices>(context, listen: false)
                        //     .updateDevice(_id, room);
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
