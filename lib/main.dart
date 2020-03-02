import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      stream.forEach((dados){
        _streamController.add( dados );
      });
      Timer(Duration(seconds: 1), (){
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
    }
    _listener();
    var messagesWidget = //a var that contains the messages widgets
        Expanded(child:
          StreamBuilder<MessageClass>( //A stream builder for simultaneous addition of data as widget
              stream: _streamController.stream,
              builder: (context, snapshot) {
                if(snapshot.hasData){ //check if stream ref exists
                  print(snapshot.hasData); //checking if this ref has data
                  switch (snapshot.connectionState) { //checking the state of snapshot by stream addition
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator(),); //Loading widget
                    case ConnectionState.active:
                    case ConnectionState.done:
                    return ListView.builder( //A listView with the messages
                          controller: scrollController, //ScrollController for the current position of list view
                          itemCount: messagesList.length, //Getting the list lenght
                          itemBuilder: (context, index) {
                            Alignment _textAlign; //text alignment(me / you)
                            Color _color; //text color
                            if (messagesList[index].whosent == "me") { //checking who sent the message
                              _textAlign = Alignment.centerRight; //aligning message if i sent
                              _color = Colors.red[300]; //changing the color
                            } else {
                              _color = Colors.black26; //aligning message if other sent
                              _textAlign = Alignment.centerLeft; //changing the color
                            }
                            return Align(
                              alignment: _textAlign,
                              child: Padding(
                                padding: EdgeInsets.all(6),
                                child: Container( //message container
                                  width: width * 0.8,
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration( //putting the decoration
                                      color: _color,
                                      borderRadius: BorderRadius.all( //rounding the container
                                          Radius.circular(8))),
                                  child: Text( //message content
                                    messagesList[index].message,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            );
                          }
                      );
                  }
                      }else{
                        return Container(); //if doesnt has data
                      }
                }
              )
        );


    var caixaDeMensage = Container(
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: width * 0.02),
          ),
          Expanded(
            child: TextField(
              autofocus: false,
              keyboardType: TextInputType.text,
              controller: _controllerMessage,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                  hintText: "Digite sua mensagem",
                  prefixIcon: Icon(
                    Icons.monetization_on,
                    color: Colors.black45,
                  ),
                  filled: true,
                  hoverColor: Colors.black45,
                  fillColor: Colors.white,
                  focusColor: Colors.black45,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black45),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  )),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: width * 0.02),
          ),
          FloatingActionButton(
            backgroundColor: Colors.black45,
            child: Icon(Icons.send),
            onPressed: (){},
          ),
          Padding(
            padding: EdgeInsets.only(left: width * 0.02),
          ),
        ],
      ),
    );
    return Scaffold(
        appBar: AppBar(
          elevation: 10,
          title: Row(
            children: <Widget>[
              CircleAvatar(backgroundColor: Colors.white,child: Icon(Icons.face, size: 40, color: Colors.red,), radius: 25,),
              Padding(padding: EdgeInsets.only(left: width*0.02)),Text("User name", style: TextStyle(fontSize: 20),)],),
          backgroundColor: Colors.red,
        ),
        body: Container(
            color: Colors.white,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                messagesWidget,
                caixaDeMensage,
                Padding(padding: EdgeInsets.only(bottom: height * 0.02))
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