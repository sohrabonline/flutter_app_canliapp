/*

import 'package:flutter/material.dart';


import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: FutureBuilder<List<User>>(
          builder: (context, sonuc) {
            if (sonuc.hasData) {
              var tumKullanicilar = sonuc.data;
              if (tumKullanicilar.length - 1 > 0) {
                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                      itemCount: tumKullanicilar.length,
                      itemBuilder: (context, index) {
                        var oankiUser = sonuc.data[index];

                        if (oankiUser.userID != userModel.user.userID) {
                          return Material(
                            elevation: 5,
                            child: InkWell(
                              hoverColor: Colors.lightGreenAccent,
                              splashColor: Colors.lightGreenAccent,
                              highlightColor: Colors.blue.shade100,
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return SohbetPage(
                                    currentUser: userModel.user,
                                    sohbetEdilenUser: oankiUser,
                                  );
                                }));
                              },
                              child: Slidable(actionPane: SlidableDrawerActionPane(),
                                actionExtentRatio: 0.25,
                                child: Container(
                                  child: ListTile(
                                    title: Text(tumKullanicilar[index].userName),
                                  ),
                                ),
                                actions: <Widget>[IconSlideAction(
                                  caption: 'Archive',
                                  color: Colors.blue,
                                  icon: Icons.archive,
                                  onTap: () => null,
                                ),
                                  IconSlideAction(
                                    caption: 'Share',
                                    color: Colors.indigo,
                                    icon: Icons.share,
                                    onTap: () => null,
                                  ),],
                                secondaryActions: <Widget>[ IconSlideAction(
                                  caption: 'More',
                                  color: Colors.black45,
                                  icon: Icons.more_horiz,
                                  onTap: () => null,
                                ),
                                  IconSlideAction(
                                    caption: 'Delete',
                                    color: Colors.red,
                                    icon: Icons.delete,
                                    onTap: () => null,
                                  ),],
                              );,
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }),
                );
              } else {
                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.do_not_disturb_off,
                              size: 80,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Hələ ki, istifadəçi yoxdur...",
                              style:
                              TextStyle(fontSize: 20, color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      height: MediaQuery.of(context).size.height - 150,
                    ),
                  ),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
          future: userModel.getAllUser(),
        ),
      ),
    );
  }
}
*/
