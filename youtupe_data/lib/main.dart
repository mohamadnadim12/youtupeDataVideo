// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, no_leading_underscores_for_local_identifiers, unused_element

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() {
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Video Info',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: VideoInfoScreen(),
    );
  }
}

class VideoInfoScreen extends StatefulWidget {
  const VideoInfoScreen({super.key});

  @override
  _VideoInfoScreenState createState() => _VideoInfoScreenState();
}

class _VideoInfoScreenState extends State<VideoInfoScreen> {
  final videoUrl =
      'https://www.youtube.com/watch?v=zon3WgmcqQw&ab_channel=FlutterGuys';
  late YoutubeExplode yt;
  late Video video;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    yt = YoutubeExplode();
    fetchVideoInfo();
  }

  Future<void> fetchVideoInfo() async {
    var videoId = VideoId(videoUrl);
    video = await yt.videos.get(videoId);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    yt.close();
    super.dispose();
  }

  Future<void> openYouTubeVideo() async {
    final Uri _url = Uri.parse(videoUrl);
    if (!await launchUrl(_url)) {
      throw 'Could not launch $videoUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('YouTube Video Info')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Video Title:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(video.title),
                    SizedBox(height: 20),
                    Text('Video Description:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(video.description),
                    SizedBox(height: 20),
                    Text('Views: ${video.engagement.viewCount}'),
                    SizedBox(height: 20),
                    Text('Author: ${video.author}'),
                    SizedBox(height: 20),
                    Text('Published At: ${video.publishDate}'),
                    SizedBox(height: 20),
                    Text('Duration: ${video.duration}'),
                    SizedBox(height: 20),
                    Text('Keywords: ${video.keywords}'),
                    SizedBox(height: 20),
                    Text('Thumbnails: ${video.thumbnails.mediumResUrl}'),
                    SizedBox(height: 20),
                    Text('Video Url: ${video.url}'),
                    SizedBox(height: 20),
                    Text('Video Id: ${video.id}'),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: openYouTubeVideo,
                      child: Text('Watch on YouTube'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
