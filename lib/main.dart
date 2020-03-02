import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UI CHAT',
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
      home: ChatPage(),
    );
  }
}


class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}
class _ChatPageState extends State<ChatPage> {

  final _streamController = StreamController<MessageClass>.broadcast(); //streamListener
  TextEditingController _controllerMessage = TextEditingController(); //Controller message
  List<MessageClass> messagesList = List(); //Our message list

  void initializeMessageList(){ //simulating a already database data
    messagesList.add(MessageClass("This is my UI chat, do you like it?", "me"));
    messagesList.add(MessageClass("Yes!!", "you"));
    messagesList.add(MessageClass("See my others UI implementations on my github profile", "me"));
    messagesList.add(MessageClass("github.com/natanlimap", "me"));
    messagesList.add(MessageClass("OK!", "you"));
  }

  @override
  void initState() { //Start adding the messages in the list
    initializeMessageList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height; //the cellphone height
    double width = MediaQuery.of(context).size.width; //the cellphone width
    ScrollController scrollController = ScrollController(); //The screen scroll controlle

    _listener(){ //function that will add the data on the screen and if necessary scroll the page
      final stream = messagesList;
      stream.forEach((dados){ //parssing data for stremcontroller
        _streamController.add( dados );
      });
      Timer(Duration(seconds: 1), (){ //wait 1 second and scroll to the end of the list view
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
    }
    _listener(); //calling listener

    Widget messagesWidget () { //contains the messages widgets
      return new Expanded(child:
        new StreamBuilder<
          MessageClass>( //A stream builder for simultaneous addition of data as widget
          stream: _streamController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) { //check if stream ref exists
              print(snapshot.hasData); //checking if this ref has data
              switch (snapshot
                  .connectionState) { //checking the state of snapshot by stream addition
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return new Center(
                    child: new CircularProgressIndicator(),); //Loading widget
                case ConnectionState.active:
                case ConnectionState.done:
                  return new ListView.builder( //A listView with the messages
                      controller: scrollController, //ScrollController for the current position of list view
                      itemCount: messagesList.length,  //Getting the list lenght
                      itemBuilder: (context, index) {
                        Alignment _textAlign; //text alignment(me / you)
                        Color _color; //text color
                        if (messagesList[index].whosent == "me") { //checking who sent the message
                          _textAlign = Alignment.centerRight; //aligning message if i sent
                          _color = Colors.black87; //changing the color
                        } else {
                          _color =
                              Colors.grey[800]; //aligning message if other sent
                          _textAlign =
                              Alignment.centerLeft; //changing the color
                        }
                        return new Align(
                          alignment: _textAlign,
                          child: new Padding(
                            padding: new EdgeInsets.all(6),
                            child: new Card(
                              elevation: 10,
                                child: new Container( //message container
                                width: width * 0.8,
                                padding: new EdgeInsets.all(16),
                                decoration: new BoxDecoration( //putting the decoration
                                    color: _color,
                                    borderRadius: new BorderRadius
                                        .all( //rounding the container
                                        new Radius.circular(8))),
                                child: new Text( //message content
                                  messagesList[index].message,
                                  style: new TextStyle(fontSize: 18, color: Colors.white),
                                ),
                              ),
                            )
                          ),
                        );
                      }
                  );
              }
            } else {
              return new Container(); //if doesnt has data return a white container
            }
          }
      )
      );
    }
    addMessage(){ //function that send message to list
      messagesList.add(MessageClass(_controllerMessage.text, "me")); //implement here a method to send to your database instead the list
      _controllerMessage.clear();
      _listener();
    }


    Widget bottomWidget() { //widget with message formfield and sent buttom
      return new Container(
        child: new Row(
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.only(left: width * 0.02),
            ),
            new Expanded(
              child: new TextField( //Text form field where user will put the message
                autofocus: false, //dont initiliaze the page with this form pressed
                keyboardType: TextInputType.text,
                controller: _controllerMessage, //controller
                style: new TextStyle(fontSize: 20),
                decoration: new InputDecoration( //form decoration
                    hintText: "Type your message", hintStyle: new TextStyle(color: Colors.black54),
                    prefixIcon: new Icon( //icon before the hint message
                      Icons.message,
                      color: Colors.black54,
                    ),
                    hoverColor: Colors.black87,
                    focusColor: Colors.black87,
                    focusedBorder: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.black87),
                      borderRadius: new BorderRadius.circular(100), //rounding corners
                    ),
                    border: new OutlineInputBorder(
                      borderRadius:  new BorderRadius.circular(100), //rounding corners
                    )),
              ),
            ),
            new Padding(
              padding: new EdgeInsets.only(left: width * 0.02),
            ),
            new FloatingActionButton( //button to sent the message
              elevation: 10,
              backgroundColor: Colors.black87,
              child: new Icon(Icons.send),
              onPressed: () {
                addMessage();
              },
            ),
            new Padding(
              padding: new EdgeInsets.only(left: width * 0.02),
            ),
          ],
        ),
      );
    }
    return new Scaffold( //page's body
        appBar: new AppBar( //appbar app
          elevation: 10,
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: (){
              //navigator pop
            },
          ),
          title: new Row( //user name and photo
            children: <Widget>[
              new CircleAvatar(backgroundColor: Colors.white,child: new Icon(Icons.face, size: 40, color: Colors.black87,), radius: 25,),
              new Padding(padding: EdgeInsets.only(left: width*0.02)), new Text("User name", style: new TextStyle(fontSize: 20),)
            ],
          ),
          backgroundColor: Colors.black87,
        ),
        body: new Container( //body content
            color: Colors.white,
          child: new SafeArea( //to protect ios phones with uncompleted widgets
            child: new Column(
              children: <Widget>[
                messagesWidget(),
                bottomWidget(),
                new Padding(padding: new EdgeInsets.only(bottom: height * 0.02))
              ],
            ),
          ),
        ));
  }
}


class MessageClass{
  String message;
  String whosent;

  MessageClass(this.message, this.whosent);


}