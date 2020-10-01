import 'package:GM_Nav/bloc/post/post_event.dart';
import 'package:GM_Nav/config/dependency_injection.dart';
import 'package:GM_Nav/config/game_constants.dart';
import 'package:GM_Nav/config/search_constants.dart';
import 'package:GM_Nav/config/shared_data.dart';
import 'package:GM_Nav/repository/post/post_manage_imp.dart';
import 'package:GM_Nav/screen/main/components/body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:GM_Nav/config/design_constants.dart';
import 'package:GM_Nav/screen/main/components/utilities.dart';
import 'package:filter_list/filter_list.dart';

class SearchBox extends StatefulWidget {
  @override
  _SearchBox createState() => _SearchBox();
}

class _SearchBox extends State<SearchBox> {
  List<String> selectedCountList = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(kDefaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        onTap: () {
          _openFilterList(context);
        },
        readOnly: true,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          icon: SvgPicture.asset(DesignConstants.SEARCH_IMAGE),
          hintText: DesignConstants.SEARCH_BY,
          hintStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _openFilterList(BuildContext context) async {
    var list = await FilterList.showFilterList(
      context,
      borderRadius: 20,
      applyButonTextBackgroundColor: Colors.white,
      applyButonTextColor: Colors.lightBlue,
      hidecloseIcon: true,
      allTextList: DesignConstants.FILTER_LIST,
      headlineText: "Select Max 3 Option",
      searchFieldHintText: "Search Here",
      selectedTextList: selectedCountList,
    );
    await container<PostManager>().init();

    if (list != null) {
      setState(
        () {
          int isValid = 0;
          for (int i = 0; i < list.length; i++) {
            if (SearchMethods[i] == SearchType.LESS_PRICE ||
                SearchMethods[i] == SearchType.HIGH_PRICE) {
              isValid++;
            }
          }
          if (List.from(list).length <= GameConstants.MAX_SHARED &&
              isValid < 2) {
            selectedCountList = List.from(list);
            SharedData.selectedList = selectedCountList;
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
                content: new Text((isValid == 2)
                    ? GameConstants.MISSING_DATA
                    : GameConstants.MAX_SELECT),
                duration: new Duration(seconds: 5),
              ),
            );
          }
        },
      );
    }
  }
}
