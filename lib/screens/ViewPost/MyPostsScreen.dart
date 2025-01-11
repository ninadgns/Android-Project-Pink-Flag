import 'package:flutter/material.dart';
import 'package:dim/screens/AddPost/CreateRecipePostScreen.dart';
import 'RecipeCard.dart';
import 'CommentSection.dart';
import 'demoPostData.dart';


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
  final int? id;
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
      id: json['id'],
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
    final difference = DateTime.now().difference(dateTime);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
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

class MyPostsTab extends StatelessWidget {
  const MyPostsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mockRecipesList.length,
      itemBuilder: (context, index) {
        final post = mockRecipesList[index];
        return RecipePost(
          isMyPost: true,
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