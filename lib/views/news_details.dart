import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/database/database_helper.dart';
import 'package:news_app/models/news.dart';
import 'package:news_app/views/components/bottom_nav_bar.dart';
import 'package:news_app/views/components/profile.dart';
import 'package:news_app/views/components/search_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetails extends StatefulWidget {
  NewsDetails({Key? key, required this.news}) : super(key: key);
  News news;

  @override
  _NewsDetailsState createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Profile(
                name: 'Saleh Souayh',
                goBack: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Image.network(widget.news.urlImage),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.news.title,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.visible,
                      )),
                  const SizedBox(
                    height: 3,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Source : ' + widget.news.source!,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                        overflow: TextOverflow.ellipsis,
                      )),
                  const SizedBox(
                    height: 3,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Published at : ' +
                            widget.news.publishedAt.substring(0, 10),
                        overflow: TextOverflow.ellipsis,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.news.description,
                        style: const TextStyle(fontSize: 15),
                        overflow: TextOverflow.visible,
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.blueAccent,
                        ),
                        label: const Text(
                          'Add to favorites',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                        onPressed: () async {
                          await DatabaseHelper.instance.add(widget.news);
                        },
                      ),
                      TextButton.icon(
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.green,
                        ),
                        label: const Text(
                          'Visit Link',
                          style: TextStyle(color: Colors.green),
                        ),
                        onPressed: ()  {
                          _launchURL(widget.news.url);

                        },
                      ),
                      TextButton.icon(
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.teal,
                        ),
                        label: const Text(
                          'Share',
                          style: TextStyle(color: Colors.teal),
                        ),
                        onPressed: ()  {
                          Share.share('check out the link ${widget.news.url}');

                        },
                      ),

                    ],
                  ),

                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
      ),
    );
  }
  void _launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }
}
