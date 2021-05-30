import 'dart:io';

import 'package:dating/Services/databaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spring_button/spring_button.dart';

import 'lang.dart';

class UpdatePhotos extends StatefulWidget {
  @override
  _UpdatePhotosState createState() => _UpdatePhotosState();
}

class _UpdatePhotosState extends State<UpdatePhotos> {
  List<dynamic> photos = [];

  String photoIcon = 'assets/icons/photo2.svg';
  String plusIcon = 'assets/icons/plus.svg';

  bool done = false;
  bool uploading = false;

  int clickedIndex = -1;

  bool photoClicked = false;

  File _image;
  final picker = ImagePicker();

  DatabaseService _databaseService = new DatabaseService();

  bool photosListAdded = false;

  Future<bool> getImage(ImageSource src) async {
    final pickedFile = await picker.getImage(source: src);

    if (pickedFile != null) {
      if (photos.length > clickedIndex) {
        setState(() {
          uploading = true;
        });
        String name = FirebaseAuth.instance.currentUser.uid.toString() +
            clickedIndex.toString();
        String url =
            await _databaseService.uploadOnePhoto(File(pickedFile.path), name);
        setState(() {
          photos[clickedIndex] = url;
          uploading = false;
        });
      } else {
        String name = FirebaseAuth.instance.currentUser.uid.toString() +
            clickedIndex.toString();
        String url =
            await _databaseService.uploadOnePhoto(File(pickedFile.path), name);
        setState(() {
          photos.add(url);
        });
      }
      return true;
    } else {
      print('No image selected.');
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _databaseService.getMyPhotos().then((value) {
      setState(() {
        photos = value;
        photosListAdded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          Lang.language == 0 ? 'Edit Profile' : 'ፎቶ አስተካክል',
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w400,
              color: Colors.grey[800],
              letterSpacing: 1.0),
        ),
        iconTheme: IconThemeData(
          color: Colors.grey[800],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.grey[800],
            ),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: !photosListAdded
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  color: Colors.white,
                  child: ListView(
                    children: [
                      Text(
                        Lang.language == 0 ? 'Add Photo' : 'ፎቶ ጨምር',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 22.0,
                            letterSpacing: 0.0,
                            color: Colors.grey[800]),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        Lang.language == 0
                            ? 'Upload or take pictures '
                            : 'ፎቶግራፍ ያንሱ ወይም ከጋለሪ ይምረጡ',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            color: Colors.grey[800]),
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width * 1.2,
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 15.0,
                                  crossAxisSpacing: 15.0,
                                  crossAxisCount: 3,
                                  childAspectRatio: 0.9),
                          itemBuilder: (_, index) {
                            return SpringButton(
                              SpringButtonType.OnlyScale,
                              Container(
                                decoration: BoxDecoration(
                                  color: index > photos.length
                                      ? Colors.white
                                      : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: photos.length >= index + 1
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                            image: NetworkImage(photos[index]),
                                            fit: BoxFit.cover,
                                          )),
                                        ),
                                      )
                                    : Center(
                                        child: index == photos.length
                                            ? SvgPicture.asset(
                                                plusIcon,
                                                width: 25.0,
                                                height: 25.0,
                                                color: Colors.grey[300],
                                              )
                                            : Container(),
                                      ),
                              ),
                              useCache: false,
                              onTap: () {
                                if (index <= photos.length) {
                                  setState(() {
                                    photoClicked = true;
                                    clickedIndex = index;
                                  });
                                }
                              },
                            );
                          },
                          itemCount: 9,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Center(
                        child: SpringButton(
                          SpringButtonType.OnlyScale,
                          Container(
                            width: MediaQuery.of(context).size.width - 30,
                            height: 50.0,
                            decoration: BoxDecoration(
                                color: photos.length == 0
                                    ? Colors.grey[200]
                                    : Color(0xFFD12043),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Center(
                              child: Text(
                                Lang.language == 0 ? 'Save' : 'አስቀምጥ',
                                style: TextStyle(
                                    color: photos.length == 0
                                        ? Colors.grey[800]
                                        : Colors.white,
                                    fontSize: 18,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          useCache: false,
                          onTap: () async {
                            if (photos.isNotEmpty) {
                              await _databaseService.updatePhotos(photos);
                              Navigator.of(context).pop();
                            } else {
                              print('Add Pictures First');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                photoClicked && !uploading
                    ? Container(
                        color: Colors.black26,
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            height: MediaQuery.of(context).size.width / 1.5,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Column(
                              children: [
                                FlatButton(
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      photoClicked = false;
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Center(
                                  child: SpringButton(
                                    SpringButtonType.OnlyScale,
                                    Container(
                                      width:
                                          (MediaQuery.of(context).size.width /
                                                  1.5) -
                                              30.0,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Center(
                                        child: Text(
                                          'Camera',
                                          style: TextStyle(
                                              color: Colors.grey[800],
                                              fontSize: 18,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                    useCache: false,
                                    onTap: () async {
                                      getImage(ImageSource.camera)
                                          .then((value) {
                                        print('Image get Result: $value');
                                      });
                                      setState(() {
                                        photoClicked = false;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Center(
                                  child: SpringButton(
                                    SpringButtonType.OnlyScale,
                                    Container(
                                      width:
                                          (MediaQuery.of(context).size.width /
                                                  1.5) -
                                              30.0,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Center(
                                        child: Text(
                                          'Gallery',
                                          style: TextStyle(
                                              color: Colors.grey[800],
                                              fontSize: 18,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                    useCache: false,
                                    onTap: () {
                                      getImage(ImageSource.gallery)
                                          .then((value) {
                                        print('Image get Result: $value');
                                      });
                                      setState(() {
                                        photoClicked = false;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                clickedIndex < photos.length
                                    ? Center(
                                        child: SpringButton(
                                          SpringButtonType.OnlyScale,
                                          Container(
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5) -
                                                30.0,
                                            height: 50.0,
                                            decoration: BoxDecoration(
                                                color: Color(0xFFD12043),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            child: Center(
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                          useCache: false,
                                          onTap: () {
                                            setState(() {
                                              photos.removeAt(clickedIndex);
                                              photoClicked = false;
                                            });
                                          },
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                      )
                    : !photoClicked && uploading
                        ? Container(
                            color: Colors.black12,
                            child: Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.6,
                                height: MediaQuery.of(context).size.width / 1.6,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'uploading...',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 22.0,
                                          letterSpacing: 0.0,
                                          color: Colors.grey[800]),
                                    ),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    SpinKitFadingCircle(
                                      color: Color(0xFFD12043),
                                      size: 40.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(),
              ],
            ),
    );
  }
}
