import 'package:dating/Screens/registration/registration.dart';
import 'package:dating/Services/authService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {

  AuthService _authService = new AuthService();

  String menuIcon = 'assets/icons/menuIcon.svg';

  //TODO finish bottom navigation icons
  List<String> selectedIcons = ['assets/icons/navigation/home.svg', 'assets/icons/navigation/heart.svg', 'assets/icons/navigation/tinder.svg', 'assets/icons/navigation/message.svg'];
  List<String> notSelectedIcons = ['assets/icons/navigation/home-line.svg', 'assets/icons/navigation/heart-line.svg', 'assets/icons/navigation/tinder-line.svg', 'assets/icons/navigation/message-line.svg'];
  String dotsMenu = 'assets/icons/navigation/dots-menu.svg';

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.email,color:Color(0xFFD12043),),
                title: Text('About Tebesa'),
                subtitle: Text('Description about the app.'),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset(
            menuIcon,
            width: 30.0,
            height: 30.0,
            color: Color(0xFFD12043),
          ),
          onPressed: (){
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.grey[800],),
            color: Colors.white,
            onPressed: (){
              _authService.signOut();
              Provider.of<Registration>(context, listen: false).setUserIn(0);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: SvgPicture.asset(
          dotsMenu,
          width: 25.0,
          height: 25.0,
          color: Colors.white
        ),
        backgroundColor: Color(0xFFD12043),
        onPressed: (){
          print('Menu Clicked');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            IconButton(
              icon: SvgPicture.asset(
                selectedIcons[0],
                width: 25.0,
                height: 25.0,
                color: Color(0xFFD12043),
              ),
            ),
            IconButton(
              icon: SvgPicture.asset(
                notSelectedIcons[1],
                width: 25.0,
                height: 25.0,
                color: Color(0xFFD12043),
              ),
            ),
            SizedBox(width: 40.0,),
            IconButton(
              icon: SvgPicture.asset(
                notSelectedIcons[2],
                width: 25.0,
                height: 25.0,
                color: Color(0xFFD12043),
              ),
            ),
            IconButton(
              icon: SvgPicture.asset(
                notSelectedIcons[3],
                width: 25.0,
                height: 25.0,
                color: Color(0xFFD12043),
              ),
            ),
          ],

        ),
        shape: CircularNotchedRectangle(),
        color: Colors.white,
      ),
      body: Container(
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
                IconButton(
                  icon: Icon(Icons.attach_money, color: Colors.lightGreen, size: 30.0,),
                ),

                IconButton(
                  icon: Icon(Icons.close, color: Color(0xFFD12043), size: 30.0,),
                ),

                IconButton(
                  icon: Icon(Icons.favorite, color: Color(0xFFD12043), size: 30.0,),
                ),

                IconButton(
                  icon: Icon(Icons.star, color: Colors.yellow, size: 30.0,),
                ),
              ],
            ),

          ],
        )
      ),
    );
  }
}
