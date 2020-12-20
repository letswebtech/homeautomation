import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/rooms.dart';
import '../../widgets/form_submit_button.dart';

import '../../containts.dart';

class CreateRoomScreen extends StatelessWidget {
  static const routeName = 'room/create';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Room"),
      ),
      body: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _name;
  String _type;
  bool _is_favourite = false;
  bool _status = false;
  String _description;
  String _image_url;

  final _nameFocusNode = FocusNode();
  final _typeFocusNode = FocusNode();
  final _is_favouriteFocusNode = FocusNode();
  final _is_statusFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _image_urlFocusNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      decoration: kTextFieldStyle.copyWith(labelText: "Name"),
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      focusNode: _nameFocusNode,
      onFieldSubmitted: (_value) {
        FocusScope.of(context).requestFocus(_typeFocusNode);
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

  Widget _buildType() {
    return DropdownButtonFormField(
      decoration: kTextFieldStyle.copyWith(labelText: "Type"),
      items: kRoomType.map<DropdownMenuItem<String>>((String _value) {
        return DropdownMenuItem<String>(
          value: _value,
          child: Text(_value),
        );
      }).toList(),
      onChanged: (_value) {
        FocusScope.of(context).requestFocus(_descriptionFocusNode);
        print(_value);
      },
      focusNode: _typeFocusNode,
      validator: (String value) {
        if (value == null) {
          return 'Type is Required';
        }
        _type = value;
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
      textInputAction: TextInputAction.next,
      focusNode: _descriptionFocusNode,
      onFieldSubmitted: (_value) {
        FocusScope.of(context).requestFocus(_image_urlFocusNode);
      },
      validator: (String value) {
        _description = value;
        return null;
      },
    );
  }

  Widget _buildImage() {
    return TextFormField(
      decoration: kTextFieldStyle.copyWith(labelText: "Image URL"),
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.next,
      focusNode: _image_urlFocusNode,
      onFieldSubmitted: (_value) {
        FocusScope.of(context).requestFocus(_is_favouriteFocusNode);
      },
      validator: (String value) {
        if (value.isEmpty) {
          return 'Image URL is Required';
        }
        _image_url = value;
        return null;
      },
    );
  }

  Widget _buildFavourite() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Favourite",
          style: kHeadingLableTextStyle,
        ),
        Switch.adaptive(
          focusNode: _is_favouriteFocusNode,
          value: _is_favourite,
          activeColor: Colors.green,
          onChanged: (bool isSwitched) {
            FocusScope.of(context).requestFocus(_is_statusFocusNode);
            setState(() {
              _is_favourite = isSwitched;
            });
          },
        )
      ],
    );
  }

  Widget _buildStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Active",
          style: kHeadingLableTextStyle,
        ),
        Switch.adaptive(
          focusNode: _is_statusFocusNode,
          value: _status,
          activeColor: Colors.green,
          onChanged: (bool isSwitched) {
            setState(() {
              _status = isSwitched;
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
                    _buildType(),
                    _buildDescription(),
                    _buildImage(),
                    _buildFavourite(),
                    _buildStatus(),
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
                        "name": _name,
                        "type": _type,
                        "description": _description,
                        "image_url": _image_url,
                        "is_favourite": _is_favourite,
                        "status": _status,
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
                      await Provider.of<Rooms>(context, listen: false)
                          .addRoom(room);
                      Navigator.of(context).pop();
                    } catch (error) {
                      var errorMessage = 'Something Went Wrong!';
                      if (error.toString().contains('wrong-password')) {
                        errorMessage = 'Invalid Password!';
                      } else if (error.toString().contains('user-not-found')) {
                        errorMessage = 'User Not Found';
                      } else if (error
                          .toString()
                          .contains('email-already-in-use')) {
                        errorMessage = 'Email Already In Use';
                      }
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
