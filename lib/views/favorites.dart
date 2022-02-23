import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news_app/database/database_helper.dart';
import 'package:news_app/models/news.dart';
import 'package:news_app/services/news_service.dart';
import 'package:news_app/views/components/bottom_nav_bar.dart';
import 'package:news_app/views/components/profile.dart';
import 'package:news_app/views/components/search_widget.dart';
import 'package:news_app/views/news_details.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:url_launcher/url_launcher.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  final bool _enabled = true;
  List<News> news = [];
  String query = '';
  Timer? debouncer;

  Future init() async {
    final news = await NewsService.getNews(query);

    setState(() => this.news = news);
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  Future searchNews(String query) async => debounce(() async {
        final news = await NewsService.getNews(query);

        if (!mounted) return;

        setState(() {
          this.query = query;
          this.news = news;
        });
      });

  @override
  void initState() {
    init();

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Profile(
                  name: 'Saleh Souayh',
                  goBack: false,
                ),
              ),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: DatabaseHelper.instance.getNews(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<dynamic>> snapshot) {
                    if (!snapshot.hasData) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0), child: shimmer());
                    }
                    return ListView(
                      children: snapshot.data!.map((e) {
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewsDetails(
                                          news: News(
                                              title: e['title'],
                                              description: e['description'],
                                              publishedAt: e['publishedAt'],
                                              urlImage: e['urlImage'],
                                              source: e['source'],
                                              url: e['url']))),
                                );
                              },
                              child: newsCard(
                                  News(
                                      title: e['title'],
                                      description: e['description'],
                                      publishedAt: e['publishedAt'],
                                      urlImage: e['urlImage'],
                                      source: e['source'],
                                      url: e['url']),
                                  e['id']),
                            ));
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
      ),
    );
  }

  Widget shimmer() => Shimmer(
        direction: const ShimmerDirection.fromLTRB(),
        color: const Color.fromRGBO(38, 38, 38, 0.4),
        colorOpacity: 0,
        enabled: _enabled,
        child: ListView.builder(
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 130.0,
                  height: 70.0,
                  color: Colors.white,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                      ),
                      Container(
                        width: double.infinity,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: 40.0,
                        height: 8.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          itemCount: 9,
        ),
      );

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Enter Title or Source',
        onChanged: searchNews,
      );

  Widget newsCard(News news, int id) => Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              news.urlImage,
              fit: BoxFit.fill,
              width: 100,
              height: 100,
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    news.source!,
                    style: const TextStyle(fontSize: 13),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          setState(() {
                            DatabaseHelper.instance.remove(id);
                          });
                        },
                      ),
                      IconButton(
                          onPressed: () {
                            _launchURL(news.url);
                          },
                          icon: const Icon(
                            Icons.link_sharp,
                            color: Colors.green,
                          )),
                      IconButton(
                          onPressed: () {
                            Share.share('check out the link ${news.url}');

                          },
                          icon: const Icon(
                            Icons.share,
                            color: Colors.teal,
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  void _launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }
}
