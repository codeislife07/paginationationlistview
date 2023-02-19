import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:http/http.dart' as http;
import 'package:paginationationlistview/DataModel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //declare pagination controller
  final PagingController<int,DataModel> pagingController=PagingController(firstPageKey: 1);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pagingController.addPageRequestListener((pageKey) {
      fetchData(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Infinite Pagination"),
      ),
      body: PagedListView<int,DataModel>(
        pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate<DataModel>(
          itemBuilder: (context,model,index)=>ListTile(
            title: Text(model.name),
            leading: Container(
              child: Image.network(model.imageUrl),
            ),
          )
        ),
      ),
    );
  }

  void fetchData(int pageKey)async {
    try{

      var response=await
      http.get(Uri.parse("https://api.punkapi.com/v2/beers?page=$pageKey&per_page=10"));
      var data=await dataModelFromJson(response.body);
      pagingController.appendPage(data, pageKey+1);
    }catch(error){
      pagingController.error=error;
    }
  }

}

//thank you for watching
