import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/services.dart';

class Test_Page extends StatefulWidget {
  static const String id = "Test_Page";

  late List? favourites;

  Test_Page({this.favourites});

  @override
  _Test_PageState createState() => _Test_PageState();
}

class _Test_PageState extends State<Test_Page> {
  List _items = [];
  List _categories = [];
  int _selectedIndex = 0;
  List sortList = [];
  int son = 0;

  Future<void> readJson(int number) async {
    final String response = await rootBundle.loadString('assets/database.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["data"];

      _categories = data["categories"];

      for (int i = 0; i < number; i++) {
        sortList.add(i);
      }
      son = widget.favourites!.length<5 ? widget.favourites!.length : 5;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(
          () {
        readJson(widget.favourites != null ? widget.favourites!.length : 0);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "recomendatains",
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
        leading: Container(
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop({"recomendation": widget.favourites});
            },
          ),
        ),
        elevation: 0,
      ),
      body: widget.favourites == null || widget.favourites!.length == 0 ?
      Container(
        alignment: Alignment.center,
        child: Text("Not found favourites",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
      ) : SingleChildScrollView(
        child: Column(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 2));
                setState(() {
                  widget.favourites!.length - son < 5 ? son += widget.favourites!.length - son : son += 5;
                });
              },
              child: Container(
                height: MediaQuery.of(context).size.height-80,
                child: ListView.builder(
                  // physics: NeverScrollableScrollPhysics(),
                  // shrinkWrap: true,
                  itemCount: (son),
                  itemBuilder: (context, index) {
                    return Card(
                      margin:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        height: 240,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage(
                                _items[widget.favourites![index]]["image"]),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // #product_name
                                  // #product_type
                                  RichText(
                                    textAlign: TextAlign.start,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                          _items[widget.favourites![index]]
                                          ["name"] +
                                              "\n",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                            text: " \n",
                                            style: TextStyle(fontSize: 4)),
                                        TextSpan(
                                          text:
                                          _items[widget.favourites![index]]
                                          ["type"],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // #product_like
                                  MaterialButton(
                                    minWidth: 35,
                                    height: 35,
                                    child: Icon(Icons.favorite),
                                    onPressed: () {
                                      setState(() {
                                        widget.favourites!.removeAt(index);
                                        son--;
                                        print(widget.favourites);
                                      });
                                    },
                                    shape: CircleBorder(),
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              Text(
                                _items[index]["cost"].toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // child:
              // ListView.builder(
              //   itemCount: 10,
              //   itemBuilder: (context, index){
              //     return _productItem(cars[10 * dec + index]);
              //   },
              // ),
            ),
            // #products
          ],
        ),
      ),
    );
  }
}
