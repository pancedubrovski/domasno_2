
import 'package:flutter/material.dart';
import 'package:domasno2/NotificationPlugin.dart';
import 'package:sensors/sensors.dart';

class LocalNotification extends StatefulWidget {
  @override
  _LocalNotificationState createState() =>  _LocalNotificationState();
// TODO: implement createState


}

class _LocalNotificationState extends State<LocalNotification> {

  @override
  void initState() {
    super.initState();
    notificationPlugin.setListenerForLowerVersions(onNotificationInLowerVersions);
    notificationPlugin.setOnNotificationClick(onNotificationClick);
  }
  AccelerometerEvent event;
  double x;
  double y;
  double z;



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        x = event.x;
        y = event.y;
        z = event.z;
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Local Notification'),
      ),
      body: Center(
          child: Column(
         children: <Widget> [
           FlatButton(
             onPressed: () async {
               await notificationPlugin.showNotification();
             } ,
             child: Text('Send Notification'),
           ),

           Text('Accelerometer',style: TextStyle(
             fontSize: 20.0,
           ),),
           Text('x: ${(x ?? 0).toStringAsFixed(3)}',style: TextStyle(
             fontSize: 20.0,
           ),),
           Text('y: ${(y ?? 0).toStringAsFixed(3)}',style: TextStyle(fontSize:20.0)),
           Text('z: ${(z ?? 0).toStringAsFixed(3)}',style: TextStyle(fontSize:20.0)),
         ]



        )
      ),
    );
  }

  onNotificationInLowerVersions(ReceivedNotification receivedNotification) {
    print('Notification Received ${receivedNotification.id}');
  }
  onNotificationClick(String payload) {
    print('Payload $payload');
    Navigator.push(context, MaterialPageRoute(builder: (coontext) {
      return NotificationScreen(
        payload: payload,
      );
    }));
  }
}

class NotificationScreen extends StatefulWidget {
  final String payload;

  NotificationScreen({this.payload});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('Notification Screen'),
        ),
        body: Center(
          child: Text(widget.payload),
        )
    );
  }

}
