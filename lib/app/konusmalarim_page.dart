import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterappcanliapp/app/sohbet_page.dart';
import 'package:flutterappcanliapp/models/konusma.dart';
import 'package:flutterappcanliapp/models/user.dart';
import 'package:flutterappcanliapp/view_model/user_model.dart';
import 'package:provider/provider.dart';

class KonusmalarimPage extends StatefulWidget {
  @override
  _KonusmalarimPageState createState() => _KonusmalarimPageState();
}

class _KonusmalarimPageState extends State<KonusmalarimPage> {
  @override


  @override
  Widget build(BuildContext context) {
    // _konusmalarimiGetir();
    var userModel = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Söhbətlər"),
      ),
      body: Center(
        child: FutureBuilder<List<Konusma>>(
          builder: (context, sohbetList) {
            if (!sohbetList.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              var tumKonusmalar = sohbetList.data;
              if (tumKonusmalar.length > 0) {
                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                      itemBuilder: (context, index) {
                        var oankiKonusma = tumKonusmalar[index];
                        return Card(
                          elevation: 2,
                          child: InkWell(
                            splashColor: Colors.purpleAccent.shade100,
                            onTap: () {
                              Navigator.of(context, rootNavigator: true)
                                  .push(MaterialPageRoute(builder: (context) {
                                return SohbetPage(
                                  currentUser: userModel.user,
                                  sohbetEdilenUser: User.idveResimAD(
                                      userID: oankiKonusma.kimle_konusuyor,
                                      profilURL:
                                      oankiKonusma.konusulanUserPpURL,
                                      userName: oankiKonusma.konusulanUserName),
                                );
                              }));
                            },
                            child: ListTile(
                              title: Text(
                                oankiKonusma.konusulanUserName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(oankiKonusma.son_yollanan_mesaj.length >
                                      20
                                      ? "${oankiKonusma.son_yollanan_mesaj.substring(0, 20)}..."
                                      : oankiKonusma.son_yollanan_mesaj),
                                  Text(
                                    oankiKonusma.aradakiFark,
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontStyle: FontStyle.italic),
                                  )
                                ],
                              ),
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.greenAccent,
                                child: CircleAvatar(
                                  radius: 27,
                                  backgroundImage: NetworkImage(
                                      oankiKonusma.konusulanUserPpURL),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: tumKonusmalar.length),
                );
              } else {
                return RefreshIndicator(
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Container(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.speaker_notes_off,
                                size: 80,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Hələ ki, söhbət başlatmamısınız...",
                                style:
                                TextStyle(fontSize: 20, color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                        height: MediaQuery.of(context).size.height - 150,
                      ),
                    ),
                    onRefresh: _refresh);
              }
            }
          },
          future: userModel.getAllConservations(userModel.user.userID),
        ),
      ),
    );
  }

  Future<Null> _refresh() async {
    setState(() {});
    await Future.delayed(Duration(seconds: 1));
    return null;
  }

  void _konusmalarimiGetir() async {
    var _userModel =
    Provider.of<UserModel>(context); //mence burda listen false olmalidi
    var konusmalarim = await Firestore.instance
        .collection("konusmalar")
        .where("konusma_sahibi", isEqualTo: _userModel.user.userID)
        .orderBy("olusturulma_tarihi", descending: true)
        .getDocuments();

    for (var konusma in konusmalarim.documents) {
      print("s o h b e t: " + konusma.data.toString());
    }
  }
}


