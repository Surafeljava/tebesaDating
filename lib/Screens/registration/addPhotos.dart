import 'package:flutter/material.dart';

class AddPhotos extends StatefulWidget {
  @override
  _AddPhotosState createState() => _AddPhotosState();
}

class _AddPhotosState extends State<AddPhotos> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add photos', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22.0, letterSpacing: 0.0, color: Colors.grey[800]),),
          SizedBox(height: 5.0,),
          Text('Upload or take pictures', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0, letterSpacing: 0.0, color: Colors.grey[800]),),
          SizedBox(height: 25.0,),
        ],
      ),
    );
  }
}
