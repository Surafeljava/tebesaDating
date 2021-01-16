import 'package:dating/Screens/home/mainScroll/mainHomeState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spring_button/spring_button.dart';

class SingleUserView extends StatefulWidget {

  @required final userModel;
  SingleUserView({this.userModel});

  @override
  _SingleUserViewState createState() => _SingleUserViewState();
}

class _SingleUserViewState extends State<SingleUserView> {

  List<String> pics = ['assets/test/user1.jpg','assets/test/user2.jpg','assets/test/user3.jpg','assets/test/user4.jpg','assets/test/user5.jpg'];

  int selectedPic = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width/1.2,
              height: MediaQuery.of(context).size.width/1.0,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20.0),
                image: DecorationImage(
                  image: AssetImage(pics[selectedPic]),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Spacer(flex: 1,),

            Container(
              height: 65,
              child: ListView.builder(
                itemCount: pics.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      width: 65,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: AssetImage(pics[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Spacer(flex: 1,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Amelia Jonson', style: TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.w400),),
                  Icon(Icons.keyboard_arrow_down, size: 30.0, color: Color(0xFFD12043),)
                ],
              ),
            ),

            Spacer(flex: 1,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SpringButton(
                  SpringButtonType.OnlyScale,
                  Container(
                    width: 45.0,
                    height: 45.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(1,1),
                          blurRadius: 8.0
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(Icons.attach_money, color: Colors.lightGreen, size: 25.0,),
                    ),
                  ),
                  useCache: false,
                  onTap: (){
                    changePage('Money', this.context);
                  },
                ),

                SpringButton(
                  SpringButtonType.OnlyScale,
                  Container(
                    width: 45.0,
                    height: 45.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(1,1),
                            blurRadius: 8.0
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(Icons.close, color: Color(0xFFD12043), size: 25.0,),
                    ),
                  ),
                  useCache: false,
                  onTap: (){
                    changePage('DisLike', this.context);
                  },
                ),

                SpringButton(
                  SpringButtonType.OnlyScale,
                  Container(
                    width: 45.0,
                    height: 45.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(1,1),
                            blurRadius: 8.0
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(Icons.favorite, color: Color(0xFFD12043), size: 25.0,),
                    ),
                  ),
                  useCache: false,
                  onTap: (){
                    changePage('Like', this.context);
                  },
                ),

                SpringButton(
                  SpringButtonType.OnlyScale,
                  Container(
                    width: 45.0,
                    height: 45.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(1,1),
                            blurRadius: 8.0
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(Icons.star, color: Colors.yellow, size: 25.0,),
                    ),
                  ),
                  useCache: false,
                  onTap: (){
                    changePage('Favorite', this.context);
                  },
                ),

              ],
            ),

            Spacer(flex: 2,),

          ],
        )
    );
  }

  void changePage(String from, BuildContext context){
    Provider.of<MainHomeState>(context, listen: false).changeMainHomePage();
    print('Page change from: $from');
  }

}
