import 'package:flutter/material.dart';

class StatPage extends StatefulWidget {
  const StatPage({super.key, required this.stats});
  final List<String> stats;

  @override
  State<StatPage> createState() => StatPageState();
}
class StatPageState extends State<StatPage>{
  late int money;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Money and Stats")
      ),
      body: Column(children: [
        //tabbar with your stats and global stats
        Text("Money: ${money}"),
        Text("Biggest win: "),
        Text("Biggest bet: "),
      ],)
    );
  }
}



