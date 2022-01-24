// import 'dart:convert';

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:flutter/services.dart';
// import 'package:m4_lesson5/models/product_model.dart';
import 'package:m4_lesson5/recomendation_Page.dart';
import 'package:m4_lesson5/test_Page.dart';

class Home_Page extends StatefulWidget {
  static const String id = "/Home_Page";

  @override
  _Home_PageState createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {

  int _selectedIndex = 0;
  List _items = [];
  List sortList = [];
  List<int> recomendation = [];
  List _categories = [];
  int son = 5;

  Color _color = Colors.black;

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/database.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["data"];
      _categories = data["categories"];
      for (int i = 0; i < _items.length; i++) {
        sortList.add(i);
      }
    });
  }

  Future<void> _goToNextScreen1(recomendation, BuildContext context) async {
    Map results = await Navigator.of(context)
        .push(new MaterialPageRoute<dynamic>(builder: (BuildContext context) {
      return Test_Page(
        favourites: recomendation,
      );
    }));
    setState(() {
      if (results != null && results.containsKey('recomendation')) {
        recomendation = results['recomendation'];
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      readJson();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Cars",
          style: TextStyle(color: _color, fontSize: 25),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _color == Colors.red
                    ? _color = Colors.black
                    : _color = Colors.red;
              });
            },
            icon: Icon(
              Icons.notifications_none,
              size: 32,
            ),
            color: _color,
          ),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              // color: Colors.red,
            ),
            child: MaterialButton(
                padding: EdgeInsets.all(0),
                shape: StadiumBorder(),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        _goToNextScreen1(recomendation, context);
                      },
                      icon: Icon(
                        Icons.shopping_bag,
                        size: 32,
                      ),
                      color: _color,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 9),
                      child: Text(
                        recomendation.length.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                onPressed: () {}),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: _items != null
            ? Column(
                children: [
                  // #categories
                  Container(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: (index != _categories.length - 1)
                              ? EdgeInsets.only(left: 5)
                              : EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: MaterialButton(
                            padding: EdgeInsets.zero,
                            elevation: 0,
                            color: _selectedIndex != index
                                ? Colors.white
                                : _color == Colors.red
                                    ? _color
                                    : _color.withOpacity(0.4),
                            shape: StadiumBorder(),
                            onPressed: () {
                              setState(() {
                                _selectedIndex = index;
                                sortList.clear();
                                List list = [];
                                for (int i = 0; i < _items.length; i++) {
                                  list.add(i);
                                }
                                for (int i = 0; i < _items.length; i++) {
                                  int num = Random().nextInt(list.length);
                                  if (index == 0 ||
                                      _items[list[num]]["category"] ==
                                          _categories[index]["categories"]) {
                                    sortList.add(list[num]);
                                  }
                                  list.removeAt(num);
                                }
                                sortList.length < 5
                                    ? son = sortList.length
                                    : son = son;
                              });
                            },
                            child: Text(
                              _categories[index]["categories"],
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  RefreshIndicator(
                    onRefresh: () async {
                      await Future.delayed(const Duration(seconds: 2));
                      setState(() {
                        sortList.length - son < 5
                            ? son += sortList.length - son
                            : son += 5;
                      });
                    },
                    child: Column(
                      children: [
                        // #_items
                        Container(
                          height: MediaQuery.of(context).size.height - 120,
                          child: ListView.builder(
                            itemCount: son,
                            itemBuilder: (context, i) {
                              return itemOf_items(i);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: Colors.blue,
                  strokeWidth: 3,
                ),
              ),
      ),
    );
  }

  Card itemOf_items(int index) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        height: 240,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(_items[sortList[index]]["image"]),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  left: 20, top: 15, right: 10, bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  colors: [
                    Colors.black.withOpacity(0.9),
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.1),
                  ],
                ),
              ),
              child: _color == Colors.red
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // #product_name
                        // #product_type
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _items[index]["name"] + " ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _items[index]["type"],
                              style: TextStyle(
                                color: _color,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 10,
                        ),

                        // #cost
                        Text(
                          _items[index]["cost"],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // #product_name
                            // #product_type
                            RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: _items[index]["name"] + "\n",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                      text: " \n",
                                      style: TextStyle(fontSize: 4)),
                                  TextSpan(
                                    text: _items[index]["type"],
                                    style: TextStyle(
                                        color: _color == Colors.red
                                            ? _color
                                            : Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),

                            Text(
                              _items[index]["cost"],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        // #product_like
                        MaterialButton(
                          minWidth: 35,
                          height: 35,
                          color: Colors.white,
                          child: recomendation.contains(sortList[index])
                              ? Icon(
                                  Icons.favorite,
                                )
                              : Icon(Icons.favorite_border),
                          onPressed: () {
                            setState(() {
                              recomendation.contains(sortList[index])
                                  ? recomendation.remove(sortList[index])
                                  : recomendation.add(sortList[index]);
                            });
                          },
                          shape: CircleBorder(),
                        ),
                      ],
                    ),
            ),
            _color == Colors.red
                ? Container(
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.only(left: 5, bottom: 10),
                    child: MaterialButton(
                      minWidth: 35,
                      height: 35,
                      color: Colors.red,
                      child: recomendation.contains(sortList[index])
                          ? Icon(
                              Icons.favorite,
                              color: Colors.white,
                            )
                          : Icon(
                              Icons.favorite_border,
                              color: Colors.white,
                            ),
                      onPressed: () {
                        setState(() {
                          recomendation.contains(sortList[index])
                              ? recomendation.remove(sortList[index])
                              : recomendation.add(sortList[index]);
                        });
                      },
                      shape: CircleBorder(),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
