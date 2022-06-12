import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final bool isSelected;
  final Function() onRemove;
  final Function() onSelect;

  const ActionButton({required this.isSelected, required this.onRemove, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    if (isSelected) {
      return RaisedButton(
        color: Colors.white,
        elevation: 0,
        child: const Text(
          'Remove',
          style: TextStyle(color: Colors.redAccent),
        ),
        onPressed: onRemove,
      );
    }

    return RaisedButton(
      color: Colors.white,
      elevation: 0,
      child: const Text(
        'Select',
        style: TextStyle(color: Colors.blueAccent),
      ),
      onPressed: onSelect,
    );
  }
}
