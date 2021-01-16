import 'package:country_codes/country_codes.dart';
import 'package:dating/Screens/authenticate/AuthState.dart';
import 'package:dating/Services/authService.dart';
import 'package:dating/Services/locationService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:spring_button/spring_button.dart';
import 'AuthState.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  AuthService _authService = new AuthService();
  LocationService _locationService = new LocationService();
  

  String _phone = '';
  String _opt = '';

  String _verificationId;

  String _phoneAuthText = 'Tebesa needs to verify your identity. Please enter you phone nember. You will receive an SMS with a verification code.';
  String _otpText = 'Resend Code';

  TextEditingController phoneController;
  TextEditingController _verify;

  bool verify = false;
  bool waitingSms = false;

  bool errorGot = false;
  String errorMessage = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    phoneController = new TextEditingController();
    _verify = new TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFFD12043),),
          onPressed: (){
            Provider.of<AuthState>(context, listen: false).setUserIn(0);
          },
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text('Log In with phone \nnumber', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 22.0, letterSpacing: 0.0, color: Colors.grey[600]),),

            SizedBox(height: 25.0,),

            phoneController!=null ?
            Container(
              child: waitingSms ?
              SpinKitFadingCircle(
                itemBuilder: (BuildContext context, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: index.isEven ? Colors.redAccent : Colors.redAccent,
                    ),
                  );
                },
              ) :
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(!verify ? 'My Phone Number' : 'Enter OTP', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18.0, letterSpacing: 0.0, color: Colors.grey[500]),),
                  Text(!verify ? '$_phone' : '$_opt', style: TextStyle(fontWeight: FontWeight.w300, fontSize: !verify ? 18.0 : 24.0, letterSpacing: 1.0, color: Colors.black54),),
                ],
              ),
            ) :
            Container(),

            SizedBox(height: 10.0,),

            !verify ? IntlPhoneField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
                letterSpacing: 2,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
                contentPadding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
                hintText: 'Phone Number',
                hintStyle: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey[600],
                  letterSpacing: 1.0
                ),
                filled: true,
                fillColor: Colors.grey[200],
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35.0),
                  borderSide: BorderSide(
                      color: Colors.transparent, width: 0.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35.0),
                  borderSide: BorderSide(
                      color: Colors.transparent, width: 0.0),
                ),
              ),
              initialCountryCode: 'ET',
              onChanged: (phone) {
                setState(() {
                  _phone = phone.completeNumber;
                });
              },
            ) :
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.00),
              child: PinCodeTextField(
                keyboardType: TextInputType.number,
                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: Colors.white,
                  selectedColor: Colors.black87,
                  activeColor: Colors.white,
                  inactiveColor: Colors.black87,
                  inactiveFillColor: Colors.white,
                  selectedFillColor: Colors.grey[300]
                ),
                animationDuration: Duration(milliseconds: 300),
                backgroundColor: Colors.transparent,
                enableActiveFill: true,
//                  controller: _verify,
                onCompleted: (v) {
                  try{
                    _authService.signInWithOTP(_opt, _verificationId);
                  }catch(e){
                    setState(() {
                      errorGot = true;
                      errorMessage = 'Wrong OPT';
                    });
                  }

                },
                onChanged: (value) {
                  setState(() {
                    _opt = value.toString();
                  });
                },
                beforeTextPaste: (text) {
                  return true;
                },
              ),
            ),

            SizedBox(height: 10.0,),

            errorGot ? Center(child: Text( errorMessage, style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w400, fontSize: 17.0, letterSpacing: 1.0),)) : Container(),

            SizedBox(height: 25.0,),

            Center(child: Text(verify ? _otpText : _phoneAuthText, textAlign: TextAlign.center, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w300, fontSize: 17.0),)),

            SizedBox(height: 25.0,),

            verify ? Container() : Center(
              child: SpringButton(
                SpringButtonType.OnlyScale,
                Container(
                  width: MediaQuery.of(context).size.width/1.2,
                  height: 50.0,
                  decoration: BoxDecoration(
                      color: _phone.length<=10 ? Colors.grey[200] : Color(0xFFD12043),
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Center(
                    child:
                    Text(
                      'Continue',
                      style: TextStyle(color: _phone.length<=10 ? Colors.grey[800] : Colors.white, fontSize: 18, letterSpacing: 0.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                useCache: false,
                onTap: () {
                  if(_phone.length<=10){
                    setState(() {
                      errorGot = true;
                      errorMessage = 'Enter a valid phone number';
                    });
                  }else{
                    setState(() {
                      errorGot = false;
                      errorMessage = '';
                    });
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                    setState(() {
                      waitingSms = true;
                    });

                    try{
                      verifyPhone();
                    }catch(e){
                      print('***************** ${e.toString()}');
                    }
                  }

                },
              ),
            ),

          ],
        ),
      ),
    );
  }


  //Phone Verification
  Future<void> verifyPhone() async {

    print('********************* Verifying the phone *******************');
    print('********************* ${phoneController.text} *******************');
    print('********************* $_phone *******************');

    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      print('************ SIGNIN Function ************');
    };

    final PhoneVerificationFailed verificationfailed = (FirebaseAuthException authException) {
      print('**********: ${authException.message} :************');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this._verificationId = verId;
      setState(() {
        this.waitingSms = false;
        this.verify = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this._verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _phone,
      timeout: const Duration(seconds: 5),
      verificationCompleted: verified,
      verificationFailed: verificationfailed,
      codeSent: smsSent,
      codeAutoRetrievalTimeout: autoTimeout,
    );

  }

}
