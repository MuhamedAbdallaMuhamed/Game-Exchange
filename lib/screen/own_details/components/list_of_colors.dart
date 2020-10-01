import 'package:GM_Nav/screen/main/components/utilities.dart';
import 'package:GM_Nav/screen/own_details/components/color_dots.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ListOfColors extends StatelessWidget {
  final Timestamp date;
  const ListOfColors({
    this.date,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ColorDot(
            fillColor: Color(0xff00acc1),
            isSelected: true,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
            child: Text(
              DateFormat.yMMMEd().format(date.toDate()),
              style: Theme.of(context).textTheme.button,
            ),
          ),
        ],
      ),
    );
  }
}
