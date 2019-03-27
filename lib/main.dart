import 'package:flutter/material.dart';
import 'package:hua_film/config/Config.dart';
import 'package:hua_film/dao/DaoResult.dart';
import 'package:hua_film/dao/TodayDao.dart';
import 'package:hua_film/mode/TodayFilmBean.dart';
import 'package:hua_film/widget/CardItem.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // 创建应用的根布局
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // 表示应用的主题
        primarySwatch:Colors.lightBlue ,
      ),
      home: MyHomePage(title: '今日推荐'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;



  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  DataResult dataResult;
  List<TodayFilmBean> mData = [];

  @override
  void initState() {
    getTodayFilm();
    super.initState();
  }

  void getTodayFilm() async {
    dataResult = await TodayDao.getTodayFilmListDao();
    setState(() {
      mData = dataResult.data;
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  _getWidget(int index) {
    //添加要展示的item内容
      return new Column(
        children: <Widget>[
          new Expanded(child: new CardItem(color: Colors.black12,child: _getChild(index)),flex: 8,),
          new Expanded(child: new Text(mData[index].movieName,
            textAlign: TextAlign.end,
            maxLines: 1,
          ),
              flex:1)
        ]);
  }

  _getChild(int i) {
    return new Padding(padding: new EdgeInsets.all(1.0),
        child: new Image(image: NetworkImage(mData[i].pic_url)));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),

      body: mData.length == 0
          ? new Center(child: new CircularProgressIndicator()):
      new GridView.builder(

          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, //每行2个
              mainAxisSpacing: 1.0, //主轴(竖直)方向间距
              crossAxisSpacing: 1.0, //纵轴(水平)方向间距
              childAspectRatio: 0.7 //纵轴缩放比例
          ),

          itemCount:mData.length,
          itemBuilder: (BuildContext context,int index) {
            return _getWidget(index);
          }), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}