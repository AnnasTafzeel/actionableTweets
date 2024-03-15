import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

// Define a global variable to hold the tweet list
List<Map<String, dynamic>> globalTweets = [];

class TweetList extends StatefulWidget {
  const TweetList({Key? key}) : super(key: key);

  @override
  _TweetListState createState() => _TweetListState();
}

class _TweetListState extends State<TweetList> {
  bool isLoading = false;
  bool predictionsLoaded = false;
  List<Map<String, dynamic>> savedTweets = [];

  @override
  void initState() {
    super.initState();
    // Load the model and make predictions when the widget is initialized
    //loadModelAndRunInference();
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Function to save a tweet
  void saveTweet(Map<String, dynamic> tweet) {
    setState(() {
      savedTweets.add(tweet);
      if (kDebugMode) {
        print(savedTweets);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tweet saved successfully!'),
      ),
    );
  }

  Future<void> loadModelAndRunInference() async {
    // setState(() {
    //   predictionsLoaded = true;
    // });

    // Fetch tweets once predictions are loaded
    await fetchTweets();
  }

  Future<void> fetchTweets() async {
    final response = await http.post(
      Uri.parse('http://10.97.7.134:5001/actionableTweets'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response);
      }
      final List<String> lines = LineSplitter.split(response.body)
          .where((String line) => line.isNotEmpty)
          .toList();

      final List<Map<String, dynamic>> result = lines
          .map((String line) => json.decode(line) as Map<String, dynamic>)
          .toList();
      if (kDebugMode) {
        print(result);
      }

      setState(() {
        globalTweets = result;
        isLoading = false;
        predictionsLoaded = true;
      });
    } else {
      if (kDebugMode) {
        print('Failed to fetch tweets');
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Predicted Tweets',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? _buildLoading()
          : predictionsLoaded
              ? _buildTweetList()
              : _buildInitialUI(),
    );
  }

  Widget _buildInitialUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Load Model and Run Inference...',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              loadModelAndRunInference();
            },
            child: const Text('Make Predictions'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 55,
          ),
          Lottie.asset(
            'assets/business-chart.json', // Replace with your Lottie animation file
            width: 250,
            height: 250,
          ),
          const SizedBox(height: 20),
          const Text(
            'Please wait while the model makes predictions...',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTweetList() {
    return ListView.builder(
      itemCount: globalTweets.length,
      itemBuilder: (context, index) {
        final tweet = globalTweets[index];
        return _buildTweetWidget(tweet);
      },
    );
  }

  Widget _buildTweetWidget(Map<String, dynamic> tweet) {
    final imageWidget = ClipOval(
      child: Image.asset(
        'assets/download.png',
        width: 30.0,
        height: 30.0,
      ),
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  imageWidget,
                  const SizedBox(width: 12.0),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Label: ${tweet['predicted_label']}',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Text(tweet['text'] ?? ''),
                    const SizedBox(height: 12.0),
                  ],
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: tweet,
                      child: const Text('Save Tweet'),
                    ),
                  ];
                },
                onSelected: (value) {
                  // ignore: unnecessary_type_check
                  if (value is Map<String, dynamic>) {
                    saveTweet(value);
                    if (kDebugMode) {
                      print(value);
                    }
                    _showSnackbar('Tweet saved successfully!');
                  } else {
                    _showSnackbar('Tweet not saved!');
                  }
                },
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
