import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipeCard extends StatelessWidget {
  final bool isMyPost;
  final String title;
  final String description;
  final List<String> ingredients;
  final String imageUrl;
  final bool isLiked;
  final int likeCount;
  final List<Map<String, dynamic>> commentsList;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSave;
  final Map<String, dynamic> user;
  final String createdAt;
  final Function() onLike;
  final Function(BuildContext) showComments;
  final String Function(DateTime) getTimeAgo;

  const RecipeCard({
    super.key,
    required this.isMyPost,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.imageUrl,
    required this.isLiked,
    required this.likeCount,
    required this.commentsList,
    required this.onEdit,
    required this.onDelete,
    required this.onSave,
    required this.user,
    required this.createdAt,
    required this.onLike,
    required this.showComments,
    required this.getTimeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(user['avatar']),
            ),
            title: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold, // Optional: make text bold
                    color: Colors.black, // Optional: set text color
                  ),
                ),
                const SizedBox(width: 8),
                // Text(
                //   'by ${user['name']}',
                //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                //     color: Colors.grey[600],
                //   ),
                // ),
              ],
            ),
            subtitle: Text(getTimeAgo(DateTime.parse(createdAt))),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isMyPost) ...[
                        ListTile(
                          leading: const Icon(Icons.edit),
                          title: const Text('Edit Post'),
                          onTap: () {
                            Navigator.pop(context);
                            onEdit();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete, color: Colors.red),
                          title: const Text('Delete Post',
                              style: TextStyle(color: Colors.red)),
                          onTap: () {
                            Navigator.pop(context);
                            onDelete();
                          },
                        ),
                      ],
                      ListTile(
                        leading: const Icon(Icons.bookmark_border),
                        title: const Text('Save Post'),
                        onTap: () {
                          Navigator.pop(context);
                          onSave();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          description,
                          style: Theme.of(context).textTheme.bodyLarge,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ingredients: ${ingredients.join(", ")}',
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text('Show Details'),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    constraints: const BoxConstraints(
                      minWidth: 150,
                      minHeight: 150,
                      maxWidth: 150,
                      maxHeight: 150,
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: AspectRatio(
                        aspectRatio: 1, // This ensures a perfect circle
                        child: ClipOval(
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              debugPrint('Error loading image: $error');
                              return Container(
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.restaurant,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.grey[200],
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : null,
                  ),
                  onPressed: onLike,
                ),
                Text('$likeCount'),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.add_comment_outlined),
                  onPressed: () => showComments(context),
                ),
                Text('${commentsList.length}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
