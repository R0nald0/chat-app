import 'package:flutter/material.dart';

class ContactInfoWidget extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final String description;
  final VoidCallback onTap;
  final IconData? icon;

  const ContactInfoWidget.withIcon({
    super.key,
    required this.onTap,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.icon,
  });

  const ContactInfoWidget({
    super.key,
    required this.onTap,
    required this.title,
    required this.description,
    this.imageUrl,
    this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: TextStyle(color: Colors.white)),
      subtitle: Text(description),
      trailing: icon != null ? Icon(icon) :null,
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: imageUrl == null ? Colors.amberAccent : null,
        backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      ),
      onTap:  () => onTap,
    );
  }
}
