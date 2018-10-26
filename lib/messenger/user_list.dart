import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {

  List<Users> zoom_users = List();

  DatabaseReference database;

  @override
  void initState() {
    super.initState();

    database = FirebaseDatabase.instance.reference().child("zoom_users");

  }


  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
      defaultChild: Center(child: new CircularProgressIndicator(backgroundColor: Colors.deepPurpleAccent,)),
      query: database,
      sort: (a,b) => (b.key.compareTo(a.key)), // last added item will be show first
      itemBuilder: (_, DataSnapshot lastMessageUserSnapshot, Animation<double> animation, int index) {

        //get last message data
        return new FutureBuilder<DataSnapshot>(
          future: database.child(lastMessageUserSnapshot.key).once(),
          builder: (BuildContext context, lastMessageDataSnapshot){

            if(lastMessageDataSnapshot.hasData){

              //get last message user data. like I sent message to you. so I need your information
              return FutureBuilder<DataSnapshot>(
                future: database.child(lastMessageUserSnapshot.key).once(),
                builder: (BuildContext context, userSnapshot){

                  if(userSnapshot.hasData){

                    String name = userSnapshot.data.value['name'];
                    String phone = userSnapshot.data.value['phone'];

                    Users lastMessages = new Users(
                      name: name,
                      phone: phone,
                    );

                    return userListWidget(lastMessages, context);
                  }
                  else{
                    return new Container();
                  }
                },
              );
            }
            else
              return new Container();
          },
        );
      },
    );

  }
}

Widget userListWidget(Users users, BuildContext context){
  return SafeArea(
    child: new Column(
      children: <Widget>[

        new Divider(
          height: 10.0,
        ),
        new ListTile(
          leading: new CircleAvatar(
            foregroundColor: Colors.green,
            backgroundColor: Colors.red,

          ),
          title: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(
                users.name,
              ),
              new Text(
                users.phone,
              )
            ],
          ),
        ),

      ],
    ),
  );
}

class Users {
  String key;
  String name;
  String phone;
  String password;

  Users({this.name, this.phone, this.password});
}