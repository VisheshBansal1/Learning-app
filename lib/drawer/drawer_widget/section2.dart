import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Section2 extends StatelessWidget {
  const Section2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
                  leading: Icon(CupertinoIcons.book),
                  title: Text('Notes'),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                ),
                ListTile(
                  leading: Icon(Icons.alt_route_outlined),
                  title: Text('RoadMaps'),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                ),
                ListTile(
                  leading: Icon(Icons.quiz),
                  title: Text('Quizes'),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                ),
                ListTile(
                  leading: Icon(Icons.download),
                  title: Text('Lectures Downloaded'),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                ),
      ],
    );
  }
}