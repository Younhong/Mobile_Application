// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'model/products_repository.dart';
import 'model/product.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';

List<Product> _saved = <Product>[];

class HomePage extends StatelessWidget{
  // TODO: Add a variable for Category (104)
  List<Card> _buildGridCards(BuildContext context) {

    List<Product> products = ProductsRepository.loadProducts(Category.all);
    if (products == null || products.isEmpty) {
      return const <Card>[];
    }

    return products.map((product) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: product,
            child: Image.asset(
              product.assetName,
              fit: BoxFit.contain,
            ),
          ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 0.0),
                child:
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 30),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.location_on,
                                size: 13.5,
                                color: Colors.blue),
                          ],
                        ),
                      ),],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left:2, top:2, right:2),
                          child: Row(
                              children: <Widget>[
                                for (int i = 0; i < product.starNum; i++)
                                  Icon(Icons.star,
                                      size: 11,
                                      color:Colors.yellow),
                              ]
                          ),),
                        Container(
                          width: 140,
                          padding: const EdgeInsets.all(2),
                          child: Text(
                            product.name,
                            style: TextStyle(
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold),
                            softWrap: true,
                          ),),
                        Container(
                          padding: const EdgeInsets.all(2),
                          child: Row(
                              children: <Widget>[
                                Container(
                                  width: 140,
                                  child: Text(
                                    product.address,
                                    style: TextStyle(fontSize: 9.0),
                                    softWrap: true,
                                  ),)
                              ]
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(left: 55.0, top: 10.0),
                            height: 15,
                            padding: const EdgeInsets.all(2),
                            child: MaterialButton(
                                child: Text('More',
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.blue,)),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        DetailPage(product: products[product.id],)),
                                  );
                                }
                            )
                        ),
                      ],
                    ),
                  ],
                ),
                ),
              ),
            ],
          ),
        );
      }
    ).toList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              semanticLabel: 'search',
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => SearchPage()));
            },
          ),
          IconButton(
            icon: Icon(
              Icons.language,
              semanticLabel: 'language',
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => WebPage()));
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Container(
                alignment: Alignment.bottomLeft,
                child: Text("Pages",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20),
                ),
              ),
            ),
            ListTile(
              title: Text("Home"),
              leading: Icon(Icons.home,
                  color: Colors.blue),
                onTap: () {
                  Navigator.pushNamed(context, '/');
                }
            ),
            ListTile(
                title: Text("Search"),
                leading: Icon(Icons.search,
                    color: Colors.blue),
                onTap: () {
                  Navigator.pushNamed(context, '/search');
                }
            ),
            ListTile(
              title: Text("Favorite Hotel"),
              leading: Icon(Icons.location_city,
                  color: Colors.blue),
                onTap: () {
                  Navigator.pushNamed(context, '/fav');
                }
            ),
            ListTile(
                title: Text("Website"),
                leading: Icon(Icons.language,
                    color: Colors.blue),
                onTap: () {
                  Navigator.pushNamed(context, '/web');
                }
            ),
            ListTile(
              title: Text("My Page"),
              leading: Icon(Icons.person,
                  color: Colors.blue),
                onTap: () {
                  Navigator.pushNamed(context, '/my');
                }
            ),
          ],
        ),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return GridView.count(
            crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
            padding: EdgeInsets.all(16.0),
            childAspectRatio: 8.0 / 9.0,
            children: _buildGridCards(context),
          );
        },
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}

class DetailPage extends StatefulWidget {
  final Product product;
  DetailPage({Key key, @required this.product}) : super(key: key);

  DetailState createState() => DetailState(product);
}

class DetailState  extends State<DetailPage>{
  final Product product;
  final title = 'Detail';
  DetailState(this.product);

  void _toggleFavorite() {
    setState(() {
      if (_saved.contains(product)) {
        _saved.remove(product);
      } else {
        _saved.add(product);
        }
      }
    );
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Hero(
        tag: product,
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: ListView(
            children: [
              Stack(children: <Widget>[
                Image.asset(
                  product.assetName,
                  width: 600,
                  height: 240,
                  fit: BoxFit.cover,
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: (_saved.contains(product)
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border)),
                    color: Colors.red,
                    onPressed: _toggleFavorite,
                    )
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                  children: <Widget>[
                                    for (int i = 0; i < product.starNum; i++)
                                      Icon(Icons.star,
                                          size: 11,
                                          color:Colors.yellow),
                                  ])
                          ),
                          Container(
                            padding: const EdgeInsets.all(3),
                            child: Text(
                              product.name,
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  child: Icon(Icons.location_on,
                                    size: 14,
                                    color: Colors.blue,),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Text(
                                    product.address,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 14,
                                    ),
                                  ),),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  child: Icon(Icons.phone,
                                    size: 14,
                                    color: Colors.blue,),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Text(
                                    product.phone,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1.0, color: Colors.black),
              Container(
                padding: const EdgeInsets.all(32.0),
                child: Text(product.text,
                  softWrap: true,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyItem {
  MyItem({this.isExpanded: false, this.header, this.body, this.extendedValue});

  bool isExpanded;
  final String header;
  final String body;
  final String extendedValue;
}

class MySecondItem {
  MySecondItem({this.isExpanded: false, this.header, this.body});

  bool isExpanded;
  final String header;
  final String body;
}

class SearchPage extends StatefulWidget {
  SearchScreen createState() => SearchScreen();
}

class SearchScreen extends State<SearchPage> {
  List<MyItem> _item1 = <MyItem> [
    MyItem(header: "Location", body: "Body"),
  ];
  List<MySecondItem> _item2 = <MySecondItem> [
    MySecondItem(header: "Class", body: "Body"),
  ];
  // DatePicker
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  DateTime _date2 = DateTime.now();
  TimeOfDay _time2 = TimeOfDay.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2016),
        lastDate: DateTime(2110));
    if (picked != null && picked != _date)
      setState(() {
        _date = picked;
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null && picked != _time)
      setState(() {
        _time = picked;
      });
  }

  Future<Null> _selectDate2(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date2,
        firstDate: DateTime(2016),
        lastDate: DateTime(2110));
    if (picked != null)
      setState(() {
        _date2 = picked;
      });
  }
  Future<Null> _selectTime2(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time2,
    );
    if (picked != null && picked != _time2)
      setState(() {
        _time2 = picked;
      });
  }

  // radio button
  String _rValue1 = '';

  // checkbox button
  bool _cValue1 = false;
  bool _cValue2 = false;
  bool _cValue3 = false;
  bool _cValue4 = false;
  bool _cValue5 = false;
  void _value1Changed(bool value) => setState(() => _cValue1 = value);
  void _value2Changed(bool value) => setState(() => _cValue2 = value);
  void _value3Changed(bool value) => setState(() => _cValue3 = value);
  void _value4Changed(bool value) => setState(() => _cValue4 = value);
  void _value5Changed(bool value) => setState(() => _cValue5 = value);

  // slider value
  double _sValue = 0.0;
  void _setValue(double value) => setState(() => _sValue = value);

  Widget build(BuildContext context) {
    final title = 'Search';

    return MaterialApp(
        title: title,
        home: Scaffold(
            appBar: AppBar(
              title: Text(title),
              leading: IconButton(icon: Icon(
                  Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: ListView(
              children: <Widget> [
                ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      _item1[index].isExpanded = !_item1[index].isExpanded;
                    });
                  },
                  children: _item1.map((MyItem item) {
                    return ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            leading: Text('Location',),
                            title: Text('Select Location',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12),),
                          );
                      },
                      isExpanded: item.isExpanded,
                      body: Column(
                        children: <Widget>[
                          Container(
                            height: 50,
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.only(left: 140),
                                  child: Radio(
                                    value: 'Seoul',
                                    groupValue: _rValue1,
                                    activeColor: Colors.blue,
                                    onChanged: (value) =>
                                        setState(() => _rValue1 = value),),
                                ),
                                Text('Seoul',
                                    style: TextStyle(
                                      fontSize: 13,)),
                              ],
                            ),
                          ),
                          Container(
                            height: 50,
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.only(left: 140),
                                  child: Radio(value: 'Busan',
                                    groupValue: _rValue1,
                                    activeColor: Colors.blue,
                                    onChanged: (value) =>
                                        setState(() => _rValue1 = value),),
                                ),
                                Text('Busan',
                                    style: TextStyle(
                                        fontSize: 13)),
                              ],
                            ),
                          ),
                          Container(
                            height: 50,
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.only(left: 140),
                                  child: Radio(
                                    value: 'Daegu',
                                    groupValue: _rValue1,
                                    activeColor: Colors.blue,
                                    onChanged: (value) =>
                                        setState(() => _rValue1 = value),),
                                ),
                                Text('Daegu',
                                    style: TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  ).toList(),
                ),
                ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      _item2[index].isExpanded = !_item2[index].isExpanded;
                    });
                  },
                  children: _item2.map((MySecondItem item) {
                    return ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          leading: Text('Class'),
                          title: Text('Select Hotel Classes',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),),
                        );
                      },
                      isExpanded: item.isExpanded,
                      body: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(left: 150),
                            child: Row(
                              children: <Widget>[
                                Checkbox(
                                  value: _cValue1,
                                  activeColor: Colors.blue,
                                  onChanged: _value1Changed,),
                                Row(
                                  children: <Widget>[
                                    for (int i=0; i<1; i++)
                                      Icon(Icons.star,
                                          color: Colors.yellow),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 150),
                            child: Row(
                              children: <Widget>[
                                Checkbox(
                                  value: _cValue2,
                                  activeColor: Colors.blue,
                                  onChanged: _value2Changed,),
                                Row(
                                  children: <Widget>[
                                    for (int i=0; i<2; i++)
                                      Icon(Icons.star,
                                          color: Colors.yellow),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 150),
                            child: Row(
                              children: <Widget>[
                                Checkbox(
                                  value: _cValue3,
                                  activeColor: Colors.blue,
                                  onChanged: _value3Changed,),
                                Row(
                                  children: <Widget>[
                                    for (int i=0; i<3; i++)
                                      Icon(Icons.star,
                                          color: Colors.yellow),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 150),
                            child: Row(
                              children: <Widget>[
                                Checkbox(
                                  value: _cValue4,
                                  activeColor: Colors.blue,
                                  onChanged: _value4Changed,),
                                Row(
                                  children: <Widget>[
                                    for (int i=0; i<4; i++)
                                      Icon(Icons.star,
                                          color: Colors.yellow),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 150),
                            child: Row(
                              children: <Widget>[
                                Checkbox(
                                  value: _cValue5,
                                  activeColor: Colors.blue,
                                  onChanged: _value5Changed,),
                                Row(
                                  children: <Widget>[
                                    for (int i=0; i<5; i++)
                                      Icon(Icons.star,
                                          color: Colors.yellow),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  ).toList(),
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Text('Date'),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 30, right: 10, top:4, bottom:4),
                  child: Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 15),
                              width: 120,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    child:Icon(Icons.calendar_today),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    child: Row(
                                      children: <Widget>[
                                        Text('Check In',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),),
                            Container(
                              width: 80,
                              child: Text(
                                  DateFormat("yyyy-M-dd (EEE)").format(_date),
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.grey)),
                            ),
                            Container(
                              child: Text(
                                  _time.format(context),
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.grey)),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 60),
                              child: FlatButton(
                                color: Colors.blue,
                                onPressed: () => _selectDate(context),
                                child: Text('Select Date',
                                  style: TextStyle(
                                      fontSize: 10),),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 60),
                                child: FlatButton(
                                  color: Colors.blue,
                                  onPressed: () => _selectTime(context),
                                  child: Text('Select Time',
                                    style: TextStyle(
                                        fontSize: 10),),
                                ),
                            ),
                          ],
                        ),
                      ]
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 30, right: 10, top:4, bottom: 20),
                  child: Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 15),
                              width: 120,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    child:Icon(Icons.calendar_today),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    child: Row(
                                      children: <Widget>[
                                        Text('Check Out',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),),
                            Container(
                              width: 80,
                              child: Text(
                                  DateFormat("yyyy-M-dd (EEE)").format(_date2),
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.grey)),
                            ),
                            Container(
                              child: Text(
                                  _time2.format(context),
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.grey)),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 60),
                              child: FlatButton(
                                color: Colors.blue,
                                onPressed: () => _selectDate2(context),
                                child: Text(
                                  'Select Date',
                                  style: TextStyle(
                                      fontSize: 10),),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 60),
                              child: FlatButton(
                                color: Colors.blue,
                                onPressed: () => _selectTime2(context),
                                child: Text(
                                  'Select Time',
                                  style: TextStyle(
                                      fontSize: 10),),
                              ),
                            ),
                          ],
                        ),
                      ]
                  ),
                ),
                Divider(height: 1.0, color: Colors.black),
                Container(
                    padding: const EdgeInsets.all(4),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(left: 10, top:5, bottom: 3),
                        child: Text('Fee'),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 340, top: 5, bottom: 3),
                        child: Text('${(_sValue*150).round()}',),),
                    ],
                  )
                ),
                Column(
                    children: <Widget>[
                      Container(
                          padding: const EdgeInsets.only(left:8, right: 8, bottom: 8),
                        child: Slider(
                            value: _sValue,
                            onChanged: _setValue)),
                    ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 120, right:120),
                  child: FlatButton(
                    color: Colors.blue,
                    child: Text('Search'),
                    onPressed: () {
                      return showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Container(
                              child: Text('Please Check Your Choice',),
                            ),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    child: Row(
                                        children: <Widget>[
                                          Container(
                                            padding: const EdgeInsets.all(2),
                                            child: Icon(Icons.location_on,
                                              color: Colors.blue,),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(2),
                                            child: Text('$_rValue1'),
                                          ),
                                        ]
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    child: Row(
                                        children: <Widget>[
                                          Container(
                                            padding: const EdgeInsets.all(2),
                                            child: Icon(Icons.star,
                                              color: Colors.yellow,),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(2),
                                            child: Row(
                                              children: <Widget> [
                                                if (_cValue1)
                                                  Row(
                                                    children: <Widget>[
                                                      Icon(Icons.star,
                                                          color: Colors.yellow,
                                                          size: 13),
                                                      if (_cValue2 || _cValue3 || _cValue4 || _cValue5)
                                                        Row(
                                                          children: <Widget>[
                                                            Text('/'),
                                                          ],
                                                        ),
                                                    ],
                                                  ),
                                                if (_cValue2)
                                                  Row(
                                                    children: <Widget>[
                                                      for (int i=0; i<2; i++)
                                                        Icon(Icons.star,
                                                            color: Colors.yellow,
                                                            size: 13),
                                                      if (_cValue3 || _cValue4 || _cValue5)
                                                        Row(
                                                          children: <Widget>[
                                                            Text('/'),
                                                          ],
                                                        ),
                                                    ],
                                                  ),
                                                if (_cValue3)
                                                  Row(
                                                    children: <Widget>[
                                                      for (int i=0; i<3; i++)
                                                        Icon(Icons.star,
                                                            color: Colors.yellow,
                                                            size: 13),
                                                      if (_cValue4 || _cValue5)
                                                        Row(
                                                          children: <Widget>[
                                                            Text('/'),
                                                          ],
                                                        ),
                                                    ],
                                                  ),
                                                if (_cValue4)
                                                  Row(
                                                    children: <Widget>[
                                                      for (int i=0; i<4; i++)
                                                        Icon(Icons.star,
                                                            color: Colors.yellow,
                                                            size: 13),
                                                      if (_cValue5)
                                                        Row(
                                                          children: <Widget>[
                                                            Text('/'),
                                                          ],
                                                        ),
                                                    ],
                                                  ),
                                                if (_cValue5)
                                                  Row(
                                                    children: <Widget>[
                                                      for (int i=0; i<5; i++)
                                                        Icon(Icons.star,
                                                            color: Colors.yellow,
                                                            size: 13),
                                                    ],
                                                  ),
                                              ]
                                            )
                                          )
                                        ]
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    child: Row(
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Container(
                                                padding: const EdgeInsets.all(2),
                                                child: Icon(Icons.date_range,
                                                  color: Colors.blue,),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Container(
                                                child: Text('In',
                                                    style: TextStyle(
                                                        fontSize: 9)),
                                              ),
                                              Container(
                                                child: Text('Out',
                                                    style: TextStyle(
                                                        fontSize: 9)),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Container(
                                                padding: const EdgeInsets.only(left: 8),
                                                child: Text(
                                                    DateFormat("yyyy-M-dd (EEE)").format(_date),
                                                    style: TextStyle(
                                                        fontSize: 9)),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(left: 8),
                                                child: Text(
                                                    DateFormat("yyyy-M-dd (EEE)").format(_date2),
                                                    style: TextStyle(
                                                        fontSize: 9)),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Container(
                                                padding: const EdgeInsets.only(left: 8),
                                                child: Text(
                                                    _time.format(context),
                                                    style: TextStyle(
                                                        fontSize: 9)),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(left: 8),
                                                child: Text(
                                                    _time2.format(context),
                                                    style: TextStyle(
                                                        fontSize: 9)),
                                              ),
                                            ],
                                          )
                                        ]
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    child: Row(
                                        children: <Widget>[
                                          Container(
                                            padding: const EdgeInsets.all(2),
                                            child: Icon(Icons.attach_money,
                                              color: Colors.blue,),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(2),
                                            child: Text('${(_sValue*150).round()}'),
                                          ),
                                        ]
                                      ),
                                    ),
                                  ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            )
        )
    );
  }
}

class FavoritePage extends StatefulWidget {
  FavoriteHotelState createState() => FavoriteHotelState();
}

class FavoriteHotelState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    final title = 'Favorite Hotels';
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: IconButton(icon: Icon(
              Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: ListView.builder(
          itemCount: _saved.length,
          itemBuilder: (context, index) {
            final item = _saved[index];
            return Dismissible(
              // Each Dismissible must contain a Key. Keys allow Flutter to
              // uniquely identify widgets.
              key: Key(item.name),
              // Provide a function that tells the app
              // what to do after an item has been swiped away.
              onDismissed: (direction) {
                // Remove the item from the data source.
                setState(() {
                  _saved.removeAt(index);
                });
              },
              // Show a red background as the item is swiped away.
              background: Container(
                  color: Colors.red),
              child: ListTile(
                  title: Text(item.name)),
            );
          },
        ),
      ),
    );
  }
}

class WebPage extends StatefulWidget {
  WebState createState() => WebState();
}

class WebState extends State<WebPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: WebView(
        initialUrl: 'https://handong.edu',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

class MyPage extends StatelessWidget {
  Widget build(BuildContext context) {
    final title = 'My Page';
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: IconButton(icon: Icon(
              Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
          body: Column(
              children: <Widget>[
                if (_saved.length > 0)
                  CarouselSlider(
                    height: 300.0,
                    autoPlay: true,
                    initialPage: 0,
                    autoPlayInterval: Duration(seconds:2),
                    enlargeCenterPage: true,
                    items: [for (int i=0; i<_saved.length; i++)i,].map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return
                            Stack(
                                children: <Widget>[
                                  MaterialButton(
                                    child: Image.asset(
                                      _saved[i].assetName,
                                      width: 290,
                                      height: 280,
                                      fit: BoxFit.cover,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(_createRoute((i)));
                                      //Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(product: _saved[i-1])),);
                                    },
                                  ),
                                  Container(
                                    alignment: Alignment.topCenter,
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Text(
                                        _saved[i].name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.orange,)
                                    ),
                                  ),
                                ]
                            );
                        },
                      );
                    }
                  ).toList(),
                )
            ]
          ),
      ),
    );
  }
}

Route _createRoute(int a) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => DetailPage(product: _saved[a]),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(
          CurveTween(
              curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}