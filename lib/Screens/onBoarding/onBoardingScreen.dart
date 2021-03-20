import 'package:flutter/material.dart';

class OnBoardingScreen extends StatefulWidget {

  @required final Function onFinishClicked;

  OnBoardingScreen({this.onFinishClicked});

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  PageController _pageController;

  @override
  void initState() {
    _pageController = new PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                SafeArea(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(height: 30.0,),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Text('Welcome to Tebesa!', style: TextStyle(color: Colors.grey[800], fontSize: 30.0, fontWeight: FontWeight.w600, letterSpacing: 0.5),),
                        ),
                        Text('Join our community', style: TextStyle(color: Colors.grey[600], fontSize: 20.0, fontWeight: FontWeight.w300, letterSpacing: 0.8),),
                        Spacer(),
                        Center(
                          child: Image(
                            width: MediaQuery.of(context).size.width*0.8,
                            height: MediaQuery.of(context).size.width*0.8,
                            image: AssetImage('assets/boarding/chat2.jpg'),
                            fit: BoxFit.contain,
                          ),
                        ),

                        SizedBox(
                          height: 20.0,
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                child: Text('Skip', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: Colors.grey[800]),),
                                onPressed: (){
                                  _pageController.animateToPage(3, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                },
                              ),
                              TextButton(
                                child: Text('Next', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: Colors.grey[800]),),
                                onPressed: (){
                                  _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ),

                SafeArea(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          SizedBox(height: 30.0,),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Text('Welcome to Tebesa!', style: TextStyle(color: Colors.grey[800], fontSize: 30.0, fontWeight: FontWeight.w600, letterSpacing: 0.5),),
                          ),
                          Text('Date!', style: TextStyle(color: Colors.grey[600], fontSize: 20.0, fontWeight: FontWeight.w300, letterSpacing: 0.8),),
                          Spacer(),
                          Center(
                            child: Image(
                              width: MediaQuery.of(context).size.width*0.8,
                              height: MediaQuery.of(context).size.width*0.8,
                              image: AssetImage('assets/boarding/date.jpg'),
                              fit: BoxFit.contain,
                            ),
                          ),

                          SizedBox(
                            height: 20.0,
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  child: Text('Skip', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: Colors.grey[800]),),
                                  onPressed: (){
                                    _pageController.animateToPage(3, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                  },
                                ),
                                TextButton(
                                  child: Text('Next', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: Colors.grey[800]),),
                                  onPressed: (){
                                    _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                ),

                SafeArea(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          SizedBox(height: 30.0,),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Text('Welcome to Tebesa!', style: TextStyle(color: Colors.grey[800], fontSize: 30.0, fontWeight: FontWeight.w600, letterSpacing: 0.5),),
                          ),
                          Text('Chat!', style: TextStyle(color: Colors.grey[600], fontSize: 20.0, fontWeight: FontWeight.w300, letterSpacing: 0.8),),
                          Spacer(),
                          Center(
                            child: Image(
                              width: MediaQuery.of(context).size.width*0.8,
                              height: MediaQuery.of(context).size.width*0.8,
                              image: AssetImage('assets/boarding/chat.jpg'),
                              fit: BoxFit.contain,
                            ),
                          ),

                          SizedBox(
                            height: 20.0,
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  child: Text('Skip', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: Colors.grey[800]),),
                                  onPressed: (){
                                    _pageController.animateToPage(3, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                  },
                                ),
                                TextButton(
                                  child: Text('Next', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: Colors.grey[800]),),
                                  onPressed: (){
                                    _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                ),

                SafeArea(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          SizedBox(height: 30.0,),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Text('Welcome to Tebesa!', style: TextStyle(color: Colors.grey[800], fontSize: 30.0, fontWeight: FontWeight.w600, letterSpacing: 0.5),),
                          ),
                          Text('Enjoy!', style: TextStyle(color: Colors.grey[600], fontSize: 20.0, fontWeight: FontWeight.w300, letterSpacing: 0.8),),
                          Spacer(),
                          Center(
                            child: Image(
                              width: MediaQuery.of(context).size.width*0.8,
                              height: MediaQuery.of(context).size.width*0.8,
                              image: AssetImage('assets/boarding/flowers.jpg'),
                              fit: BoxFit.contain,
                            ),
                          ),

                          SizedBox(
                            height: 20.0,
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  child: Text('Finish', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: Colors.grey[800]),),
                                  onPressed: widget.onFinishClicked,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}
