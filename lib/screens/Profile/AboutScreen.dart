import 'package:dim/data/constants.dart';
import 'package:dim/widgets/ProfileScreen/ManushItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        // color: Colors.red,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  // SizedBox(width: 10),
                  Text(
                    'About Us',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  'assets/images/pink_flag.png',
                  height: 100,
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Team Pink Flag',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 10),
              Text(
                "Crafting Innovation, Serving Excellence!",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 25),
              Column(
                children: [...teamMembers],
              ),
              SizedBox(height: 15),
              InkWell(
                onTap: () async {
                  await launchURL(repoLink);
                },
                child: Image.asset(
                  'assets/images/gitHub.png',
                  height: 70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
