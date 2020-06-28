import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OptionAlertBox {
  final BuildContext context;
  final String title;
  final IconData icon;
  final String infoMessage;
  final Color titleTextColor;
  final Color messageTextColor;
  final Color buttonColorForYes;
  final Color buttonTextColorForYes;
  final String buttonTextForYes;
  final Color buttonColorForNo;
  final Color buttonTextColorForNo;
  final String buttonTextForNo;
  final VoidCallback onPressedOptionOne;
  final VoidCallback onPressedOptionTwo;
  final VoidCallback onPressedOptionThree;
  OptionAlertBox(
      {this.context,
        this.title,
        this.infoMessage,
        this.titleTextColor,
        this.messageTextColor,
        this.buttonColorForYes,
        this.buttonTextForYes,
        this.buttonTextColorForYes,
        this.buttonColorForNo,
        this.buttonTextColorForNo,
        this.buttonTextForNo,
        this.onPressedOptionOne,
        this.onPressedOptionTwo,
        this.onPressedOptionThree,
        this.icon}) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Row(
              children: <Widget>[
                Icon(
                  Icons.filter_none,
                  color: titleTextColor,
                ),
                SizedBox(
                  width: 4.0,
                ),
                Flexible(
                  child: Text(
                    title ?? "Your alert title",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: titleTextColor ?? Color(0xFF4E4E4E)),
                  ),
                )
              ],
            ),
            contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
            children: <Widget>[
              Text(
                infoMessage ?? "Alert message here",
                style: TextStyle(color: messageTextColor),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    color: buttonColorForYes ?? Colors.green,
                    onPressed: onPressedOptionOne,
                    iconSize: 30,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                 IconButton(
                   icon: Icon(Icons.photo),
                    color: buttonColorForNo ?? Colors.red,
                    onPressed: onPressedOptionTwo,
                   iconSize: 30,
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    color: buttonColorForNo ?? Colors.red,
                    onPressed: onPressedOptionThree,
                    iconSize: 30,
                  )
                ],
              )
            ],
          );
        });
  }
}
