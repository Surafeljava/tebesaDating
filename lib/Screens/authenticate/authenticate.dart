import 'package:dating/Screens/authenticate/sign_in.dart';
import 'package:dating/Services/authService.dart';
import 'package:flutter/material.dart';
import 'package:spring_button/spring_button.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  AuthService _authService = new AuthService();

  int signIn = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: signIn==0 ? Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color(0xFFFFC2D7),
                      Colors.white
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                )
            ),
          ),

          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Spacer(flex: 2,),

                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/logo/tebesa_logo_100.png'),
                      fit: BoxFit.cover
                    )
                  ),
                ),

                Spacer(flex: 1,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Center(
                    child: Text('By tapping log in, you agree with our terms of service and privacy policy.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),),
                  ),
                ),

                SizedBox(height: 20.0,),

                SpringButton(
                  SpringButtonType.OnlyScale,
                  Container(
                    width: MediaQuery.of(context).size.width/1.2,
                    height: 50.0,
                    decoration: BoxDecoration(
                        color: Color(0xFFD12043),
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: Center(
                      child:
                      Text(
                        'Log In with phone number',
                        style: TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 0.0, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  useCache: false,
                  onTap: () {
                    setState(() {
                      signIn = 1;
                    });
                  },
                ),

                SizedBox(height: 10.0,),

                SpringButton(
                  SpringButtonType.OnlyScale,
                  Container(
                    width: MediaQuery.of(context).size.width/1.2,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        width: 2.0,
                        color: Color(0xFFD12043),
                      ),
                    ),
                    child: Center(
                      child:
                      Text(
                        'Log In with email address',
                        style: TextStyle(color: Color(0xFFD12043), fontSize: 18, letterSpacing: 0.0, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  useCache: false,
                  onTap: () {
                    setState(() {
                      signIn = 1;
                    });
                  },
                ),

                Spacer(flex: 3,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Center(
                    child: Text('Terms of service and privacy policy', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),),
                  ),
                ),

                SizedBox(height: 15.0,),
              ],
            ),
          ),
        ],
      ) : SignIn(),
    );
  }
}
