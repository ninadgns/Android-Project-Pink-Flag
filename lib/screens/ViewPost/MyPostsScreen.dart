import 'package:flutter/material.dart';
import 'package:dim/screens/AddPost/CreateRecipePostScreen.dart';
import 'RecipeCard.dart';
import 'CommentSection.dart';
import 'demoPostData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import '../ViewPost/RecipeEditPostScreen.dart';  // Import the edit screen


class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Posts',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Custom Tab Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => selectedIndex = 0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: selectedIndex == 0
                                  ? Colors.black
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: Text(
                                'My Posts',
                                style: TextStyle(
                                  color: selectedIndex == 0
                                      ? Colors.white
                                      : Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => selectedIndex = 1),
                          child: Container(
                            decoration: BoxDecoration(
                              color: selectedIndex == 1
                                  ? Colors.black
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: Text(
                                'All Posts',
                                style: TextStyle(
                                  color: selectedIndex == 1
                                      ? Colors.white
                                      : Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content
              Expanded(
                child: IndexedStack(
                  index: selectedIndex,
                  children: const [
                    MyPostsTab(),
                    AllPostsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateRecipePostScreen(),
            ),
          );
          if (result != null) {
            print("Created Post: $result");
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}



class RecipePost extends StatefulWidget {
  final bool isMyPost;
  final String title;
  final String description;
  final List<String> ingredients;
  final String imageUrl;
  final int likes;
  final List<Map<String, dynamic>> comments;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSave;
  final String? id; // Changed from int? to String?
  final String? createdAt;
  final bool initialIsLiked;
  final Map<String, dynamic> user;

  const RecipePost({
    super.key,
    required this.isMyPost,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    required this.onEdit,
    required this.onDelete,
    required this.onSave,
    required this.user,
    this.id,
    this.createdAt,
    this.initialIsLiked = false,
  });

  factory RecipePost.fromJson(Map<String, dynamic> json) {
    return RecipePost(
      id: json['id'].toString(), // Convert to String if it's not already
      title: json['title'],
      description: json['description'],
      ingredients: List<String>.from(json['ingredients']),
      imageUrl: json['imageUrl'],
      likes: json['likes'],
      comments: List<Map<String, dynamic>>.from(json['comments']),
      createdAt: json['createdAt'],
      initialIsLiked: json['isLiked'] ?? false,
      user: json['user'],
      isMyPost: false,
      onEdit: () {},
      onDelete: () {},
      onSave: () {},
    );
  }

  @override
  State<RecipePost> createState() => _RecipePostState();
}

class _RecipePostState extends State<RecipePost> {
  late bool isLiked;
  late int likeCount;
  late List<Map<String, dynamic>> commentsList;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.initialIsLiked;
    likeCount = widget.likes;
    commentsList = List.from(widget.comments);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _handleLike() async {
    setState(() {
      isLiked = !isLiked;
      likeCount = isLiked ? likeCount + 1 : likeCount - 1;
    });

    try {
      await Future.delayed(const Duration(seconds: 1));
      print('Like updated for post ${widget.id}: isLiked=$isLiked');
    } catch (e) {
      setState(() {
        isLiked = !isLiked;
        likeCount = isLiked ? likeCount + 1 : likeCount - 1;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update like. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _handleAddComment() async {
    if (_commentController.text.isEmpty) return;

    final newComment = {
      "id": commentsList.length + 1,
      "userId": "currentUser",
      "userName": "Current User",
      "userAvatar": "assets/images/profile.png",
      "text": _commentController.text,
      "createdAt": DateTime.now().toIso8601String()
    };

    setState(() {
      commentsList.add(newComment);
      _commentController.clear(); // Clear the input field immediately
    });

    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulated API call
      print('Comment added to post ${widget.id}');
    } catch (e) {
      // If the API call fails, remove the comment
      if (mounted) {
        setState(() {
          commentsList.removeLast();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add comment. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return RecipeCard(
      isMyPost: widget.isMyPost,
      title: widget.title,
      description: widget.description,
      ingredients: widget.ingredients,
      imageUrl: widget.imageUrl,
      isLiked: isLiked,
      likeCount: likeCount,
      commentsList: commentsList,
      onEdit: widget.onEdit,
      onDelete: widget.onDelete,
      onSave: widget.onSave,
      user: widget.user,
      createdAt: widget.createdAt!,
      onLike: _handleLike,
      showComments: _showComments,
      getTimeAgo: _getTimeAgo,
    );
  }

  void _showComments(BuildContext context) {
    final commentSection = CommentSection(
      commentsList: commentsList,
      commentController: _commentController,
      handleAddComment: _handleAddComment,
      getTimeAgo: _getTimeAgo,
    );
    commentSection.show(context);

  }

  String _getTimeAgo(DateTime dateTime) {
    // Convert the UTC time to local time
    final localDateTime = dateTime.toLocal();
    final now = DateTime.now();
    final difference = now.difference(localDateTime);

    // Debug prints to help understand the time calculation
    print('Server time (UTC): $dateTime');
    print('Local time: $localDateTime');
    print('Current time: $now');
    print('Difference in hours: ${difference.inHours}');

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '${years}y ago';
    }
  }
}

final List<RecipePost> mockRecipesList = mockRecipes
    .map((json) => RecipePost.fromJson(json))
    .toList();
// Update AllPostsTab and MyPostsTab to include user information
class AllPostsTab extends StatelessWidget {
  const AllPostsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mockRecipesList.length,
      itemBuilder: (context, index) {
        final post = mockRecipesList[index];
        return RecipePost(
          isMyPost: false,
          title: post.title,
          description: post.description,
          ingredients: post.ingredients,
          imageUrl: post.imageUrl,
          likes: post.likes,
          comments: post.comments,
          user: post.user, // Add user information
          onEdit: () {},
          onDelete: () {},
          onSave: () {},
          id: post.id,
          createdAt: post.createdAt,
          initialIsLiked: post.initialIsLiked,
        );
      },
    );
  }
}

class MyPostsTab extends StatefulWidget {
  const MyPostsTab({super.key});

  @override
  State<MyPostsTab> createState() => _MyPostsTabState();
}

class _MyPostsTabState extends State<MyPostsTab> {
  List<RecipePost> _userRecipes = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchUserRecipes();
  }

  Future<void> _fetchUserRecipes() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      // Fetch recipes with related data
      final response = await Supabase.instance.client
          .from('recipes')
          .select('''
            *,
            nutrition(protein, carbs, fat),
            ingredients(name, quantity, unit),
            steps(description, time, step_order)
          ''')
          .eq('user_id', currentUserId)
          .order('created_at', ascending: false);

      debugPrint('Fetched recipes: $response'); // Debug print

      // Convert the response to RecipePost objects
      final List<RecipePost> recipes = response.map<RecipePost>((recipeData) {
        // Transform ingredients data to string list
        final ingredients = (recipeData['ingredients'] as List)
            .map((ing) => "${ing['quantity']} ${ing['unit']} ${ing['name']}")
            .toList();

        // Get the complete image URL from Supabase storage
        String imageUrl = recipeData['title_photo'] ?? '';

        // If the URL doesn't start with 'http', it's a storage path
        if (!imageUrl.startsWith('http')) {
          imageUrl = Supabase.instance.client.storage
              .from('recipe') // your bucket name
              .getPublicUrl(imageUrl.replaceFirst('recipe/', '')); // remove bucket prefix if present
        }

        return RecipePost(
          id: recipeData['id'],
          isMyPost: true,
          title: recipeData['title'] ?? '',
          description: recipeData['description'] ?? '',
          ingredients: ingredients.cast<String>(),
          imageUrl: imageUrl, // Use the complete URL
          likes: 0,
          comments: [],
          user: {
            'id': currentUserId,
            'name': 'Current User',
            'avatar': 'assets/images/profile.png'
          },
          onEdit: () => _handleEditRecipe(recipeData['id']),
          onDelete: () => _handleDeleteRecipe(recipeData['id']),
          onSave: () {},
          createdAt: recipeData['created_at'],
        );
      }).toList();

      setState(() {
        _userRecipes = recipes;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching recipes: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }
  Future<void> _handleDeleteRecipe(String recipeId) async {
    try {
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Recipe'),
          content: const Text('Are you sure you want to delete this recipe?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (shouldDelete ?? false) {
        await Supabase.instance.client
            .from('recipes')
            .delete()
            .match({'id': recipeId});

        _fetchUserRecipes(); // Refresh the list

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Recipe deleted successfully')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete recipe: $e')),
        );
      }
    }
  }

  void _handleEditRecipe(String recipeId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditRecipePostScreen(recipeId: recipeId),
      ),
    ).then((edited) {
      if (edited == true) {
        // Refresh the recipes list if the recipe was edited successfully
        _fetchUserRecipes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchUserRecipes,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_userRecipes.isEmpty) {
      return const Center(
        child: Text('No recipes found. Create your first recipe!'),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchUserRecipes,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _userRecipes.length,
        itemBuilder: (context, index) => _userRecipes[index],
      ),
    );
  }
}