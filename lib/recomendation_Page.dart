// import 'dart:io';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:refresh_example/main.dart';
// import 'package:refresh_example/widget/refresh_widget.dart';

class Recomendation_Page extends StatefulWidget {
  static const String id="Recomendation_Page";

  late final List<int>? favourites;

  Recomendation_Page({this.favourites});

  @override
  _Recomendation_PageState createState() => _Recomendation_PageState();
}

class _Recomendation_PageState extends State<Recomendation_Page> {
  List _items = [];

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/database.json');
    final data = await json.decode(response);
    // String _bool = "t";

    setState(() {
      _items = data["data"];
    });
  }

  var list;
  var random;

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    random = Random();
    // refreshList();
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 0));

    setState(() {
      list = List.generate(15, (i) => "Item ${i}");
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pull to refresh"),
      ),
      body: RefreshIndicator(
        key: refreshKey,
        child: ListView.builder(
          itemCount: widget.favourites!.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(list[index]),
          ),
        ),
        onRefresh: refreshList,
      ),
    );
  }
}

