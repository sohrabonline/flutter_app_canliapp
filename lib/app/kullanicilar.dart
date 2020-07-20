import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutterappcanliapp/app/sohbet_page.dart';
import 'package:flutterappcanliapp/models/user.dart';
import 'package:flutterappcanliapp/view_model/all_users_view_model.dart';
import 'package:flutterappcanliapp/view_model/chat_view_model.dart';
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
    super.initState();
    _scrollController.addListener(_listeScrollListener);
  }

  void _listeScrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("Listenin en altındayız");
      getMoreUser();
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
          if (allUserModel.state == AllUseriewState.Busy) {
            return Center(
                child: JumpingText(
              "Yüklənir...",
              style: TextStyle(color: Colors.blue, fontSize: 20),
            ));
          } else if (allUserModel.state == AllUseriewState.Loaded) {
            return RefreshIndicator(
              onRefresh: allUserModel.refresh,
              child: ListView.builder(
                itemCount: allUserModel.hasMore ? allUserModel.tumKullanicilar.length+1 : allUserModel.tumKullanicilar.length,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  if (allUserModel.tumKullanicilar.length == 1) {
                    return _noUserWidget();
                  } else if (allUserModel.hasMore &&
                      index == allUserModel.tumKullanicilar.length) {
                    return _yeniElementlerYuklenirIndicator();
                  } else {
                    return lisTileGetir(index);
                  }
                },
              ),
            );
          } else {
            return Container();
          }
        }));
  }


  Widget lisTileGetir(int index) {
    UserModel userModel = Provider.of<UserModel>(context);
    AllUserViewModel allUserViewModel = Provider.of<AllUserViewModel>(context);
    User oankiUser = allUserViewModel.tumKullanicilar[index];
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
            return ChangeNotifierProvider(
              create: (context){
                return ChatViewModel(currentUser: userModel.user,sohbetEdilenUser: oankiUser); },
               child: SohbetPage(
                currentUser: userModel.user,
                sohbetEdilenUser: oankiUser,
              ),
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
              title: Text(allUserViewModel.tumKullanicilar[index].userName),
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


  _yeniElementlerYuklenirIndicator() {
    AllUserViewModel allUserViewModel = Provider.of<AllUserViewModel>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child:JumpingText(
                "Yüklənir...",
                style: TextStyle(color: Colors.blue, fontSize: 20),
              )
           ,
      ),
    );
  }

  void getMoreUser() async {
    if (isLoading == false) {
      isLoading = true;
      final _tumKullanicilarViewModel =
          Provider.of<AllUserViewModel>(context, listen: false);
      await _tumKullanicilarViewModel.getMoreUser();
      isLoading = false;
    }
  }

  Widget _noUserWidget() {
    AllUserViewModel allUserViewModel = Provider.of<AllUserViewModel>(context);

    return RefreshIndicator(
      onRefresh: allUserViewModel.refresh,
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
