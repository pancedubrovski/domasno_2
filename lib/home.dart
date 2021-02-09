import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Articles {

  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  String publishedAt;
  String content;
  Articles({this.author,this.title,this.description,this.url,this.urlToImage,this.publishedAt,this.content});
  factory Articles.formJson(Map<String,dynamic> element) {
    return Articles(
      author: element["author"],
      title: element["title"],
      description: element["description"],
      url: element["url"],
      urlToImage: element["urlToImage"],
      publishedAt: element["publishedAt"],
      content: element["content"],
    );
  }
}


class News {


  Future<List<Articles>> fetchNews() async {
    final response = await http.get(
        'http://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=78dbd1dcfa6a472789b14cc54c605df7');
    var jsonData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return (jsonData['articles'] as List)?.map((e)=>new Articles.formJson(e))?.toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}


class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}
class HomeState extends State<Home> {
  List<Articles> articles = List<Articles>();

  @override
  void initState() {
    super.initState();


  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build




    return Container(

      child: Center(
        child: FutureBuilder<List<Articles>> (
            future: News().fetchNews(),
            builder: (BuildContext context, AsyncSnapshot<List<Articles>> snapshot) {
              if (snapshot.hasData) {
                List<Articles> data = snapshot.data;
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context,index){
                      return new GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => ArticlePage(articles: data[index])
                          ));
                        },

                        child: new Container(
                          child: new Card(
                            elevation: 3.0,
                            child:  new Row(
                              children: <Widget>[
                                new Container(
                                  height: 150.0,
                                  width: 170.0,
                                  child: new Image.network(
                                      data[index].urlToImage,
                                      fit:BoxFit.cover
                                  ),
                                ),
                                new Expanded(
                                  child: new Container(
                                    margin: new EdgeInsets.all(10.0),
                                    child:
                                    new Text(
                                      data[index].title,
                                      style: TextStyle(color: Colors.black,fontSize: 18.0),

                                    ),


                                  ),
                                ),


                              ],
                            ),
                          ),
                        ),
                      );
                    }
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            }

        ),
      ),
    );
  }

}

class ArticlePage extends StatelessWidget {
  Articles articles;
  ArticlePage({Key key,this.articles}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(articles.title),
        ),
        body: new Container(
          margin: new EdgeInsets.all(10.0),
          child: new Material(
            elevation: 4.0,
            borderRadius: new BorderRadius.circular(6.0),
            child: new ListView(
              children: <Widget>[
                new Hero(
                  tag: articles.title,
                  child: Image.network(articles.urlToImage),
                ),
                _getBody(),
              ],
            ),
          ),
        )
    );
  }
  Widget _getBody() {
    return new Container(
      margin: new EdgeInsets.all(15.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(articles.title,style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold)),
          Text(articles.publishedAt,style: TextStyle(fontSize:12.0,color: Colors.grey),
          ),
          Container(
              margin: new EdgeInsets.only(top: 20),
              child: Text(articles.content)
          ),
          Container(
              margin: new EdgeInsets.only(top: 20),
              child: Text('Author: '+articles.author)
          )
        ],
      ),
    );
  }
}