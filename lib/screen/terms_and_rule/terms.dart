import 'package:GM_Nav/config/design_constants.dart';
import 'package:flutter/material.dart';

class TermsAndRules extends StatefulWidget {
  TermsAndRules({
    Key key,
  }) : super(key: key);

  @override
  _TermsAndRules createState() => new _TermsAndRules();
}

class _TermsAndRules extends State<TermsAndRules> {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    return new Stack(
      children: <Widget>[
        new Scaffold(
          appBar: new AppBar(
            leading: IconButton(
              icon: new Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
            ),
            elevation: 0,
            centerTitle: false,
            title: new Text(
              DesignConstants.TERM,
              style: TextStyle(
                color: Color(
                  0xfffafafa,
                ),
              ),
            ),
          ),
          drawer: new Drawer(
            child: new Container(),
          ),
          backgroundColor: Colors.white60,
          body: new Center(
            child: new Column(
              children: <Widget>[
                new SizedBox(
                  height: _height / 20,
                ),
                new Text(
                  DesignConstants.RULE[0],
                  textAlign: TextAlign.center,
                ),
                new Text(
                  DesignConstants.RULE[1],
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
