import 'package:dim/screens/GetStarted.dart';
import 'package:dim/screens/Profile/ProfileScreen.dart';
import 'package:dim/widgets/SearchScreen/ReicipeListView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../widgets/SearchScreen/CatFoodList.dart';
import '../widgets/SearchScreen/HorizontalScrollingCat.dart';
import '../widgets/SearchScreen/SearchBarHome.dart';
import 'AddPost/CreateRecipePostScreen.dart';
import 'package:dim/data/constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _selectedCategory = 'Popular';
  String _profileImageUrl='assets/images/yellow.jpg';


  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  Future<void> _loadProfileImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? imageUrl =
          user.photoURL; // Get the Google account profile image URL
      if (imageUrl == null) {
        try {
          // Try to get the image from Firebase Storage
          imageUrl = await FirebaseStorage.instance
              .ref('profile_images/${user.uid}.png')
              .getDownloadURL();
        } catch (e) {
          // Fallback to a default image if the image is not found
          imageUrl = 'assets/images/profile.png';
        }
      }
      setState(() {
        _profileImageUrl = imageUrl!;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadProfileImage();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if(login1){
      _profileImageUrl= 'assets/images/profile.png'  ;
    }
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.03),
              Row(
                children: [
                  SizedBox(width: width * 0.05),
                  Text(
                    'What do you want\nto cook today?',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const Spacer(),
                  SizedBox(width: width * 0.05),
                  Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                if (login1) {
                                  return ProfileScreen(imagePath: _profileImageUrl); // Forward image data
                                } else {
                                  return const Getstarted(); // Forward image data to another screen
                                }
                              },
                              //=> const ProfileScreen(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: width / 15, // larger size
                            backgroundImage: _profileImageUrl.startsWith('http')
                                ? NetworkImage(_profileImageUrl)
                                : AssetImage(_profileImageUrl) as ImageProvider,
                          ),
                        ),
                      ),
                    ),
                  SizedBox(width: width * 0.04),
                ],
              ), // Top text
              SizedBox(height: height * 0.03),
              SearchBarHome(width: width, height: height),
              SizedBox(height: height * 0.01),
              HorizontalScrollingCat(
                  width: width, onCategorySelected: _onCategorySelected),
              // SizedBox(height: _height * 0.01),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: width * 0.04),
                  Text(
                    '$_selectedCategory ',
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontSize: width / 18),
                  ),
                  Text(
                    'Recipes',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(fontSize: width / 18),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'View All',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: width / 25),
                    ),
                  ),
                  SizedBox(width: width * 0.02),
                ],
              ),
              // SizedBox(height: 5),
              const CatFoodList(),
              // SizedBox(height: _height * 0.03),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: width * 0.03),
                  Text('For you',
                      style: Theme.of(context).textTheme.displayMedium),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateRecipePostScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_circle_outline_rounded,
                        color: Colors.white),
                    iconAlignment: IconAlignment.start,
                    label: Text(
                      'Add Yours',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: width / 25, color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                  ),
                  SizedBox(width: width * 0.03),
                ],
              ),
              SizedBox(height: height * 0.01),
              RecipeListView(),
              SizedBox(height: height * 0.03),
              Container(
                height: height * 0.2,
                color: const Color(0xfffaf6f2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
