import 'dart:io';

import 'package:GM_Nav/config/design_constants.dart';
import 'package:GM_Nav/repository/authentication/authentication.dart';
import 'package:GM_Nav/screen/profile_setting/profileSetting.dart';
import 'package:GM_Nav/screen/terms_and_rule/terms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({
    Key key,
  }) : super(key: key);

  @override
  _SettingScreen createState() => new _SettingScreen();
}

class _SettingScreen extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: new Text(
          DesignConstants.SETTING_SCREEN_TITLE,
          style: TextStyle(
            color: Color(
              0xfffafafa,
            ),
          ),
        ),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: DesignConstants.SECTION[0],
            tiles: [
              SettingsTile(
                title: DesignConstants.LANG,
                subtitle: DesignConstants.ENG,
                leading: Icon(Icons.language),
                onTap: () {},
              ),
            ],
          ),
          SettingsSection(
            title: DesignConstants.SECTION[1],
            tiles: [
              SettingsTile(
                title: DesignConstants.ACC_SETTING,
                leading: Icon(
                  Icons.admin_panel_settings,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileSetting(),
                    ),
                  );
                },
              ),
              SettingsTile(
                title: DesignConstants.SIGN_OUT,
                leading: Icon(
                  Icons.exit_to_app,
                ),
                onTap: () async {
                  await Authentication.logOut();
                  exit(0);
                },
              ),
            ],
          ),
          SettingsSection(
            title: DesignConstants.SECTION[2],
            tiles: [
              SettingsTile.switchTile(
                title: DesignConstants.TOGGLE_BACK,
                enabled: true,
                leading: Icon(Icons.phonelink_lock),
                switchValue: false,
                onToggle: (bool value) {},
              ),
              SettingsTile.switchTile(
                title: DesignConstants.NOTIFICATION_ENABLE,
                enabled: true,
                leading: Icon(Icons.notifications_active),
                switchValue: true,
                onToggle: (value) {},
              ),
            ],
          ),
          SettingsSection(
            title: DesignConstants.SECTION[3],
            tiles: [
              SettingsTile(
                title: DesignConstants.TERM,
                leading: Icon(
                  Icons.description,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TermsAndRules(),
                    ),
                  );
                },
              ),
            ],
          ),
          CustomSection(
            child: Column(
              children: [
                Text(
                  DesignConstants.VERSION,
                  style: TextStyle(color: Color(0xFF777777)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
