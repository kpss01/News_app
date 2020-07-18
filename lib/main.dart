import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:intl/intl.dart';
import 'package:news_app/HttpResponse.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'News app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{

  TabController tabController;



  @override
  void initState() {
    // TODO: implement initState
    tabController=TabController(length: 10,vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 10,
      child: Scaffold(
        appBar: AppBar(

          title: Text(widget.title),
          bottom: TabBar(
            isScrollable: true,
            controller: tabController,
            tabs: [
              Container(padding: EdgeInsets.all(8),child: Text('BuzzFeed',style: TextStyle(fontSize: 15),)),
              Container(padding: EdgeInsets.all(8),child: Text("CNN",style: TextStyle(fontSize: 15))),
              Container(padding: EdgeInsets.all(8),child: Text('ESPN',style: TextStyle(fontSize: 15))),
              Container(padding: EdgeInsets.all(8),child: Text('Fortune',style: TextStyle(fontSize: 15))),
              Container(padding: EdgeInsets.all(8),child: Text('Bloomberg',style: TextStyle(fontSize: 15))),
              Container(padding: EdgeInsets.all(8),child: Text('BBC',style: TextStyle(fontSize: 15))),
              Container(padding: EdgeInsets.all(8),child: Text('ABC News',style: TextStyle(fontSize: 15))),
              Container(padding: EdgeInsets.all(8),child: Text('Al Jazeera',style: TextStyle(fontSize: 15))),
              Container(padding: EdgeInsets.all(8),child: Text('Axios',style: TextStyle(fontSize: 15))),
              Container(padding: EdgeInsets.all(8),child: Text('Breitbart News',style: TextStyle(fontSize: 15)))
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            HomeData('BuzzFeed',0),
            HomeData('CNN',1),
            HomeData('ESPN',2),
            HomeData('Fortune',3),
            HomeData('Bloomberg',4),
            HomeData('BBC-News',5),
            HomeData('abc-news',6),
            HomeData('al-jazeera-english',7),
            HomeData('Axios',8),
            HomeData('breitbart-news',9),
          ],
        ),// This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

class HomeData extends StatefulWidget {
  
  final String title;
  final int index;
  
  HomeData(this.title,this.index);



  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeDataState();
  }
  
}


class HomeDataState extends State<HomeData> with AutomaticKeepAliveClientMixin{
  

  double screenW=0.0,screenH=0.0;
  
  List<dynamic> list=List<dynamic>();

  List<String> urlToimage=[
    'https://www.tubefilter.com/wp-content/uploads/2018/08/buzzfeed-news.jpg',
    'https://cdn.cnn.com/cnn/.e1mo/img/4.0/logos/CNN_logo_400x400.png',
    'https://cdn.tvpassport.com/image/station/240x135/espnews.png',
    'https://content.fortune.com/wp-content/uploads/2016/10/fortune-logo-2016-840x485.jpg',
    'https://assets.bwbx.io/s3/multimedia/public/app/images/bloomberg_default-a4f15fa7ee.jpg',
    'https://m.files.bbci.co.uk/modules/bbc-morph-news-waf-page-meta/2.5.2/bbc_news_logo.png',
    'https://pmcdeadline2.files.wordpress.com/2019/09/abc-news-logo-featured.jpg',
    'https://upload.wikimedia.org/wikipedia/en/thumb/f/f2/Aljazeera_eng.svg/1200px-Aljazeera_eng.svg.png',
    'https://assets.axios.com/203e9f932cc97836ac2ff4c6c982676c.png',
    'https://pyxis.nymag.com/v1/imgs/7d3/56e/445814bb2c813f972b2406e18d6a7908b6-15-breitbart-logo.2x.h473.w710.jpg'
  ];

  bool showList=false;
  String date='',apiDate='';
  DateTime curr;
  @override
  void initState() {
    // TODO: implement initState
    curr=DateTime.now();
    date=DateFormat('dd MMM yy').format(DateTime.now());
    apiDate=DateFormat('yyyy-MM-dd').format(DateTime.now());
    getData();
    super.initState();

  }
  
  @override
  Widget build(BuildContext context) {
    screenW=MediaQuery.of(context).size.width;
    screenH=MediaQuery.of(context).size.height;
    // TODO: implement build
    return Container(
      width: screenW,
      height: double.infinity,
      child:showList ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 5,),
          Flexible(
            child: ListView.builder(
              itemCount: list.length,
                itemBuilder: (c,i){
                if(list[i]['urlToImage']==null){
                  list[i]['urlToImage']=urlToimage[widget.index];
                }

                String d=list[i]['publishedAt'].toString().split('T').elementAt(0);
                List<String> date=d.split('-');

                if(list[i]['title']==null || list[i]['description']==null){
                  return Container();
                }

                return Container(
                  width: screenW,
                  child: Card(
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: (){
                        Navigator.push(context, CupertinoPageRoute(
                            builder: (c)=>WebviewScaffold(
                              clearCache: true,
                                clearCookies: true,
                                url: list[i]['url'],
                                appBar: AppBar(
                                  title: Text(widget.title,style: TextStyle(color: Colors.white),),
                                )
                            )
                        ));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                            child: Image.network(list[i]['urlToImage'],width: screenW,height: screenH*0.2,fit: BoxFit.cover,),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(margin: EdgeInsets.only(left: 5,right: 5),child: Text(list[i]['title'],style: TextStyle(fontSize: screenW*0.05,color: Colors.black87,fontWeight: FontWeight.w600),maxLines: 2,overflow: TextOverflow.ellipsis,)),
                          SizedBox(height: 10,),
                          Container(margin: EdgeInsets.only(right: 5,left: 5),width: double.infinity,child: Text('Publish At: ${date[2]}-${date[1]}-${date[0]}',style: TextStyle(color: Colors.black54,fontSize: screenW*0.03),),),
                          SizedBox(height: 10,),
                          Container(margin: EdgeInsets.only(left: 5,right: 5),child: Text(list[i]['description'],style: TextStyle(fontSize: screenW*0.04,color: Colors.black54,fontWeight: FontWeight.w600),maxLines: 2,overflow: TextOverflow.ellipsis,)),
                          SizedBox(height: 10,),
                        ],
                      ),
                    ),
                  ),
                );
                }),
          )
        ],
      ):Center(
        child: CircularProgressIndicator(),
      ),
    );
    
  }

  void getData() async{

    setState(() {
      showList=false;
    });

    var response =await HttpResponse.getResponse(service: 'sources=${widget.title}&from=$apiDate&to=$apiDate');
    print("${widget.title}==$response");

    Map<String,dynamic> map=json.decode(response.toString());
    list=map['articles'] as List;
    setState(() {
      showList=true;
    });
  }

  @override
  bool get wantKeepAlive {
    return true;
  }
}


