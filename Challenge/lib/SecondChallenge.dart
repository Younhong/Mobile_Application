import 'package:flutter/material.dart';

void main() {
  runApp(TabBarDemo());
}

class TabBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.computer)),
                Tab(icon: Icon(Icons.tablet)),
                Tab(icon: Icon(Icons.smartphone)),
                Tab(icon: Icon(Icons.tv)),
              ],
            ),
            title: Text('Tabs Demo'),
          ),
          body: TabBarView(
            children: [
              Image.network('http://www.handong.edu/site/handong/res/img/logo.png'),
              Image.network('http://www.handong.edu/site/handong/res/img/util_tail01.png'),
              Image.network('http://www.handong.edu/site/handong/res/img/util_tail06.png'),
              Image.network('http://www.handong.edu/site/handong/res/img/icon_s.png'),
            ],
          ),
        ),
      ),
    );
  }
}