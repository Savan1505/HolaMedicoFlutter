import 'package:pharmaaccess/SharedPref.dart';
import 'package:pharmaaccess/apis/news_provider.dart';
import 'package:pharmaaccess/models/news_item_model.dart';
import 'package:pharmaaccess/models/tip_of_day_model.dart';

class NewsService {
  static TipOfDayModel? tip;
  static DateTime _lastFetch = DateTime(1970, 1, 1);
  static List<NewsModel>? news;
  static List<NewsModel>? newsAvicenna;
  static List<NewsModel>? newsMessageExpert;
  NewsProvider newsProvider = NewsProvider();

  Future<List<NewsModel>?> getNews() async {
    var now = DateTime.now();
    var duration = now.difference(_lastFetch);
    String isTokenStore = await SharedPref().getString("TokenStore");
    int getLastTokenTIme = await SharedPref().getInt("TokenTimeStamp");
    print("token :: $isTokenStore");
    var twoWeeks = 1000 * 60 * 60 * 24 * 14;
    var currentTime = DateTime.now().millisecondsSinceEpoch - getLastTokenTIme;
    if (isTokenStore.isEmpty || currentTime > twoWeeks) {
      await newsProvider.updateToken();
    }
    if (news == null || duration.inMinutes > 15) {
      news = await newsProvider.getNews();
      _lastFetch = now;
    }
    return news;
  }

  Future<NewsData?> getNewsForHome(int pageNo) async {
    var now = DateTime.now();
    var duration = now.difference(_lastFetch);
    String isTokenStore = await SharedPref().getString("TokenStore");
    int getLastTokenTIme = await SharedPref().getInt("TokenTimeStamp");
    print("token :: $isTokenStore");
    var twoWeeks = 1000 * 60 * 60 * 24 * 14;
    var currentTime = DateTime.now().millisecondsSinceEpoch - getLastTokenTIme;
    if (isTokenStore.isEmpty || currentTime > twoWeeks) {
      await newsProvider.updateToken();
    }
    if (news == null || duration.inMinutes > 15) {
      news = await newsProvider.getNewsForHome();
      _lastFetch = now;
    }
    if (news != null) {
      List<NewsModel>? newsTemp = [];
      for (int i = 0; i < pageNo * 10; i++) {
        newsTemp.add(news![i]);
      }
      NewsData newsData = NewsData(newsTemp, news!.length);
      await Future.delayed(Duration(milliseconds: 500));
      return newsData;
    } else {
      return null;
    }
  }

  Future<NewsData?> getNewsForAvicenna(int pageNo, int categoryId) async {
    var now = DateTime.now();
    var duration = now.difference(_lastFetch);
    String isTokenStore = await SharedPref().getString("TokenStore");
    int getLastTokenTIme = await SharedPref().getInt("TokenTimeStamp");
    print("token :: $isTokenStore");
    var twoWeeks = 1000 * 60 * 60 * 24 * 14;
    var currentTime = DateTime.now().millisecondsSinceEpoch - getLastTokenTIme;
    if (isTokenStore.isEmpty || currentTime > twoWeeks) {
      await newsProvider.updateToken();
    }
    if (newsAvicenna == null || duration.inMinutes > 15) {
      newsAvicenna =
          await newsProvider.getNewsForAvicennaAndExpertMessage(categoryId);
      _lastFetch = now;
    }
    if (newsAvicenna != null) {
      List<NewsModel>? newsTemp = [];
      for (int i = 0; i < pageNo * 10; i++) {
        if (newsAvicenna!.length > i) {
          newsTemp.add(newsAvicenna![i]);
        }
      }
      NewsData newsData = NewsData(newsTemp, newsAvicenna!.length);
      await Future.delayed(Duration(milliseconds: 500));
      return newsData;
    } else {
      return null;
    }
  }

  Future<NewsData?> getNewsForMessageExpert(int pageNo, int categoryId) async {
    var now = DateTime.now();
    var duration = now.difference(_lastFetch);
    String isTokenStore = await SharedPref().getString("TokenStore");
    int getLastTokenTIme = await SharedPref().getInt("TokenTimeStamp");
    print("token :: $isTokenStore");
    var twoWeeks = 1000 * 60 * 60 * 24 * 14;
    var currentTime = DateTime.now().millisecondsSinceEpoch - getLastTokenTIme;
    if (isTokenStore.isEmpty || currentTime > twoWeeks) {
      await newsProvider.updateToken();
    }
    if (newsMessageExpert == null || duration.inMinutes > 15) {
      newsMessageExpert =
          await newsProvider.getNewsForAvicennaAndExpertMessage(categoryId);
      _lastFetch = now;
    }
    if (newsMessageExpert != null) {
      List<NewsModel>? newsTemp = [];
      for (int i = 0; i < pageNo * 10; i++) {
        if (newsMessageExpert!.length > i) {
          newsTemp.add(newsMessageExpert![i]);
        }
      }
      NewsData newsData = NewsData(newsTemp, newsMessageExpert!.length);
      await Future.delayed(Duration(milliseconds: 500));
      return newsData;
    } else {
      return null;
    }
  }

  Future<TipOfDayModel?> getTip() async {
    DateTime now = new DateTime.now();
    var nowMilliseconds =
        DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    if (tip == null || nowMilliseconds > tip!.tipDate!.millisecondsSinceEpoch) {
      var t = await newsProvider.getTip();
      tip = t;
    }
    return tip;
  }
}
