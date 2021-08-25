import 'package:dating/Models/bankDetail.dart';
import 'package:flutter/material.dart';
import 'package:spring_button/spring_button.dart';

class BankChooseCard extends StatelessWidget {
  final BankDetail bankDetail;
  final Function onClicked;
  final double width;
  final double height;
  final int selected;
  final int myIndex;

  BankChooseCard(
      {this.bankDetail,
      this.onClicked,
      this.width,
      this.height,
      this.selected,
      this.myIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.0),
      child: SpringButton(
        SpringButtonType.OnlyScale,
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: selected == myIndex ? Colors.white : Colors.white,
            borderRadius: BorderRadius.circular(25.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[400], offset: Offset(1, 2), blurRadius: 4),
              BoxShadow(
                  color: Colors.white, offset: Offset(-1, -2), blurRadius: 4),
            ],
            border: selected == myIndex
                ? Border.all(color: Colors.pinkAccent, width: 3.0)
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${bankDetail.name}',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0),
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                height: height * 0.5,
                width: width * 0.6,
                child: Image(
                  image: NetworkImage('${bankDetail.image}'),
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
        useCache: false,
        scaleCoefficient: 0.9,
        onTap: () {
          onClicked(myIndex);
        },
      ),
    );
  }
}
