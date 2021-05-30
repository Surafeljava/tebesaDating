import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/Models/paymentModel.dart';
import 'package:dating/Models/userAuthModel.dart' as  usr;
import 'package:dating/Screens/authenticate/authenticate.dart';
import 'package:dating/Screens/home/mainScroll/mainHome.dart';
import 'package:dating/Screens/loading/loginCheckLoading.dart';
import 'package:dating/Screens/onBoarding/onBoardingScreen.dart';
import 'package:dating/Screens/payment/payment.dart';
import 'package:dating/Screens/payment/paymentApprovalWait.dart';
import 'package:dating/Screens/payment/paymentCheckingLoadingPage.dart';
import 'package:dating/Screens/payment/paymentConfirmPage.dart';
import 'package:dating/Screens/registration/registration.dart';
import 'package:dating/Screens/registration/registrationPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dating/Screens/loading/checkingFreeDate.dart';

import 'options/lang.dart';

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

  bool usedBefore = true;

  bool freeTimeChecked = false;

  bool freeTime = false;
  bool freeTimeTrue = false;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<usr.User>(context);

    final int a = Provider.of<Registration>(context).getUserIn;

    _checkFirstTimeUsage().then((value){
      setState(() {
        usedBefore = value;
      });
    });

    if(user==null && usedBefore){
      return Authenticate();
    }else if(!usedBefore){
      return OnBoardingScreen(onFinishClicked: changeUsedBefore,);
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

          //check for the free period


          checkFreePeriod().then((value){
            setState(() {
              freeTimeChecked = true;
              freeTime = value;
            });
          });

          if(!freeTimeChecked){
            return CheckingFreeDate(freeTrial: freeTimeTrue,);
          }else{
            if(freeTime){
              //directly to home
              return MainHome();
            }else{
              switch(paymentStatus){
                case -1:
                  return Payment(expired: false,);
                case 0:
                  return Payment(expired: true,);
                case 1:
                  return PaymentApprovalWait();
                case 2:
                  return PaymentConfirmPage(denied: false,);
                case 3:
                  return MainHome();
                case 4:
                  return PaymentConfirmPage(denied: true,);
              }
            }
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

  //todo: use these functions on loading
  Future<bool> _checkFirstTimeUsage() async{
    final pref = await SharedPreferences.getInstance();
    final userPref = pref.getString('usedBefore');
    if(userPref==null){
      return false;
    }else{
      return true;
    }
  }

  //This function will be sent to the child UI, so it can change on the parent
  void changeUsedBefore() async{
    final pref = await SharedPreferences.getInstance();
    pref.setString('usedBefore', 'yes');
    setState(() {
      usedBefore = !usedBefore;
    });
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
  // 4 == Paid and confirmed but denied
  Future<int> checkPaymentInfo() async{
    var firebaseUser = FirebaseAuth.instance.currentUser;
    var result = await FirebaseFirestore.instance.collection('paymentRequests').doc(firebaseUser.uid).get();
    setState(() {
      paymentChecked = true;
    });
    if(result.exists){
      PaymentModel paymentModel = PaymentModel.fromJson(result);
      
      bool expired = paymentModel.acceptedDate==null ? false : paymentModel.acceptedDate.difference(DateTime.now()).inDays > 60;
      
      if(paymentModel.status==1 && paymentModel.confirmed && !expired){
        return 3;
      }else if(paymentModel.status==1 && paymentModel.confirmed && expired){
        return 0;
      }else if(paymentModel.status==0 && paymentModel.confirmed){
        return 1;
      }else if(paymentModel.status==-1 && paymentModel.confirmed){
        return 4;
      }else if(!paymentModel.confirmed){
        return 2;
      }
    }else{
      return -1;
    }
  }

  Future<bool> checkFreePeriod() async{
    var result = await FirebaseFirestore.instance.collection('free_date').doc("expire").get();

    DateTime freeDate = DateTime.fromMicrosecondsSinceEpoch(result['date'].microsecondsSinceEpoch);
    
    if(freeDate.isAfter(DateTime.now())){

      await Future.delayed(Duration(seconds: 1));

      setState(() {
        freeTimeTrue = true;
      });

      await Future.delayed(Duration(seconds: 1));

      return true;
    }else{
      return false;
    }

  }

  void getLanguage() async{
    final pref = await SharedPreferences.getInstance();
    final userPref = pref.getString('language');

    if(userPref==null){
      pref.setString('language', 'en');
      setState(() {
        Lang.language = 1;
      });
    }else{
      if(userPref=='en'){
        setState(() {
          Lang.language = 1;
        });
      }else{
        setState(() {
          Lang.language = 0;
        });
      }
    }
  }

}
