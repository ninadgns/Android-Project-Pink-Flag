import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
Future<void> launchURL(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}
class ManushItem extends StatelessWidget {
  ManushItem({
    super.key,
    required this.name,
    required this.photoUrl,
    required this.roll,
    required this.ghUrl,
  });
  String name;
  String photoUrl;
  String roll;
  String ghUrl;


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return InkWell(borderRadius: BorderRadius.circular(100),

      onTap: () async {
        await launchURL(ghUrl);
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(100),
                bottomLeft: Radius.circular(100),
                topRight: Radius.circular(40),
                bottomRight: Radius.circular(40))),
        margin: EdgeInsets.only(bottom: 15),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(100),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  photoUrl,
                  width: height * 0.1,
                  height: height * 0.1,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text("Roll: $roll"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
