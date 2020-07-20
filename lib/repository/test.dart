/*
enum ChatViewState { Idle, Loaded, Busy }

class ChatViewModel with ChangeNotifier {
  List<Mesaj> _tumMesajlar;
  ChatViewState _chatViewState = ChatViewState.Idle;
  int _getirilecekMesajSayi = 30;
  UserRepository _userRepository = locator<UserRepository>();
  final User currentUser;
  final User sohbetEdilenUser;
  Mesaj _enSonGetirilenMesaj;
  bool _hasMore = true;

  bool get hasMoreLoading => _hasMore;

  ChatViewModel({this.currentUser, this.sohbetEdilenUser}) {
    _tumMesajlar = [];
    getMessagesWithPagination(false);
  }

  List<Mesaj> get tumMesajlar => _tumMesajlar;

  ChatViewState get chatViewState => _chatViewState;

  set chatViewState(ChatViewState value) {
    _chatViewState = value;
    notifyListeners();
  }



*/
