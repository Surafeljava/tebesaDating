import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/Models/userAuthModel.dart' as  usr;
import 'package:dating/Models/userModel.dart';
import 'package:dating/Screens/home/likes/likesPage.dart';
import 'package:dating/Screens/home/mainScroll/home.dart';
import 'package:dating/Screens/home/mainScroll/mainHomeState.dart';
import 'package:dating/Screens/home/mainScroll/singleUserView.dart';
import 'package:dating/Screens/home/mainScroll/topPicks.dart';
import 'package:dating/Screens/home/matches/matchesPage.dart';
import 'package:dating/Screens/messaging/mainMessagingPage.dart';
import 'package:dating/Screens/registration/registration.dart';
import 'package:dating/Services/authService.dart';
import 'package:dating/Services/databaseService.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

  int selectedPage = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  UserModel user;
  bool userDataCollected = false;

  PageController profilesScroll = new PageController();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  List<String> pagesName = ['Tebesa', 'Likes', 'Matches', 'Messages', 'Top Picks'];

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
      _firebaseMessaging.subscribeToTopic('${user.uid}_convo');
      _firebaseMessaging.subscribeToTopic('${user.uid}_match');
      _firebaseMessaging.subscribeToTopic('${user.uid}_like');
      _firebaseMessaging.subscribeToTopic('${user.uid}_payment');
    });

    _firebaseMessaging.subscribeToTopic('all');

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

              ListTile(
                title: Text('Payment', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, letterSpacing: 1.0),),
                subtitle: Text('2 Months Left', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, letterSpacing: 1.0, color: Colors.redAccent),),
                leading: Icon(Icons.attach_money, color: Colors.grey[800],),
                onTap: (){
                  print('Payment Page');
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
        title: Text(pagesName[selectedPage], style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400, color: Colors.grey[800], letterSpacing: 1.0),),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.grey[800],),
            color: Colors.white,
            onPressed: (){
              print('More');
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
            setState(() {
              selectedPage = 4;
            });
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
                selectedPage==0 ? selectedIcons[0] : notSelectedIcons[0],
                width: 25.0,
                height: 25.0,
                color: selectedPage==0 ? Color(0xFFD12043) : Colors.grey[400],
              ),
              onPressed: (){
                setState(() {
                  selectedPage = 0;
                });
              },
            ),
            IconButton(
              icon: SvgPicture.asset(
                selectedPage==1 ? selectedIcons[1] : notSelectedIcons[1],
                width: 25.0,
                height: 25.0,
                color: selectedPage==1 ? Color(0xFFD12043) : Colors.grey[400],
              ),
              onPressed: (){
                setState(() {
                  selectedPage = 1;
                });
              },
            ),
            SizedBox(width: 40.0,),
            IconButton(
              icon: SvgPicture.asset(
                selectedPage==2 ? selectedIcons[2] : notSelectedIcons[2],
                width: 25.0,
                height: 25.0,
                color: selectedPage==2 ? Color(0xFFD12043) : Colors.grey[400],
              ),
              onPressed: (){
                setState(() {
                  selectedPage = 2;
                });
              },
            ),
            IconButton(
              icon: SvgPicture.asset(
                selectedPage==3 ? selectedIcons[3] : notSelectedIcons[3],
                width: 25.0,
                height: 25.0,
                color: selectedPage==3 ? Color(0xFFD12043) : Colors.grey[400],
              ),
              onPressed: (){
                setState(() {
                  selectedPage = 3;
                });
              },
            ),
          ],

        ),
        shape: CircularNotchedRectangle(),
        color: Colors.white,
      ),
      body: currentPage(selectedPage),
    );
  }

  Widget currentPage(int selected){
    if(selected==0){
      return Home(theContext: context,);
    }else if(selected==1){
      return Center(
        child: LikesPage(),
      );
    }else if(selected==2){
      return MatchesPage();
    }else if(selected==3){
      return MainMessagingPage();
    }else {
      return Center(
        child: TopPicks(),
      );
    }
  }
}
