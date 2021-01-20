import 'package:dating/Models/userModel.dart';
import 'package:dating/Screens/home/mainScroll/datesState.dart';
import 'package:dating/Screens/home/mainScroll/mainHomeState.dart';
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

  bool loading = true;

  @override
  void initState() {
    super.initState();
    // TODO: get other users data
    _databaseService.getNewDates(widget.theContext).then((value) {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading ?
    Center(
      child: CircularProgressIndicator(),
    ) :
    Provider.of<DatesState>(context).getMyDates.length==0 ?
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
    PageView.builder(
      itemCount: Provider.of<DatesState>(context).getMyDates.length,
      physics: NeverScrollableScrollPhysics(),
      controller: Provider.of<MainHomeState>(context).getMainHomePageController,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index){
        return Container(
          width: MediaQuery.of(context).size.width,
          child: SingleUserView(userModel: Provider.of<DatesState>(context).getMyDates[index],),
        );
      },
    );
  }
}
