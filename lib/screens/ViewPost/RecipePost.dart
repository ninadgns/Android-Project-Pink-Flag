import 'package:flutter/material.dart';
import 'CommentSection.dart';

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
            title: Flexible(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'by ${user['name']}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            subtitle: Text(
              getTimeAgo(DateTime.parse(createdAt)),
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showOptionsMenu(context),
            ),
          ),
          IntrinsicHeight(
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
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text('Show Details'),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: imageUrl.startsWith('assets/')
                          ? AssetImage(imageUrl)
                          : NetworkImage(imageUrl) as ImageProvider,
                      onBackgroundImageError: (exception, stackTrace) {
                        debugPrint('Error loading image: $exception');
                      },
                      child: imageUrl.isEmpty
                          ? const Icon(Icons.fastfood, size: 40)
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : null,
                  ),
                  onPressed: onLike,
                  padding: const EdgeInsets.all(0),
                ),
                Text('$likeCount'),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.add_comment_outlined),
                  onPressed: () => showComments(context),
                  padding: const EdgeInsets.all(0),
                ),
                Text('${commentsList.length}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
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
      ),
    );
  }
}