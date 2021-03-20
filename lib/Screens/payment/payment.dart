import 'dart:math';

import 'package:dating/Models/paymentModel.dart';
import 'package:dating/Screens/payment/bankChooseCard.dart';
import 'package:dating/Screens/payment/paymentConfirmPage.dart';
import 'package:dating/Services/databaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spring_button/spring_button.dart';

class Payment extends StatefulWidget {

  final bool expired;
  Payment({@required this.expired});

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  TextEditingController email = TextEditingController();

  List<String> assetNames = ['cbe.png', 'dashen.png', 'hibret.png', 'wegagen.png'];

  List<String> bankNames = ['CBE', 'Dashen Bank', 'Hibret Bank', 'Wegagen Bank'];

  int selected = -1;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DatabaseService databaseService = new DatabaseService();

  bool validateEmail(String value) {
    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  @override
  Widget build(BuildContext context) {

    final double wd = MediaQuery.of(context).size.width;
    final double ht = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text('Payment', style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w400),),
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.grey[600],),
            onPressed: (){
              print("HELP!!!");
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        autovalidate: true,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey[200],
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Choose Bank', style: TextStyle(fontSize: 20, color: Colors.grey[800], fontWeight: FontWeight.w400, letterSpacing: 1.0),),
              ),
              widget.expired ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Your Last Payment has expired! please pay to continue using the application.', style: TextStyle(fontSize: 17, color: Colors.red, fontWeight: FontWeight.w500, letterSpacing: 0.5),),
              ) : Container(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Full bank information will be sent to your email.', style: TextStyle(fontSize: 15, color: Colors.grey[800], fontWeight: FontWeight.w300, letterSpacing: 1.0),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Amount: ', style: TextStyle(fontSize: 17, color: Colors.grey[800], fontWeight: FontWeight.w400, letterSpacing: 0.5),),
                        Text('100 ETB', style: TextStyle(fontSize: 17, color: Colors.green, fontWeight: FontWeight.w500, letterSpacing: 0.5),),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Package: ', style: TextStyle(fontSize: 17, color: Colors.grey[800], fontWeight: FontWeight.w400, letterSpacing: 0.5),),
                        Text('2 months', style: TextStyle(fontSize: 17, color: Colors.green, fontWeight: FontWeight.w500, letterSpacing: 0.5),),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                height: MediaQuery.of(context).size.width + 10.0,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 3,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15),
                  itemCount: 4,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext ctx, index) {
                    return BankChooseCard(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.width * 0.3,
                      assetName: assetNames[index],
                      bankName: bankNames[index],
                      onClicked: onBankClicked,
                      selected: selected,
                      myIndex: index,
                    );
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: TextFormField(
                  autofocus: false,
                  keyboardType: TextInputType.emailAddress,
                  controller: email,
                  style: TextStyle(
                      fontSize: 18.0,
                      letterSpacing: 1.0,
                      color: Colors.black
                  ),
                  validator: (val){
                    if(validateEmail(val)){
                      return null;
                    }else{
                      return "Invalid Email";
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'My Email',
                    labelStyle: TextStyle(color: Colors.grey[800], fontSize: 19.0),
                    hintText: 'example@abc.com',
                    hintStyle: TextStyle(
                        fontSize: 18.0,
                        letterSpacing: 1.0,
                        color: Colors.grey[700]
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15.0,),

              Center(
                child: SpringButton(
                  SpringButtonType.OnlyScale,
                  Container(
                    width: MediaQuery.of(context).size.width-30,
                    height: 50.0,
                    decoration: BoxDecoration(
                        color: Colors.pinkAccent,
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: Center(
                      child:
                      Text(
                        'Make Payment Request',
                        style: TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 1.0, wordSpacing: 0.5, fontWeight: FontWeight.w600,),
                      ),
                    ),
                  ),
                  useCache: false,
                  scaleCoefficient: 0.9,
                  onTap: () async{

                    //Validate the given inputs
                    if(_formKey.currentState.validate()){
                      //Get user id
                      String _uid = FirebaseAuth.instance.currentUser.uid.toString();

                      //Generate random invoice number
                      Random random = new Random();
                      int invoice = 10000 + random.nextInt(100000 - 10000);

                      //Creating payment model
                      PaymentModel pModel = new PaymentModel(userId: _uid, invoice: invoice.toString(), acceptedDate: null, bank: bankNames[selected], date: DateTime.now(), transactionRef: "", packageMonth: 2, status: 0, confirmed: false, email: email.text, depositedByName: "");

                      //Create payment request
                      await databaseService.createNewPayment(pModel);

                      final snackBarRegistered = SnackBar(
                        content: Container(
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                            children: [
                              SizedBox(height: 80.0,),
                              Container(
                                height: 40.0,
                                margin: EdgeInsets.symmetric(horizontal: 30.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Center(child: Text('Request Sent!', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w400, fontSize: 15.0),)),
                              ),
                            ],
                          ),
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                        duration: Duration(seconds: 2),
                      );
                      _scaffoldKey.currentState.showSnackBar(snackBarRegistered);

                    }else{

                      final snackBarFailed = SnackBar(
                        content: Container(
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                            children: [
                              SizedBox(height: 80.0,),
                              Container(
                                height: 40.0,
                                margin: EdgeInsets.symmetric(horizontal: 30.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Center(child: Text(selected==-1 ? 'Choose a Bank first' : 'Enter a valid email', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w400, fontSize: 15.0),)),
                              ),
                            ],
                          ),
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                        duration: Duration(seconds: 2),
                      );
                      _scaffoldKey.currentState.showSnackBar(snackBarFailed);
                    }
                  },
                ),
              ),

              SizedBox(height: 30.0,),


            ],
          ),
        ),
      ),
    );
  }

  void onBankClicked(int index){
    setState(() {
      selected = index;
    });
  }
}
