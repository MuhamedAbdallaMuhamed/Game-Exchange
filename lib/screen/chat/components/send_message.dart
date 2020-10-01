import 'package:flutter/material.dart';
import 'package:GM_Nav/screen/chat/components/utility.dart' as myColors;

class SendedMessageWidget extends StatelessWidget {
  final String content;
  final String time;
  const SendedMessageWidget({
    Key key,
    this.content,
    this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(
          right: 8.0,
          left: 50.0,
          top: 4.0,
          bottom: 4.0,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(200000),
            bottomRight: Radius.circular(0),
            topLeft: Radius.circular(200000),
            topRight: Radius.circular(200000),
          ),
          child: Container(
            color: myColors.blue[500],
            // margin: const EdgeInsets.only(left: 10.0),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    right: 12.0,
                    left: 23.0,
                    top: 8.0,
                    bottom: 15.0,
                  ),
                  child: Text(
                    content,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 1,
                  right: 5,
                  child: Text(
                    time,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
