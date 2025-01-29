import 'package:flutter/material.dart';
import 'package:dim/screens/AddPost/CreateRecipePostScreen.dart';
import '../../services/love_react_service.dart';
import '../review_screen.dart';
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
                      'My Posts',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),


              Expanded(
                child: IndexedStack(
                  index: selectedIndex,
                  children: const [
                    MyPostsTab(),
                    //AllPostsTab(),
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
  final List<Map<String, dynamic>> steps;

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
    required this.steps,
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
      steps: List<Map<String, dynamic>>.from(json['steps'] ?? []),
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
  final LoveReactService _loveReactService = LoveReactService();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.initialIsLiked;
    likeCount = widget.likes;
    commentsList = List.from(widget.comments);
    _initializeLikeStatus();
  }

  Future<void> _initializeLikeStatus() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null && widget.id != null) {
        // Fetch like status and count in parallel
        final Future<bool> hasLovedFuture = _loveReactService.hasUserLoved(widget.id!, userId);
        final Future<List<Map<String, dynamic>>> lovesFuture = _loveReactService.fetchLoveReacts(widget.id!);

        // Wait for both futures to complete
        final results = await Future.wait([hasLovedFuture, lovesFuture]);
        final bool hasLoved = results[0] as bool;
        final List<Map<String, dynamic>> loves = results[1] as List<Map<String, dynamic>>;

        if (mounted) {
          setState(() {
            isLiked = hasLoved;
            likeCount = loves.length;
            _isInitialized = true;
          });
        }
      }
    } catch (e) {
      print('Error initializing like status: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading like status: ${e.toString()}')),
        );
      }
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _handleLike() async {
    if (!_isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please wait while we load the like status')),
      );
      return;
    }

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null || widget.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to like recipes')),
      );
      return;
    }

    try {
      // Optimistically update UI
      setState(() {
        isLiked = !isLiked;
        likeCount = isLiked ? likeCount + 1 : likeCount - 1;
      });

      if (isLiked) {
        await _loveReactService.addLoveReact(
          widget.id!,
          userId,
          FirebaseAuth.instance.currentUser?.displayName ?? 'Anonymous',
        );
      } else {
        await _loveReactService.removeLoveReact(widget.id!, userId);
      }

      // Fetch actual count after operation
      final loves = await _loveReactService.fetchLoveReacts(widget.id!);
      if (mounted) {
        setState(() {
          likeCount = loves.length;
        });
      }
    } catch (e) {
      // Revert on error
      if (mounted) {
        setState(() {
          isLiked = !isLiked;
          likeCount = isLiked ? likeCount + 1 : likeCount - 1;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update like: ${e.toString()}'),
            duration: const Duration(seconds: 2),
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
      onEdit: widget.onEdit,
      onDelete: widget.onDelete,
      onSave: widget.onSave,
      user: widget.user,
      createdAt: widget.createdAt!,
      onLike: _handleLike,
      recipeId: widget.id ?? '',  // ✅ Pass the correct recipe ID
      showComments: () => _openReviewScreen(context),  // ✅ Open review screen instead of comments
      steps: widget.steps,
    );
  }

  void _openReviewScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewScreen(
          recipeId: widget.id ?? '',  // Pass recipe ID correctly
          userId: FirebaseAuth.instance.currentUser!.uid,
        ),
      ),
    );
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
          steps: [],

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

      debugPrint('Fetched recipes: $response');

      final List<RecipePost> recipes = response.map<RecipePost>((recipeData) {
        // Transform ingredients data to string list
        final ingredients = (recipeData['ingredients'] as List)
            .map((ing) => "${ing['quantity']} ${ing['unit']} ${ing['name']}")
            .toList();

        // Transform steps data
        final steps = (recipeData['steps'] as List).map((step) => {
          'description': step['description'],
          'time': step['time'],
          'step_order': step['step_order'],
        }).toList();

        // Sort steps by step_order
        steps.sort((a, b) => (a['step_order'] as int).compareTo(b['step_order'] as int));

        String imageUrl = recipeData['title_photo'] ?? '';
        if (!imageUrl.startsWith('http')) {
          imageUrl = Supabase.instance.client.storage
              .from('recipe')
              .getPublicUrl(imageUrl.replaceFirst('recipe/', ''));
        }

        return RecipePost(
          id: recipeData['id'],
          isMyPost: true,
          title: recipeData['title'] ?? '',
          description: recipeData['description'] ?? '',
          ingredients: ingredients.cast<String>(),
          imageUrl: imageUrl,
          likes: 0,
          initialIsLiked: false,
          comments: [],
          steps: steps, // Add steps here
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
        // Perform delete from database
        await Supabase.instance.client
            .from('recipes')
            .delete()
            .match({'id': recipeId});

        // Refresh list after deletion
        _fetchUserRecipes();

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