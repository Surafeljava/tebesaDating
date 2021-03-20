import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/Models/paymentModel.dart';
import 'package:dating/Services/databaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spring_button/spring_button.dart';

class PaymentConfirmPage extends StatefulWidget {

  final bool denied;
  PaymentConfirmPage({@required this.denied});

  @override
  _PaymentConfirmPageState createState() => _PaymentConfirmPageState();
}

class _PaymentConfirmPageState extends State<PaymentConfirmPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DatabaseService databaseService = new DatabaseService();

  TextEditingController tRefNumber = new TextEditingController();
  TextEditingController depositedByName = new TextEditingController();

  bool validate = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text('Confirm Payment', style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w400),),
        elevation: 0.0,
        leading: loading ? Center(
          child: Container(
            width: 25.0,
            height: 25.0,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey[800]),
            ),
          ),
        ) : Icon(Icons.monetization_on, color: Colors.grey[700], size: 25.0,),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('paymentRequests').doc(FirebaseAuth.instance.currentUser.uid.toString()).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.data==null){
            return Container(
              color: Colors.grey[100],
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }else{
            DocumentSnapshot doc = snapshot.data;
            PaymentModel paymentModel = PaymentModel.fromJson(doc.data());

            return Form(
              key: _formKey,
              autovalidate: validate,
              child: Container(
                color: Colors.grey[100],
                child: ListView(
                  children: [

                    widget.denied ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Your Payment confirmation has been denied! please check and fill the form again.', style: TextStyle(fontSize: 17, color: Colors.red, fontWeight: FontWeight.w500, letterSpacing: 0.5),),
                    ) : Container(),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Please fill this form after paying!', style: TextStyle(fontSize: 15, color: Colors.red, fontWeight: FontWeight.w400, letterSpacing: 1.0),),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('Chosen bank: ', style: TextStyle(fontSize: 17, color: Colors.grey[800], fontWeight: FontWeight.w400, letterSpacing: 0.5),),
                              Text(paymentModel.bank, style: TextStyle(fontSize: 17, color: Colors.green, fontWeight: FontWeight.w500, letterSpacing: 0.5),),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Request date: ', style: TextStyle(fontSize: 17, color: Colors.grey[800], fontWeight: FontWeight.w400, letterSpacing: 0.5),),
                              Text('${paymentModel.date.day}/${paymentModel.date.month}/${paymentModel.date.year}', style: TextStyle(fontSize: 17, color: Colors.green, fontWeight: FontWeight.w500, letterSpacing: 0.5),),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Invoice: ', style: TextStyle(fontSize: 17, color: Colors.grey[800], fontWeight: FontWeight.w400, letterSpacing: 0.5),),
                              Text('#${paymentModel.invoice}', style: TextStyle(fontSize: 17, color: Colors.green, fontWeight: FontWeight.w500, letterSpacing: 0.5),),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: TextFormField(
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        controller: depositedByName,
                        style: TextStyle(
                            fontSize: 18.0,
                            letterSpacing: 1.0,
                            color: Colors.black
                        ),
                        validator: (val){
                          if(val.isNotEmpty){
                            return null;
                          }else{
                            return "Deposited by who?";
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Deposited By',
                          labelStyle: TextStyle(color: Colors.grey[800], fontSize: 19.0),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: TextFormField(
                        autofocus: false,
                        keyboardType: TextInputType.text,
                        controller: tRefNumber,
                        style: TextStyle(
                            fontSize: 18.0,
                            letterSpacing: 1.0,
                            color: Colors.black
                        ),
                        validator: (val){
                          if(val.isNotEmpty){
                            return null;
                          }else{
                            return "Empty Field";
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Transaction Reference',
                          labelStyle: TextStyle(color: Colors.grey[800], fontSize: 19.0),

                        ),
                      ),
                    ),


                    SizedBox(height: 20.0,),

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
                              'Confirm Payment',
                              style: TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 1.0, wordSpacing: 0.5, fontWeight: FontWeight.w600,),
                            ),
                          ),
                        ),
                        useCache: false,
                        scaleCoefficient: 0.9,
                        onTap: () async{

                          setState(() {
                            validate = true;
                          });

                          //Validate the given inputs
                          if(_formKey.currentState.validate()){

                            setState(() {
                              loading = true;
                            });

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
                                      child: Center(child: Text('Payment Confirmation Sending!', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w400, fontSize: 15.0),)),
                                    ),
                                  ],
                                ),
                              ),
                              backgroundColor: Colors.transparent,
                              elevation: 0.0,
                              duration: Duration(seconds: 2),
                            );
                            _scaffoldKey.currentState.showSnackBar(snackBarRegistered);

                            //Updating the paymentRequest detail
                            await databaseService.updatePayment(transactionRef: tRefNumber.text, depositedByName: depositedByName.text);

                            setState(() {
                              loading = false;
                            });

                            //Navigate to the approval waiting page

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
                                      child: Center(child: Text('Fill the form', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w400, fontSize: 15.0),)),
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
            );
          }
        }
      ),
    );
  }
}
