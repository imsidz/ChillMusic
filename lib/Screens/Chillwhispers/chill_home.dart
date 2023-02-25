import 'dart:convert';

import 'package:blackhole/CustomWidgets/snackbar.dart';
import 'package:blackhole/Screens/Player/audioplayer.dart';
import 'package:blackhole/Services/youtube_services.dart';
import 'package:blackhole/env.dart' as env;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class ChillHome extends StatefulWidget {
  const ChillHome({super.key});

  @override
  _ChillHomeState createState() => _ChillHomeState();
}

class _ChillHomeState extends State<ChillHome> {
  List videos = [];
  int lengthh = 0;
  @override
  void initState() {
    super.initState();

    _getVideos();
  }

  Future<void> _getVideos() async {
    final resMe =
        await http.get(Uri.parse('${env.baseUrl}/list-home-videos'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    final decodeMe = jsonDecode(resMe.body) as Map;
    final vData = decodeMe['data'] as List;

    setState(() {
      videos = vData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: const [],
      ),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return Card(
            child: InkWell(
              onTap: () async {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (_, __, ___) => PlayScreen(
                      songsList: [
                        {
                          'id': videos[index]['videoId'],
                          'title': videos[index]['title'],
                          'artUri': videos[index]['thumbnail'].toString(),
                          'extras': {
                            'url':
                                'https://www.youtube.com/watch?v=${videos[index]['videoId']}',
                            'lowUrl': videos[index]['thumbnail'].toString(),
                            'highUrl': videos[index]['thumbnail'].toString(),
                            'year': null,
                            'language': null,
                            '320kbps': null,
                            'quality': null,
                            'has_lyrics': null,
                            'release_date': null,
                            'album_id': null,
                            'subtitle': null,
                            'perma_url':
                                'https://www.youtube.com/watch?v=${videos[index]['videoId']}',
                            'addedByAutoplay': false,
                            'autoplay': false
                          }
                        }
                      ],
                      index: 0,
                      recommend: false,
                      fromDownloads: false,
                      fromMiniplayer: false,
                      offline: false,
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Image.network(
                    videos[index]['thumbnail'].toString(),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, bottom: 10, top: 10),
                    child: Text(videos[index]['title'].toString()),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
