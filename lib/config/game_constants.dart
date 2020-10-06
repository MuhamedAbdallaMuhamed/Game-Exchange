/*
  Main place to define project scooped constants.
*/

import 'package:GM_Nav/config/search_constants.dart';

abstract class GameConstants {
  //----------------------------------------User----------------------------------------------//
  static const USER_COLLECTION_ENTRY = "UserCollection";
  static const USER_ID_ENTRY = "ID";
  static const USER_NAME_ENTRY = "Name";
  static const USER_MAIL_ENTRY = "Email";
  static const USER_RATE_SUM_ENTRY = "Rate";
  static const USER_VOTES_NUMBER_ENTRY = "Vote";
  static const USER_IMAGE_ENTRY = "Image";
  static const USER_PASSWORD_ENTRY = "Password";
  //----------------------------------------Product----------------------------------------------//
  static const PRODUCT_COLLECTION_ENTRY = "ProductCollection";
  static const PRODUCT_ID_ENTRY = "ID";
  static const PRODUCT_DESC_ENTRY = "Description";
  //----------------------------------------Post----------------------------------------------//
  static const POST_COLLECTION_ENTRY = "PostCollection";
  static const POST_ID_ENTRY = "ID";
  static const POST_IMAGE_ENTRY = "Image";
  static const POST_USERID_ENTRY = "UserID";
  static const POST_PRICE_ENTRY = "Price";
  static const POST_DATE_ENTRY = "Date";
  static const POST_NAME_ENTRY = "Name";
  static const POST_CATEGORY_ENTRY = "Category";
  static const POST_PRODUCT_ENTRY = "Product";
  static const POST_SOLD_ENTRY = "Sold";
  static const POST_SEARCH_KEY = {
    SearchOptions.General_Search: "aaa",
    SearchOptions.OwnSearch: "bbb",
    SearchOptions.OptionSearch: "ccc",
  };
  static const MESSAGE_KEY = 'ggg';
  static const CHAT_KEY = 'hhh';
  //---------------------------------------Vote-----------------------------------------------//
  static const VOTE_COLLECTION_ENTRY = "VoteCollection";
  static const VOTE_ID_ENTRY = "ID";
  static const VOTE_FIRST_ID_ENTRY = "FirstID";
  static const VOTE_SECOND_ID_ENTRY = "SecondID";
  static const VOTE_RATE_ENTRY = "Rate";
  //----------------------------------------ChatRoom----------------------------------------------//
  static const CHAT_ROOM_COLLECTION_ENTRY = "ChatRoomCollection";
  static const CHAT_ROOM_ID_ENTRY = "RoomID";
  static const CHAT_ROOM_FIRST_ID_ENTRY = "FirstID";
  static const CHAT_ROOM_SECOND_ID_ENTRY = "SecondID";
  static const CHAT_ROOM_MESSAGE_ID_ENTRY = "MessageID";
  static const CHAT_ROOM_LAST_MESSAGE_ENTRY = "Last Message";
  static const CHAT_ROOM_LAST_TIME_ENTRY = "Time";
  //----------------------------------------ChatMessages----------------------------------------------//
  static const CHAT_MESSAGE_COLLECTION_ENTRY = "ChatMessageCollection";
  static const CHAT_MESSAGE_PATH_COLLECTION_ENTRY = "Path";
  static const CHAT_MESSAGE_PATH_ENTRY = "MainPath";
  static const CHAT_MESSAGE_ID_ENTRY = "MessageID";
  static const CHAT_MESSAGE_CONTENT_ENTRY = "Content";
  static const CHAT_MESSAGE_TIME_ENTRY = "Time";
  static const CHAT_MESSAGE_SENDER_ID_ENTRY = "SenderID";
  static const CHAT_MESSAGE_RECEIVER_ID_ENTRY = "ReceiverID";
  static const CHAT_MESSAGE_ROOM_ID = "RoomID";
  //-------------------------------------Routes-----------------------------------------------//
  static const SIGNUP_PAGE_ROUTE = "/signup";
  static const LOGIN_PAGE_ROUTE = "/login";
  //-------------------------------------Assets-----------------------------------------------//
  static const OPENSANS_FONT = "OpenSans";
  static const FACEBOOK_LOGO = "assets/logos/facebook.jpg";
  static const GOOGLE_LOGO = "assets/logos/google.jpg";
  static const LANGS_PATH = "assets/langs";
  //--------------------------------------Theme Controller------------------------------------//
  static const THEME_IS_DARK = "isDark";
  //--------------------------------------Shared Preferences------------------------------------//
  static const SHARED_PREFERENCES_KEY = "ID";
  //--------------------------------------ExceptionConstants-------------------------------------//
  static const GLOBLE_MESSAGE = "Error exist during works on this function ";
  //--------------------------------------FacebookConstants-------------------------------------//
  static const FACEBOOK_EMAIL = "email";
  static const GRAPH_RESPONE_HTTP =
      "https://graph.facebook.com/v2.12/me?fields=name,first_name,picture,email&access_token=";
  //--------------------------------------file---------------------------------------------------//
  static const FILEPATH = "assets/files/post.json";
  //----------------------------------------Post-------------------------------------------------//
  static const LIMIT = 10;
  //----------------------------------------------Server-----------------------------------------//
  static const SERVER_RECERIVE = 'Recerive';
  //-------------------------------------------General Keys---------------------------------------//
  static const GMAIL_KEY = '@gmail.com';
  static const MISSING_USER = 'Your aren\'t registered, NooB..!';
  static const MISSING_DATA = 'Check your data, NooB..!';
  static const EXISTED_DATA = 'Entered before, NooB..!';
  static const GENERATED_PASSWORD =
      'Check your gmail after a few seconds, Brain of fish XD';
  static const STATIC_PASSWORD = 'XD5879879DSADA';
  static const DURATION_KEY = 'Now,';
  static const ADD_TO_STORE = "Add to store";
  static const SUCCESS = 'Success';
  static const RATE_YOURSELF_DENIED = 'You can\'t rate yourself..';
  static const RATED_BEFORE = 'Rated before head of fish!!!';
  static const REACHED_MAX = 'Reached to max options to search....';
  static const MAX_SELECT = 'Select 3 Options only, NOob!';
  static const SIGN_CHANGE = "**";
  static const MAX_SHARED = 3;
  static const MAX_MESSAGES = 12;
  static const MAX_CHAT = 6;
  static const HONOR_FACTOR = 5.0;
}
