import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onTap;
  final int index, selectedItem;

  DrawerTile(this.icon, this.text, this.onTap, this.index, this.selectedItem);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: index == selectedItem?
      Color.fromARGB(255, 234, 205, 125) : Color.fromARGB(255, 198, 54, 81)),
      title: Text(
        text,
        style:
            TextStyle(fontSize: 16.0, color: index == selectedItem?
            Color.fromARGB(255, 234, 205, 125) : Color.fromARGB(255, 198, 54, 81)),
      ),
      onTap: onTap,
      selected: index == selectedItem,
    );
  }
}
