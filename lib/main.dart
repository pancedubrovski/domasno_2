import 'package:camera/camera.dart';
import 'package:domasno2/userInfo.dart';
import 'package:flutter/material.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Notification.dart';
import 'camera.dart';
import 'home.dart';
import 'map.dart';




List<CameraDescription> cameras;
String userName;
String phone;
String email;
bool haveInfo;


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
 // cameras = await availableCameras();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  // preferences.remove('userName');
  // preferences.remove('phone');
   //GoogleMap.init('API_KEY');

  // preferences.remove('email');
  if (preferences.getString('userName')!=null){
    userName = preferences.getString('userName');
    phone = preferences.getString('phone');
    email = preferences.get('email');
    haveInfo = true;
  }
  else {
    haveInfo = false;
  }
  runApp(new MyApp());
}
class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(

          primarySwatch: Colors.blue,

          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home:MyTabbedPage(cameras: cameras,userName: userName,phone: phone,email: email,haveInfo: haveInfo)
    );
  }
}

class MyTabbedPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  String userName;
  String phone;
  String email;
  bool haveInfo;

  MyTabbedPage(
      {Key key,this.cameras,this.userName,this.phone,this.email,this.haveInfo})
      : super(key: key);

  @override
  _MyTabbedPageState createState() => _MyTabbedPageState();
}

class _MyTabbedPageState extends State<MyTabbedPage> with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    //   Tab(text: 'Accelometre'),
    Tab(text: 'Map'),
    Tab(text: 'Notification'),
    Tab(text: 'Camera'),
    Tab(text: 'User Info'),
    Tab(text: 'Home '),

  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: myTabs,
        ),
      ),
      body: TabBarView(
          controller: _tabController,
          children: <Widget>[

            MapClass(),
            LocalNotification(),
            Home(),
            Camera(cameras: widget.cameras),
            (widget.haveInfo ? UserInfo(userName: widget.userName, phone: widget.phone,email: widget.email) : UserInput()),


            //   Accelerometer(),
            //    (widget.haveInfo ? UserInfo(userName: widget.userName, phone: widget.phone,email: widget.email) : UserInput()),
          ]
      ),
    );
  }
}


