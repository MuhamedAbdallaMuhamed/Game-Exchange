import 'package:GM_Nav/config/search_constants.dart';
import 'package:GM_Nav/model/DataModel.dart';
import 'package:GM_Nav/model/Post.dart';
import 'package:GM_Nav/repository/file_manager/file_manager.dart';
import 'package:GM_Nav/repository/post/post_manage_imp.dart';
import 'package:GM_Nav/repository/services/search/search_query.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import '../firebase_mock/dependency_injection_mock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group(
    'Post CRUD Operations Tests: ',
    () {
      build();

      test(
        'Checking Basic Operation Tests',
        () async {
          //Act 1
          List<Post> posts = [];
          PostManager postManager = container<PostManager>();
          for (int i = 0; i < posts.length; i++) {
            await postManager.insert(posts[i]);
          }
          FileManager fileManager = container<FileManager>();
          fileManager.create();
          fileManager.write("");
          List<DataModel> ret = await postManager.getPosts(
            SearchQuery(
              searchOption: SearchOptions.General_Search,
            ),
          );
          expect(ret[0].id, equals(posts[0].id));
          expect(ret[1].id, equals(posts[2].id));
          expect(ret[2].id, equals(posts[1].id));
          // Act 2
          posts[1].id = "4";
          posts[1].userID = "2";
          posts[1].date = new Timestamp.fromDate(
            DateTime.parse("1111-07-20 20:18:04"),
          );
          await postManager.insert(posts[1]);
          ret = await postManager.getPosts(
            SearchQuery(
              searchOption: SearchOptions.General_Search,
            ),
          );
          expect(ret.length, equals(1));
          expect(ret[0].id, equals(posts[1].id));
          // Act 3
          await fileManager.write("");
          posts[2].isSold = true;
          await postManager.update(posts[2]);
          ret = await postManager.getPosts(
            SearchQuery(
              id: "1",
              searchOption: SearchOptions.OwnSearch,
            ),
          );
          expect(ret.length, equals(3));
          expect(ret[0].id, equals(posts[0].id));
        },
      );
    },
  );
}
