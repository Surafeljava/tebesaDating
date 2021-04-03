import 'package:dating/Models/userModel.dart';
import 'package:dating/Screens/home/mainScroll/datesState.dart';
import 'package:dating/Screens/home/mainScroll/mainHomeState.dart';
import 'package:dating/Screens/home/mainScroll/matchState.dart';
import 'package:dating/Screens/home/mainScroll/matchView.dart';
import 'package:dating/Screens/home/mainScroll/singleUserView.dart';
import 'package:dating/Services/databaseService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {

  final BuildContext theContext;
  Home({this.theContext});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  DatabaseService _databaseService = new DatabaseService();

  PageController mainPageController;

  bool loading = true;

  UserModel me;

  int _page = 0;

  @override
  void initState() {

    mainPageController = new PageController(initialPage: 0);

    _databaseService.getNewDates(widget.theContext).then((value) {
      setState(() {
        loading = false;
      });
    });

    _databaseService.getMyInfo().then((value) {
      setState(() {
        me = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading ?
    Center(
      child: CircularProgressIndicator(),
    ) :
    (Provider.of<DatesState>(context).getMyDates.length==Provider.of<MainHomeState>(context).getPage || Provider.of<DatesState>(context).getMyDates.length==0 ) && !Provider.of<MatchState>(context).getMatchState ?
    Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('You Have Seen All', style: TextStyle(fontWeight: FontWeight.w300, color: Colors.grey[600], fontSize: 25.0, letterSpacing: 1.0),),
          Text('Try Again Later!', style: TextStyle(fontWeight: FontWeight.w300, color: Colors.grey[500], fontSize: 16.0, letterSpacing: 1.0),),
        ],
      ),
    ) :
    Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Provider.of<MatchState>(context).getMatchState ?
      MatchView(otherUser: Provider.of<DatesState>(context).getMyDates[_page], me: me) :
      PageView.builder(
        itemCount: Provider.of<DatesState>(context).getMyDates.length,
        controller: mainPageController,
        scrollDirection: Axis.vertical,
        onPageChanged: (page){
          setState(() {
            _page = page;
          });
        },
        itemBuilder: (context, index){
//          int thePage = 0;
//          if (mainPageController.position.minScrollExtent != null && mainPageController.position.maxScrollExtent != null) {
//            thePage = mainPageController.page.round();
//          }

          return SingleUserView(userModel: Provider.of<DatesState>(context).getMyDates[_page], fromHome: true, changeThePage: index!=Provider.of<DatesState>(context).getMyDates.length-1 ? changeCurrentPage : null, pageBack: index==0 ? null : pageBack,);
        },
      ),
    );
  }

  void changeCurrentPage(){
    mainPageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn
    );
  }

  void pageBack(){
    mainPageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn
    );
  }

}
