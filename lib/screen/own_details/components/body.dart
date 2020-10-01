import 'package:GM_Nav/model/Post.dart';
import 'package:GM_Nav/model/Product.dart';
import 'package:GM_Nav/screen/main/components/utilities.dart';
import 'package:GM_Nav/screen/own_details/components/chat_and_add_to_cart.dart';
import 'package:GM_Nav/screen/own_details/components/list_of_colors.dart';
import 'package:GM_Nav/screen/own_details/components/product_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';

class Body extends StatelessWidget {
  final Product curProduct;
  final Post curPost;
  final curImage;

  const Body({
    Key key,
    this.curProduct,
    this.curPost,
    this.curImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // it provide us total height and width
    Size size = MediaQuery.of(context).size;
    // it enable scrolling on small devices
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
              decoration: BoxDecoration(
                color: kBackgroundColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Hero(
                      tag: '${curPost.id}',
                      child: ProductPoster(
                        size: size,
                        image: curImage,
                      ),
                    ),
                  ),
                  ListOfColors(
                    date: curPost.date,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: kDefaultPadding / 2),
                    child: Text(
                      curPost.name,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Text(
                    '\$${curPost.price}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: kSecondaryColor,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
                    child: Text(
                      curProduct.description,
                      style: TextStyle(color: kTextLightColor),
                    ),
                  ),
                  SizedBox(height: kDefaultPadding),
                  Tags(
                    itemCount: curPost.catergory.length,
                    itemBuilder: (int index) {
                      final tag = curPost.catergory[index];
                      return ItemTags(
                        color: Colors.grey,
                        activeColor: Colors.pink,
                        textColor: Colors.white,
                        key: Key(index.toString()),
                        index: index,
                        title: tag,
                      );
                    },
                  ),
                  SizedBox(height: kDefaultPadding),
                ],
              ),
            ),
            MarkAsSold(
              post: curPost,
            ),
          ],
        ),
      ),
    );
  }
}
