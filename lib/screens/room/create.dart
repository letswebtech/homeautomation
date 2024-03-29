import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/rooms.dart';
import '../../widgets/form_submit_button.dart';

import '../../containts.dart';

class CreateRoomScreen extends StatelessWidget {
  static const routeName = 'room/create';

  @override
  Widget build(BuildContext context) {
    final roomID = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(roomID == null ? "Create Room" : "Edit Room"),
      ),
      body: MainPage(roomID),
    );
  }
}

class MainPage extends StatefulWidget {
  final String roomID;

  MainPage(this.roomID);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  
  String _id;
  String _name;
  String _type;
  bool _is_favorite = false;
  bool _status = false;
  String _description;
  String _image_url;

  @override
  void initState() {
    Room room = null;
    if (widget.roomID != null) {
      Room room =
          Provider.of<Rooms>(context, listen: false).findById(widget.roomID);
    _id = room.id; 
    _name = room.name;
    _type = room.type.toString().substring(room.type.toString().indexOf('.') + 1);
    _is_favorite = room.isFavorite;
    _status = room.status;
    _description = room.description;
    _image_url = room.imageUrl;
    }
    super.initState();
  }

  final _nameFocusNode = FocusNode();
  final _typeFocusNode = FocusNode();
  final _is_favoriteFocusNode = FocusNode();
  final _is_statusFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _image_urlFocusNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      decoration: kTextFieldStyle.copyWith(labelText: "Name"),
      initialValue: _name,
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
      value: _type,
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
      initialValue: _description,
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
      initialValue: _image_url,
      onFieldSubmitted: (_value) {
        FocusScope.of(context).requestFocus(_is_favoriteFocusNode);
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
            FocusScope.of(context).requestFocus(_is_statusFocusNode);
            setState(() {
              _is_favorite = isSwitched;
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
                    _buildFavorite(),
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
                        "id": _id, 
                        "name": _name,
                        "type": _type,
                        "description": _description,
                        "image_url": _image_url,
                        "is_favorite": _is_favorite,
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
                      if(_id == null){
                         await Provider.of<Rooms>(context, listen: false)
                          .addRoom(room);
                      }else{
                         await Provider.of<Rooms>(context, listen: false)
                          .updateRoom(_id ,room);
                      }
                      
                      Navigator.of(context).pop();
                    } catch (error) {
                      var errorMessage = error.toString();
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
