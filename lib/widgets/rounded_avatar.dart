import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class RoundedAvatar extends StatelessWidget {
  const RoundedAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0), //or 15.0
      child: Container(
        height: 75.0,
        width: 75.0,
        color: Theme.of(context).primaryColor,
        child: Icon(Icons.volume_up, color: Colors.white, size: 50.0),
      ),
    );
  }
}
