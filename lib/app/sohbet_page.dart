import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterappcanliapp/models/mesaj.dart';
import 'package:flutterappcanliapp/models/user.dart';
import 'package:flutterappcanliapp/view_model/user_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SohbetPage extends StatefulWidget {
  User currentUser;
  User sohbetEdilenUser;

  SohbetPage({this.currentUser, this.sohbetEdilenUser});

  @override
  _SohbetPageState createState() => _SohbetPageState();
}

class _SohbetPageState extends State<SohbetPage> {
  TextEditingController _mesajController=TextEditingController();
  ScrollController _scrollController = new ScrollController();



  @override
  Widget build(BuildContext context) {
    var _userModel = Provider.of<UserModel>(context);

    var currentUser = widget.currentUser;
    var sohbetEdilenUser = widget.sohbetEdilenUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sohbetEdilenUser.userName),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              // bunu expandedsiz yoxla
              child: StreamBuilder<List<Mesaj>>(
                stream: _userModel.getMessages(
                    currentUser.userID, sohbetEdilenUser.userID),
                builder: (BuildContext context,
                    AsyncSnapshot streamMesajlarListesi) {
                  if (!streamMesajlarListesi.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  var tumMesajlar = streamMesajlarListesi.data;
                  return ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      itemCount: tumMesajlar.length,
                      itemBuilder: (context, index) {
                        return chatBalloon(tumMesajlar[index]);
                      });
                },
              ),
            ),
            Material(
              color: Colors.white,
              elevation: 15,
              child: Container(
                padding: EdgeInsets.only(bottom: 8, left: 8),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _mesajController,
                        cursorColor: Colors.blueGrey,
                        style: new TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Mesajınızı Yazın",
                          border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                      child: FloatingActionButton(
                        onPressed: () async {
                          debugPrint("******************** 3 OK");

                        if (_mesajController.text.trim().length > 0) {
                            Mesaj mesaj = Mesaj(
                                kimden: currentUser.userID,
                                kime: sohbetEdilenUser.userID,
                                mendenMi: true,
                                mesaj: _mesajController.text);
                            _mesajController.clear();
                            var sonuc = await _userModel.saveMessage(mesaj);
                            if (sonuc == true) {
                              _scrollController.animateTo(0.0,
                                  duration: const Duration(milliseconds: 1),
                                  curve: Curves.easeInCirc);
                              debugPrint("******************** 1 OK");

                            }
                            else{
                              debugPrint("******************** 1 POK");
                            }
                            debugPrint("******************** 2 OK");

                          }


                        },
                        splashColor: Colors.greenAccent,
                        mini: false,
                        elevation: 0,
                        backgroundColor: Colors.white,
                        child: Container(
                          padding: EdgeInsets.only(left: 5),
                          child: Center(
                            child: Icon(
                              Icons.send,
                              size: 25,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chatBalloon(Mesaj mesaj) {
    Color _gelenMesajReng = Colors.purpleAccent;
    Color _gedenMesajReng = Theme.of(context).primaryColor;

    var _saatDeq = "";
    try {
      _saatDeq = _saatDeqGoster(mesaj.date);
    } catch (e) {
      print("sehv oldu");
    }

    var menimMesajimMi = mesaj.mendenMi;
    if (menimMesajimMi == true) {
      return Padding(
        padding: EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: _gedenMesajReng),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(
                      mesaj.mesaj,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  child: Text(_saatDeq),
                  margin: EdgeInsets.only(bottom: 7),
                ),
              ],
            )
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                CircleAvatar(
            radius: 22,backgroundColor: Colors.greenAccent.shade100 ,child: CircleAvatar(radius: 20,
                    backgroundImage:
                        NetworkImage(widget.sohbetEdilenUser.profilURL),
                  ),
                ),
                Container(
                  child: Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: _gelenMesajReng),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(4),
                      child: Text(
                        mesaj.mesaj,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Text(_saatDeq),
                  margin: EdgeInsets.only(bottom: 6),
                )
              ],
            )
          ],
        ),
      );
    }
  }

  _saatDeqGoster(Timestamp date) {
    var _formatter = DateFormat.Hm();
    var _formatlanmishTarix = _formatter.format(date.toDate());
    return _formatlanmishTarix;
  }
}
