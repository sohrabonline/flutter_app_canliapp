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


// T  E  S  T  2

/*



import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutterappcanliapp/app/sohbet_page.dart';
import 'package:flutterappcanliapp/models/user.dart';
import 'package:flutterappcanliapp/view_model/all_users_view_model.dart';
import 'package:flutterappcanliapp/view_model/user_model.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';

class KullanicilarPage extends StatefulWidget {
  @override
  _KullanicilarPageState createState() => _KullanicilarPageState();
}

class _KullanicilarPageState extends State<KullanicilarPage> {
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      getMoreUser();
    });

    _scrollController.addListener(() {
      _listeScrollListener();
    });
  }

  void _listeScrollListener() {
     if (_scrollController.position.atEdge) {
      if (_scrollController.position == 0) {
        debugPrint("en ust");
      } else {
        getMoreUser();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("İstifadəçilər"),
        ),
        body:
            Consumer<AllUserViewModel>(builder: (context, allUserModel, child) {
          if (allUserModel.state == AllUserViewState.Busy) {
            return Center(
                child: JumpingText(
              "Yüklənir...",
              style: TextStyle(color: Colors.blue, fontSize: 20),
            ));
          } else if (allUserModel.state == AllUserViewState.Loaded) {
            return ListView.builder(
              itemCount: allUserModel.kullanicilarListesi.length,
              controller: _scrollController,
              itemBuilder: (context, index) {
                if (allUserModel.hasMoreLoading
               && index == allUserModel.kullanicilarListesi.length) {
                  return _yeniElementlerYuklenirIndicator();
                }
else{
                return lisTileGetir(index);}
              },
            );
          } else {
            return Container();
          }
        }));
  }

/*
  getUser() async {
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    AllUserViewModel allUserViewModel =
        Provider.of<AllUserViewModel>(context, listen: false);

    if (!hasMore) {
      debugPrint("***** getirelecek yoxdu ona gore firebase yorma");
      return;
    }

    if (isLoading) {
      return;
    }

    setState(() {
      isLoading == true;
    });

    List<User> users = await userModel.getUserWithPagination(
        _enSonGetirilenUser, _getirilecekUserSayi);

    if (_enSonGetirilenUser == null) {
      allUserViewModel.tumKullanicilar = [];
      allUserViewModel.tumKullanicilar.addAll(users);
    } else {
      allUserViewModel.tumKullanicilar
          .addAll(users); //addAll ve add in ferqine bax
    }

    _enSonGetirilenUser = allUserViewModel.tumKullanicilar.last;
    print("son " + _enSonGetirilenUser.userName);

    if (users.length < _getirilecekUserSayi) {
      hasMore = false;
    }

    setState(() {
      isLoading == false;
    });
  }


  _kullaniciListesiniOlustur() {
    if (tumKullanicilar.length > 1) {
      return RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.builder(
          itemCount: tumKullanicilar.length + 1,
          controller: _scrollController,
          itemBuilder: (context, index) {
            if (index == tumKullanicilar.length) {
              return _yeniElementlerYuklenirIndicator();
            }

            return lisTileGetir(index);
          },
        ),
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
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  )
                ],
              ),
            ),
            height: MediaQuery.of(context).size.height - 150,
          ),
        ),
      );
    }
  }

 */

  Widget lisTileGetir(int index) {
    UserModel userModel = Provider.of<UserModel>(context);
    AllUserViewModel allUserViewModel = Provider.of<AllUserViewModel>(context);
    User oankiUser = allUserViewModel.kullanicilarListesi[index];
    if (oankiUser.userID == userModel.user.userID) {
      return Container();
    }

    return Card(
      elevation: 2,
      shadowColor: Colors.blue.shade100,
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
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Container(
            child: ListTile(
              subtitle: Text(oankiUser.email),
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue,
                child: CircleAvatar(
                  radius: 27,
                  backgroundImage: NetworkImage(oankiUser.profilURL),
                ),
              ),
              title: Text(allUserViewModel.kullanicilarListesi[index].userName),
            ),
          ),
          actions: <Widget>[
            IconSlideAction(
              caption: 'Arxivlə',
              color: Colors.blue,
              icon: Icons.archive,
              onTap: () => null,
            ),
            IconSlideAction(
              caption: 'Paylaş',
              color: Colors.indigo,
              icon: Icons.share,
              onTap: () => null,
            ),
          ],
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Daha çox',
              color: Colors.black45,
              icon: Icons.more_horiz,
              onTap: () => null,
            ),
            IconSlideAction(
              caption: 'Blok',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => null,
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> _refresh() async {
    //hasMore = true;
    //_enSonGetirilenUser = null;
    getMoreUser();
  }


  _yeniElementlerYuklenirIndicator() {
    AllUserViewModel allUserViewModel=Provider.of<AllUserViewModel>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: 1, //dersdde burani isLoading ? 1: 0        eliyib
          child: allUserViewModel.hasMoreLoading //dersdde burani isLoading eliyib
              ? JumpingText(
                  "Yüklənir...",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                )
              : null,
        ),
      ),
    );
  }

  getMoreUser() async {
    if (isLoading == false) {
      isLoading = true;
      AllUserViewModel allUserViewModel =
          Provider.of<AllUserViewModel>(context, listen: false);
      await allUserViewModel.dahaFazlaUserGetir();
      isLoading = false;
    }
  }
}

 */
