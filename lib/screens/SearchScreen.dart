import 'package:dim/widgets/SearchScreen/ReicipeListView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../widgets/SearchScreen/CatFoodList.dart';
import '../widgets/SearchScreen/HorizontalScrollingCat.dart';
import '../widgets/SearchScreen/SearchBarHome.dart';
import 'AddPost/CreateRecipePostScreen.dart';
import 'Profile/ProfileScreen.dart';
import 'package:dim/data/constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _selectedCategory = 'Popular';
  String _profileImageUrl = 'assets/images/profile.png';
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? imageUrl = user.photoURL; // Google account profile image URL
      if (imageUrl == null) {
        try {
          // Try to get the image from Firebase Storage
          imageUrl = await FirebaseStorage.instance
              .ref('profile_images/${user.uid}.png')
              .getDownloadURL();
        } catch (_) {
          imageUrl = 'assets/images/profile.png'; // Default fallback image
        }
      }
      setState(() {
        _profileImageUrl = imageUrl!;
      });
    }
  }

  void _updateSearchText(String text) {
    setState(() {
      _searchText = text;
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  Widget _buildProfileAvatar(BuildContext context, double width) {
    return Hero(
      tag: 'profile-hero',
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(imagePath: _profileImageUrl,),
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
            radius: width / 15,
            backgroundImage: _profileImageUrl.startsWith('http')
                ? NetworkImage(_profileImageUrl)
                : AssetImage(_profileImageUrl) as ImageProvider,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double height, double width) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Row(
        children: [
          Text(
            'What do you want\nto cook today?',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const Spacer(),
          _buildProfileAvatar(context, width),
        ],
      ),
    );
  }

  Widget _buildCategoryAndFoodList(double width, double height) {
    return Column(
      children: [
        SizedBox(height: height * 0.01),
        HorizontalScrollingCat(
          width: width,
          onCategorySelected: _onCategorySelected,
        ),
        Row(
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
        const CatFoodList(),
        Row(
          children: [
            SizedBox(width: width * 0.03),
            Text(
              'For you',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateRecipePostScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add_circle_outline_rounded,
                  color: Colors.white),
              label: Text(
                'Add Yours',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: width / 25,
                      color: Colors.white,
                    ),
              ),
              style: TextButton.styleFrom(backgroundColor: Colors.black),
            ),
            SizedBox(width: width * 0.03),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: height * 0.03),
            _buildHeader(context, height, width),
            SizedBox(height: height * 0.03),
            SearchBarHome(
              width: width,
              height: height,
              onSubmitted: _updateSearchText,
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) =>
                  FadeTransition(
                opacity: animation,
                child: child,
              ),
              child: _searchText.isEmpty
                  ? _buildCategoryAndFoodList(width, height)
                  : SizedBox.shrink(), // Hide when not needed
            ),
            RecipeListView(searchQuery: _searchText),
            SizedBox(height: height * 0.3),
          ],
        ),
      ),
    );
  }
}
