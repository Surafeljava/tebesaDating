import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/Models/paymentModel.dart';
import 'package:dating/Models/userAuthModel.dart' as  usr;
import 'package:dating/Screens/authenticate/authenticate.dart';
import 'package:dating/Screens/home/mainScroll/mainHome.dart';
import 'package:dating/Screens/loading/loginCheckLoading.dart';
import 'package:dating/Screens/payment/payment.dart';
import 'package:dating/Screens/payment/paymentCheckingLoadingPage.dart';
import 'package:dating/Screens/payment/paymentConfirmPage.dart';
import 'package:dating/Screens/registration/registration.dart';
import 'package:dating/Screens/registration/registrationPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  bool registeredBefore = false;

  bool userChecked = false;

  bool paymentChecked = false;

  int paymentStatus = -1;

  bool checkingUser = false;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<usr.User>(context);

    final int a = Provider.of<Registration>(context).getUserIn;

    if(user==null){
      return Authenticate();
    }else{
      checkUserInfo().then((value) {
        setState(() {
          registeredBefore = value;
        });
        setState(() {
          checkingUser = true;
        });
      });

      if((a==1 || registeredBefore) && checkingUser){
        checkPaymentInfo().then((value) {
          setState(() {
            paymentStatus = value;
          });
          setState(() {
            paymentChecked = true;
          });
        });

        if(paymentChecked){
          switch(paymentStatus){
            case -1:
              //todo: bring the payment page
              return Payment();
            case 0:
              //todo: show expired page and take them to payment page
              return Payment();
            case 1:
              //todo: waiting for approval page
              return Payment();
            case 2:
              //todo: take them to confirmation page
              return PaymentConfirmPage();
            case 3:
              return MainHome();
              break;
          }
        }else{
          //todo: return checking for payment page
          return PaymentCheckingLoadingPage();
        }
      }else if((a!=1 || registeredBefore) && !checkingUser){
        return LoginCheckLoading();
      }else{
        return RegistrationPage();
      }
    }
  }

  Future<String> _getUserPreference() async{
    final pref = await SharedPreferences.getInstance();
    final userPref = pref.getString('userUid');
    if(userPref==null){
      return '';
    }else{
      return userPref;
    }
  }

  Future<bool> checkUserInfo() async{
    var firebaseUser = FirebaseAuth.instance.currentUser;
    if(firebaseUser==null){
      setState(() {
        userChecked = true;
      });
      return false;
    }else{
      var result = await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).get();
      setState(() {
        userChecked = true;
      });
      return result.exists;
    }
  }

  // -1 == No payment information
  // 0 == Paid and confirmed and approved but expired
  // 1 == Paid and confirmed but not approved (confirmationNumber of transaction submitted)
  // 2 == Paid but not confirmed and not approved
  // 3 == Paid and confirmed and approved and not-expired
  Future<int> checkPaymentInfo() async{
    var firebaseUser = FirebaseAuth.instance.currentUser;
    var result = await FirebaseFirestore.instance.collection('paymentRequests').doc(firebaseUser.uid).get();
    setState(() {
      paymentChecked = true;
    });
    if(result.exists){
      PaymentModel paymentModel = PaymentModel.fromJson(result);
      
      bool expired = paymentModel.acceptedDate==null ? false : paymentModel.acceptedDate.difference(DateTime.now()).inDays > 60;
      
      if(!paymentModel.status && !paymentModel.confirmed){
        return 2;
      }
      
      if(!paymentModel.status && paymentModel.confirmed){
        return 1;
      }
      
      if(paymentModel.status && expired){
        return 0;
      }

      if(paymentModel.status && !expired){
        return 3;
      }
    }else{
      return -1;
    }
  }

}
