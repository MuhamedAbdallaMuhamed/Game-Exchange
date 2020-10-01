import 'package:GM_Nav/config/dependency_injection.dart';
import 'package:GM_Nav/config/design_constants.dart';
import 'package:GM_Nav/model/Post.dart';
import 'package:GM_Nav/repository/post/post_manage_imp.dart';
import 'package:GM_Nav/screen/main/components/utilities.dart';
import 'package:flutter/material.dart';

class MarkAsSold extends StatelessWidget {
  final post;

  const MarkAsSold({
    @required this.post,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _postManager = container<PostManager>();

    return Container(
      margin: EdgeInsets.all(kDefaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: <Widget>[
          FlatButton.icon(
            onPressed: () async {
              if ((post as Post).isSold == false) {
                (post as Post).isSold |= true;
                await _postManager.update(post);
              }
            },
            icon: new Icon(
              Icons.mark_chat_read,
              color: Colors.white,
            ),
            label: Text(
              ((post as Post).isSold == true)
                  ? DesignConstants.SOLD
                  : DesignConstants.MARKSOLD,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
