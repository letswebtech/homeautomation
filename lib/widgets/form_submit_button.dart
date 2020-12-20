import 'package:flutter/material.dart';

class FormSubmitButton extends StatelessWidget {
  
  final String lable;
  final Function onPress; 

  FormSubmitButton({
    @required this.lable,
    this.onPress
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onPressed: onPress,
      color: Colors.blue,
      textColor: Colors.white,
      disabledColor: Colors.grey,
      disabledTextColor: Colors.black,
      splashColor: Colors.blueAccent,
      child: Text(
        "$lable",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
