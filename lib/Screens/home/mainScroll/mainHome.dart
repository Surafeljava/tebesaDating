import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/Models/userAuthModel.dart' as  usr;
import 'package:dating/Models/userModel.dart';
import 'package:dating/Screens/home/mainScroll/mainHomeState.dart';
import 'package:dating/Screens/home/mainScroll/singleUserView.dart';
import 'package:dating/Screens/registration/registration.dart';
import 'package:dating/Services/authService.dart';
import 'package:dating/Services/databaseService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {

  AuthService _authService = new AuthService();
  DatabaseService _databaseService = new DatabaseService();

  String menuIcon = 'assets/icons/menuIcon.svg';

  //TODO finish bottom navigation icons
  List<String> selectedIcons = ['assets/icons/navigation/home.svg', 'assets/icons/navigation/heart.svg', 'assets/icons/navigation/tinder.svg', 'assets/icons/navigation/message.svg'];
  List<String> notSelectedIcons = ['assets/icons/navigation/home-line.svg', 'assets/icons/navigation/heart-line.svg', 'assets/icons/navigation/tinder-line.svg', 'assets/icons/navigation/message-line.svg'];
  String dotsMenu = 'assets/icons/navigation/dots-menu.svg';

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  UserModel user;
  bool userDataCollected = false;

  PageController profilesScroll = new PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _databaseService.getMyInfo().then((value){
      setState(() {
        user = value;
      });
      setState(() {
        userDataCollected = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: userDataCollected ? Drawer(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 250.0,
                margin: EdgeInsets.only(bottom: 8.0),
                child: PageView.builder(
                  itemCount: user.photos.length,
                  scrollDirection: Axis.horizontal,
                  controller: profilesScroll,
                  itemBuilder: (context, index){
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0.0),
                        image: DecorationImage(
                          image: NetworkImage(user.photos[index]),
                          fit: BoxFit.cover,
                        ),
                        color: Colors.grey[100]
                      ),
                    );
                  },
                ),
              ),

              Container(
                padding: EdgeInsets.all(0.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SmoothPageIndicator(
                      controller: profilesScroll,
                      count: user.photos.length,
                      effect: SlideEffect(
                          spacing:  5.0,
                          radius:  10.0,
                          dotWidth:  30.0,
                          dotHeight:  2.5,
                          paintStyle:  PaintingStyle.fill,
                          strokeWidth:  0.0,
                          dotColor:  Colors.grey[400],
                          activeDotColor:  Colors.pinkAccent
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(user.fullName, style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500, letterSpacing: 1.0),),
                    ),

                    SizedBox(
                      height: 10.0,
                    ),

                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text('bio', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, letterSpacing: 1.0, color: Colors.grey[400]),),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(user.bio, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, letterSpacing: 1.0),),
                    ),

                    SizedBox(
                      height: 10.0,
                    ),

                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text('email', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, letterSpacing: 1.0, color: Colors.grey[400]),),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(user.email, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, letterSpacing: 1.0),),
                    ),
                  ],
                ),
              ),

              Divider(),

              ListTile(
                title: Text('Edit Profile', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, letterSpacing: 1.0),),
                leading: Icon(Icons.edit, color: Colors.grey[800],),
                onTap: (){
                  print('Profile Edit');
                },
              ),

              Spacer(),

              ListTile(
                title: Text('LogOut', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, letterSpacing: 1.0),),
                leading: Icon(Icons.logout, color: Colors.grey[800],),
                onTap: (){
                  _authService.signOut();
                  Provider.of<Registration>(context, listen: false).setUserIn(0);
                },
              ),


            ],
          ),
        ),
      ) :
      Center(
        child: CircularProgressIndicator(),
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
      floatingActionButton: Container(
        height: 45.0,
        width: 45.0,
        child: FloatingActionButton(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0),),
          ),
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
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
                color: Colors.grey[400],
              ),
            ),
            SizedBox(width: 40.0,),
            IconButton(
              icon: SvgPicture.asset(
                notSelectedIcons[2],
                width: 25.0,
                height: 25.0,
                color: Colors.grey[400],
              ),
            ),
            IconButton(
              icon: SvgPicture.asset(
                notSelectedIcons[3],
                width: 25.0,
                height: 25.0,
                color: Colors.grey[400],
              ),
            ),
          ],

        ),
        shape: CircularNotchedRectangle(),
        color: Colors.white,
      ),
      body: PageView.builder(
        itemCount: 10,
        physics: NeverScrollableScrollPhysics(),
        controller: Provider.of<MainHomeState>(context).getMainHomePageController,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index){
          return Container(
            width: MediaQuery.of(context).size.width,
            child: SingleUserView(userModel: null,),
          );
        },
      ),
    );
  }
}
