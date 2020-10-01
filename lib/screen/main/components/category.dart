import 'package:GM_Nav/bloc/post/post_event.dart';
import 'package:GM_Nav/config/dependency_injection.dart';
import 'package:GM_Nav/config/game_constants.dart';
import 'package:GM_Nav/config/search_constants.dart';
import 'package:GM_Nav/config/shared_data.dart';
import 'package:GM_Nav/repository/post/post_manage_imp.dart';
import 'package:GM_Nav/screen/main/components/body.dart';
import 'package:flutter/material.dart';
import 'package:GM_Nav/config/design_constants.dart';
import 'utilities.dart';

// We need statefull widget because we are gonna change some state on our category
class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  // by default first item will be selected
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: DesignConstants.CATEGORIES.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () async {
            await container<PostManager>().init();
            setState(
              () {
                selectedIndex = index;
                if (index == 0) {
                  SharedData.selectedList.clear();
                  Body.postBloc.add(
                    Refresh(
                      userID: "",
                      searchOptions: SearchOptions.General_Search,
                    ),
                  );
                } else if (index != 0 &&
                    !SharedData.selectedList
                        .contains(DesignConstants.CATEGORIES[index]) &&
                    SharedData.selectedList.length < GameConstants.MAX_SHARED) {
                  SharedData.selectedList
                      .add(DesignConstants.CATEGORIES[index]);
                  Body.postBloc.add(
                    Refresh(
                      userID: "",
                      searchOptions: SearchOptions.OptionSearch,
                    ),
                  );
                } else {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: new Text(GameConstants.REACHED_MAX),
                      duration: new Duration(seconds: 3),
                    ),
                  );
                }
              },
            );
          },
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              left: kDefaultPadding,
              // At end item it add extra 20 right  padding
              right: index == DesignConstants.CATEGORIES.length - 1
                  ? kDefaultPadding
                  : 0,
            ),
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            decoration: BoxDecoration(
              color: index == selectedIndex
                  ? Colors.white.withOpacity(0.4)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              DesignConstants.CATEGORIES[index],
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
