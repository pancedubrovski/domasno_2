import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInput extends StatefulWidget {
  String userName;
  String phone;
  String email;
  bool _haveInfo = false;
  UserInput({Key key}) : super(key: key);
  @override
  UserInputState createState() => UserInputState();


}

class UserInputState extends State<UserInput> {



  final _userNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();










  SaveFunc() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(prefs.getString("userName")== null ) {

      prefs.setString("userName", _userNameController.text);
      prefs.setString("phone", _phoneController.text);
      prefs.setString("email", _emailController.text);
      setState(() {
        widget._haveInfo = true;
        widget.userName = _userNameController.text;
        widget.email = _emailController.text;
        widget.phone = _phoneController.text;
      });


    }
    else {
      widget.userName =  prefs.getString("userName");
      widget.phone =  prefs.getString("phone");
      widget.email =  prefs.getString("email");
      setState(() {
        widget._haveInfo = true;

      });

    }
  }

  // Widget UserInfo () {
  //   return new Container(
  //     child:Column(
  //       children: <Widget>[
  //         Container(
  //             child: Text('User Name: '+ widget.userName)
  //         ),
  //         Container(
  //           child:  Text('Phone: '+widget.phone),
  //         ),
  //         new Text('E-mail:'+widget.email)
  //       ],
  //     ),
  //   );
  // }

  Widget UserInput () {
    return new Column(
      children: <Widget>[
        new ListTile(
          leading: const Icon(Icons.person),
          title: TextFormField(
            controller: _userNameController,
            decoration: InputDecoration(
                labelText: 'Enter your User Name'
            ),
          ),
        ),
        new ListTile(
          leading: const Icon(Icons.phone),
          title: TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
                labelText: 'Enter your phone'
            ),
          ),
        ),
        new ListTile(
          leading: const Icon(Icons.mail),
          title: TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
                labelText: 'Enter your e-mail'
            ),
          ),
        ),
        new ButtonBar(
          children: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              color: Colors.red,

              onPressed: () {},
            ),
            FlatButton(
                child: Text('Save'),
                color: Colors.green,
                onPressed: SaveFunc

            ),
          ],
        ),
      ],
    );





  }




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar:AppBar(
        title: Text('User Info'),
        // actions: <Widget>[
        //   new IconButton(icon: const Icon(Icons.save))
        // ],
      ),
      body: (widget._haveInfo ? UserInfo(userName:widget.userName,phone:widget.phone,email: widget.email,) : UserInput()) ,
    );
  }
}
class UserInfo extends StatefulWidget {

  UserInfo({this.userName,this.phone,this.email});
  UserInfoState createState() => UserInfoState();
  final String userName;
  final String phone;
  final String email;

}
class UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child:Column(
        children: <Widget>[
          Container(

              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(20.0),
              color: Colors.green,
              child: Text('User Name: '+ widget.userName)
          ),
          Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(20.0),
            color: Colors.green,

            child:  Text('Phone: '+widget.phone),
          ),
          Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(20.0),
            color: Colors.green,
            child: new Text('E-mail:'+widget.email),
          ),
        ],
      ),
    );
  }

}