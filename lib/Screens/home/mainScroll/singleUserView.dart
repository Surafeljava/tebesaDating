import 'package:flutter/material.dart';
import 'package:spring_button/spring_button.dart';

class SingleUserView extends StatefulWidget {
  @override
  _SingleUserViewState createState() => _SingleUserViewState();
}

class _SingleUserViewState extends State<SingleUserView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width/1.2,
              height: MediaQuery.of(context).size.width/1.1,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),

            Container(
              height: 65,
              child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      width: 65,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  );
                },
              ),
            ),

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
                    print('Money');
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
                    print('Dis-Like');
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
                    print('Like');
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
                    print('Like');
                  },
                ),

              ],
            ),

          ],
        )
    );
  }
}
