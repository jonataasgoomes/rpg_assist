import 'package:flutter/material.dart';

class Glossary extends StatefulWidget {
  @override
  _GlossaryState createState() => _GlossaryState();
}

class _GlossaryState extends State<Glossary> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildBodyBack(),
        Center(
          child: Text("Glossary"),
        )
      ],
    );
  }
}
