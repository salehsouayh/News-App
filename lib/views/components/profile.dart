import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  String name;
  bool goBack;

  Profile({Key? key, required this.name, required this.goBack}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome",
              style: TextStyle(fontSize: 17),
            ),
            const Text(
              "Saleh Souayh",
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            widget.goBack ? InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: const [
                  Icon(
                    Icons.arrow_back,
                    color: Colors.black54,
                  ),
                  Text(
                    'Go back',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.black54),
                  )
                ],
              ),
            ) : Container(),
          ],
        ),
        const CircleAvatar(
          radius: 30.0,
          backgroundImage: NetworkImage(
              "http://www.newdesignfile.com/postpic/2014/02/generic-user-icon-windows_325740.png"),
          backgroundColor: Colors.transparent,
        )
      ],
    );
  }
}
