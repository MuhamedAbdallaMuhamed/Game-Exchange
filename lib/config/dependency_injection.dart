import 'package:GM_Nav/repository/cache_manager/cache_manager.dart';
import 'package:GM_Nav/repository/cache_manager/cache_manager_imp.dart';
import 'package:GM_Nav/repository/chatMessage/chat_message_manager.dart';
import 'package:GM_Nav/repository/chatMessage/chat_message_manager_imp.dart';
import 'package:GM_Nav/repository/chatMessage/room_manager.dart';
import 'package:GM_Nav/repository/chatMessage/room_manager_imp.dart';
import 'package:GM_Nav/repository/file_manager/file_manager.dart';
import 'package:GM_Nav/repository/file_manager/file_manager_imp.dart';
import 'package:GM_Nav/repository/firebase_manager/firebase_query.dart';
import 'package:GM_Nav/repository/firebase_manager/firebase_query_manager.dart';
import 'package:GM_Nav/repository/post/post_manage_imp.dart';
import 'package:GM_Nav/repository/post/post_manager.dart';
import 'package:GM_Nav/repository/product/product_manager.dart';
import 'package:GM_Nav/repository/product/product_manager_imp.dart';
import 'package:GM_Nav/repository/secure_file/secure_file.dart';
import 'package:GM_Nav/repository/secure_file/secure_file_imp.dart';
import 'package:GM_Nav/repository/services/search/search_manager.dart';
import 'package:GM_Nav/repository/services/search/search_manager_imp.dart';
import 'package:GM_Nav/repository/services/security/security_manager.dart';
import 'package:GM_Nav/repository/services/security/security_manager_imp.dart';
import 'package:GM_Nav/repository/services/userVote/userVote_manager.dart';
import 'package:GM_Nav/repository/services/userVote/userVote_manager_imp.dart';
import 'package:GM_Nav/repository/storge/storage_manager_imp.dart';
import 'package:GM_Nav/repository/storge/storge_manager.dart';
import 'package:get_it/get_it.dart';
import '../repository/user/user_manager.dart';
import '../repository/user/user_manager_Imp.dart';

var container = new GetIt();

/*
 * Initialized application dependencies.
 */
void build() {
  //------------------------------------regiser Firestore---------------------------------//
  container.registerSingleton<FirebaseOperation>(
    IFirebaseOperation(),
  );
  //-----------------------------------user register factory--------------------------//
  container.registerSingleton<UserManager>(
    IUserManager(
      container<FirebaseOperation>(),
    ),
  );
  container.registerSingleton<CacheManager>(
    ICacheManager(),
  );
  container.registerSingleton<StorageFirebaseManager>(
    FirebaseStorageManager(),
  );
  container.registerSingleton<ProductManager>(
    IProductManager(
      container<FirebaseOperation>(),
    ),
  );
  container.registerSingleton<FileManager>(
    IFileManager(),
  );
  container.registerSingleton<SearchManager>(
    ISearchManager(),
  );
  container.registerSingleton<SecurityManager>(
    ISecurityManager(),
  );
  container.registerSingleton<SecureFileManager>(
    ISecureFileManager(),
  );
  container.registerSingleton<PostManager>(
    IPostManager(
      container<FirebaseOperation>(),
      container<SecureFileManager>(),
      container<SecurityManager>(),
      container<SearchManager>(),
    ),
  );
  container.registerSingleton<UserVoteManager>(
    IUserVoteManager(
      container<FirebaseOperation>(),
      container<UserManager>(),
    ),
  );
  container.registerSingleton<RoomManager>(
    IRoomManager(
      container<FirebaseOperation>(),
      container<SecureFileManager>(),
      container<SecurityManager>(),
    ),
  );
  container.registerSingleton<ChatMessageManager>(
    IChatMessageManager(
      container<FirebaseOperation>(),
      container<SecureFileManager>(),
      container<SecurityManager>(),
    ),
  );
}
