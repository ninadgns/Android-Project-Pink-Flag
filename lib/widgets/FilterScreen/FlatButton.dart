import 'package:flutter/material.dart';

class FlatButton extends StatefulWidget {
  FlatButton({
    super.key,
    required this.item,
    this.isSelected = false,
  });
  String item;
  bool isSelected;

  @override
  State<FlatButton> createState() => _FlatButtonState();
}

class _FlatButtonState extends State<FlatButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            widget.isSelected
                ? Theme.of(context).colorScheme.error
                : Colors.white,
          ),
          side: WidgetStateProperty.all(
            BorderSide(
              color: widget.isSelected ? Colors.transparent : Colors.grey,
              width: 0.5,
            ),
          )),
      onPressed: () {
        setState(() {
          widget.isSelected = !widget.isSelected;
        });
      },
      child: Text(widget.item, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
