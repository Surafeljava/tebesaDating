import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/Models/paymentModel.dart';
import 'package:dating/Models/userModel.dart';
import 'package:dating/Screens/home/likes/likesPage.dart';
import 'package:dating/Screens/home/mainScroll/home.dart';
import 'package:dating/Screens/home/mainScroll/notifyAnimations.dart';
import 'package:dating/Screens/home/mainScroll/topPicks.dart';
import 'package:dating/Screens/home/matches/matchesPage.dart';
import 'package:dating/Screens/home/options/editProfile.dart';
import 'package:dating/Screens/home/options/lang.dart';
import 'package:dating/Screens/messaging/mainMessagingPage.dart';
import 'package:dating/Screens/registration/registration.dart';
import 'package:dating/Services/authService.dart';
import 'package:dating/Services/databaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  AuthService _authService = new AuthService();
  DatabaseService _databaseService = new DatabaseService();

  String menuIcon = 'assets/icons/menuIcon.svg';

  List<String> selectedIcons = [
    'assets/icons/navigation/home.svg',
    'assets/icons/navigation/heart.svg',
    'assets/icons/navigation/tinder.svg',
    'assets/icons/navigation/message.svg'
  ];
  List<String> notSelectedIcons = [
    'assets/icons/navigation/home-line.svg',
    'assets/icons/navigation/heart-line.svg',
    'assets/icons/navigation/tinder-line.svg',
    'assets/icons/navigation/message-line.svg'
  ];
  String dotsMenu = 'assets/icons/navigation/dots-menu.svg';

  int selectedPage = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  UserModel user;
  bool userDataCollected = false;

  PageController profilesScroll = new PageController();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  List<String> pagesName = [
    'Tebesa',
    'Likes',
    'Matches',
    'Messages',
    'Top Picks'
  ];
  List<String> pagesNameAm = ['ጠበሳ', 'ወዳጆች', 'ግጥምጥሞሽ', 'መልዕክቶች', 'ምርጦች'];

  bool showLikesAnimation = false;

  int likesNumber = 0;

  bool onFreePackage = false;

  Future<bool> checkFreePeriod() async {
    var result = await FirebaseFirestore.instance
        .collection('free_date')
        .doc("expire")
        .get();

    DateTime freeDate = DateTime.fromMicrosecondsSinceEpoch(
        result['date'].microsecondsSinceEpoch);

    if (freeDate.isAfter(DateTime.now())) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();

    checkFreePeriod().then((value) {
      setState(() {
        onFreePackage = value;
      });
    });

    _databaseService.getMyInfo().then((value) {
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

    getMySeenLikes().then((value) {
      setState(() {
        likesNumber = value;
      });
    });

//    Timer.periodic(Duration(seconds: 5), (timer) {
//      _databaseService.getMyLikes().then((value) {
//        if(likesNumber < value.length){
//          setState(() {
//            showLikesAnimation = true;
//            likesNumber = value.length;
//            //add to shared preference
//            addMySeenLikes(value.length);
//          });
//        }else{
//          setState(() {
//            showLikesAnimation = false;
//          });
//        }
//      });
//
//    });
  }

  //get my seen likes number from shared preference
  Future<int> getMySeenLikes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int likes = (prefs.getInt('likesCount') ?? 0);
    return likes;
  }

  //change the seen likes number
  void addMySeenLikes(int a) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int likes = (prefs.getInt('likesCount') ?? 0) + a;
    await prefs.setInt('likesCount', likes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: userDataCollected
          ? Drawer(
              child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .doc(
                      'users/${FirebaseAuth.instance.currentUser.uid.toString()}')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  );
                } else {
                  if (true) {
                    UserModel userModel = UserModel.fromJson(snapshot.data);
                    return Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 250.0,
                            margin: EdgeInsets.only(bottom: 8.0),
                            child: PageView.builder(
                              itemCount: userModel.photos.length,
                              scrollDirection: Axis.horizontal,
                              controller: profilesScroll,
                              itemBuilder: (context, index) {
                                return Container(
                                  child: CachedNetworkImage(
                                    imageUrl: userModel.photos[index],
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Center(
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        child: CircularProgressIndicator(
                                          value: downloadProgress.progress,
                                          strokeWidth: 1.0,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    fit: BoxFit.cover,
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
                                  count: userModel.photos.length,
                                  effect: SlideEffect(
                                      spacing: 5.0,
                                      radius: 10.0,
                                      dotWidth: 30.0,
                                      dotHeight: 2.5,
                                      paintStyle: PaintingStyle.fill,
                                      strokeWidth: 0.0,
                                      dotColor: Colors.grey[400],
                                      activeDotColor: Colors.pinkAccent),
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
                                  child: Text(
                                    userModel.fullName,
                                    style: TextStyle(
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1.0),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    Lang.language == 0 ? 'bio' : 'ባዮ',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 1.0,
                                        color: Colors.grey[500]),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    userModel.bio,
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 1.0),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    Lang.language == 0 ? 'email' : 'ኢሜል',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 1.0,
                                        color: Colors.grey[500]),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    userModel.email,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 1.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                          ListTile(
                            title: Text(
                              Lang.language == 0
                                  ? 'Edit Profile'
                                  : 'መገለጫ አስተካክል',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.0),
                            ),
                            leading: Icon(
                              Icons.edit,
                              color: Colors.grey[800],
                            ),
                            onTap: () {
                              //Call profile edit page
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditProfile()));
                            },
                          ),
                          onFreePackage
                              ? ListTile(
                                  title: Text(
                                    Lang.language == 0 ? 'Account' : 'መለያ',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1.0),
                                  ),
                                  subtitle: Text(
                                    'ON FREE TRIAL',
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 1.0,
                                        color: Colors.green),
                                  ),
                                  leading: Icon(
                                    Icons.attach_money,
                                    color: Colors.grey[800],
                                  ),
                                  onTap: () {
                                    print('Payment Page');
                                  },
                                )
                              : ListTile(
                                  title: Text(
                                    'Payment',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1.0),
                                  ),
                                  subtitle: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('paymentRequests')
                                          .doc(FirebaseAuth
                                              .instance.currentUser.uid)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.data == null) {
                                          return Text(
                                            'Checking...',
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 1.0,
                                                color: Colors.lightBlue),
                                          );
                                        } else {
                                          int dateLeft = 0;
                                          PaymentModel payModel =
                                              PaymentModel.fromJson(
                                                  snapshot.data);
                                          dateLeft = payModel.acceptedDate
                                                  .difference(DateTime.now())
                                                  .inDays +
                                              60;
                                          return Text(
                                            '$dateLeft Days Left',
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 1.0,
                                                color: Colors.green),
                                          );
                                        }
                                      }),
                                  leading: Icon(
                                    Icons.attach_money,
                                    color: Colors.grey[800],
                                  ),
                                  onTap: () {
                                    print('Payment Page');
                                  },
                                ),
                          Spacer(),
                          ListTile(
                            title: Text(
                              Lang.language == 0 ? 'LogOut' : 'ውጣ',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.0),
                            ),
                            leading: Icon(
                              Icons.logout,
                              color: Colors.grey[800],
                            ),
                            onTap: () {
                              _authService.signOut();
                              Provider.of<Registration>(context, listen: false)
                                  .setUserIn(0);
                            },
                          ),
                        ],
                      ),
                    );
                  }
                }
              },
            ))
          : Center(
              child: CircularProgressIndicator(),
            ),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset(
            menuIcon,
            width: 30,
            height: 30,
            color: Color(0xFFD12043),
          ),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        actions: [
          TextButton(
            child: Text(
              Lang.language == 0 ? 'አማ 🇪🇹' : 'EN 🇺🇸',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0),
            ),
            onPressed: () async {
              changeLanguage();
            },
          )
        ],
        title: Text(
          Lang.language == 0
              ? pagesName[selectedPage]
              : pagesNameAm[selectedPage],
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w400,
              color: Colors.grey[800],
              letterSpacing: 1.0),
        ),
      ),
      floatingActionButton: Container(
        height: 45.0,
        width: 45.0,
        child: FloatingActionButton(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          child: SvgPicture.asset(dotsMenu,
              width: 25, height: 25, color: Colors.white),
          backgroundColor: Color(0xFFD12043),
          onPressed: () {
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
                selectedPage == 0 ? selectedIcons[0] : notSelectedIcons[0],
                width: 25,
                height: 25,
                color: selectedPage == 0 ? Color(0xFFD12043) : Colors.grey[400],
              ),
              onPressed: () {
                setState(() {
                  selectedPage = 0;
                });
              },
            ),
            IconButton(
              icon: SvgPicture.asset(
                selectedPage == 1 ? selectedIcons[1] : notSelectedIcons[1],
                width: 25,
                height: 25,
                color: selectedPage == 1 ? Color(0xFFD12043) : Colors.grey[400],
              ),
              onPressed: () {
                setState(() {
                  selectedPage = 1;
                });
              },
            ),
            SizedBox(
              width: 40.0,
            ),
            IconButton(
              icon: SvgPicture.asset(
                selectedPage == 2 ? selectedIcons[2] : notSelectedIcons[2],
                width: 25,
                height: 25,
                color: selectedPage == 2 ? Color(0xFFD12043) : Colors.grey[400],
              ),
              onPressed: () {
                setState(() {
                  selectedPage = 2;
                });
              },
            ),
            IconButton(
              icon: SvgPicture.asset(
                selectedPage == 3 ? selectedIcons[3] : notSelectedIcons[3],
                width: 25,
                height: 25,
                color: selectedPage == 3 ? Color(0xFFD12043) : Colors.grey[400],
              ),
              onPressed: () {
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

  Widget currentPage(int selected) {
    if (selected == 0) {
      return Stack(
        children: [
          Home(
            theContext: context,
          ),
          showLikesAnimation
              ? NotifyAnimations(
                  animationType: 0,
                )
              : Container(),
        ],
      );
    } else if (selected == 1) {
      return Center(
        child: LikesPage(),
      );
    } else if (selected == 2) {
      return MatchesPage();
    } else if (selected == 3) {
      return MainMessagingPage();
    } else {
      return Center(
        child: TopPicks(),
      );
    }
  }

  void changeLanguage() async {
    final pref = await SharedPreferences.getInstance();
    final userPref = pref.getString('language');

    if (userPref == null) {
      pref.setString('language', 'en');
      setState(() {
        Lang.language = 1;
      });
    } else {
      if (userPref == 'en') {
        pref.setString('language', 'am');
        setState(() {
          Lang.language = 0;
        });
      } else {
        pref.setString('language', 'en');
        setState(() {
          Lang.language = 1;
        });
      }
    }
  }
}
