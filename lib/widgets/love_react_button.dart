import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/love_react_service.dart';

class LoveReactButton extends StatefulWidget {
  final String recipeId;

  const LoveReactButton({Key? key, required this.recipeId}) : super(key: key);

  @override
  _LoveReactButtonState createState() => _LoveReactButtonState();
}

class _LoveReactButtonState extends State<LoveReactButton> {
  final LoveReactService _loveReactService = LoveReactService();
  bool isLoved = false;
  int totalLoves = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchLoveStatus();
  }

  Future<void> _fetchLoveStatus() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final reacts = await _loveReactService.fetchLoveReacts(widget.recipeId);

    setState(() {
      totalLoves = reacts.length;
      isLoved = reacts.any((react) => react['user_id'] == userId);
    });
  }

  Future<void> _toggleLoveReact() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userName = FirebaseAuth.instance.currentUser!.displayName ??
        FirebaseAuth.instance.currentUser!.email ??
        'Anonymous';

    setState(() {
      isLoading = true;
    });

    if (isLoved) {
      await _loveReactService.removeLoveReact(widget.recipeId, userId);
      setState(() {
        isLoved = false;
        totalLoves -= 1;
      });
    } else {
      await _loveReactService.addLoveReact(widget.recipeId, userId, userName);
      setState(() {
        isLoved = true;
        totalLoves += 1;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isLoading
            ? CircularProgressIndicator(color: Colors.red, strokeWidth: 2)
            : IconButton(
          onPressed: _toggleLoveReact,
          icon: Icon(
            isLoved ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
          ),
        ),
        Text('$totalLoves Loves', style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
