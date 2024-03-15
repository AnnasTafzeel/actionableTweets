//import 'package:actionable_tweets/constants/assetsconstants.dart';
import 'package:actionable_tweets/auth/screens/home_view.dart';
import 'package:actionable_tweets/auth/screens/filter_tweets.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class NotificationActivity extends StatefulWidget {
  final List<Map<String, dynamic>> tweets;
  final Map<String, String> filters;

  const NotificationActivity({
    super.key,
    required this.tweets,
    required this.filters,
  });

  @override
  // ignore: library_private_types_in_public_api
  _NotificationActivityState createState() => _NotificationActivityState();
}

class _NotificationActivityState extends State<NotificationActivity> {
  int _page = 3;
  final bool _loading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _loading ? _buildShimmerEffect() : _buildTweetNotifications(),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(20),
        height: size.width * .155,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
          borderRadius: BorderRadius.circular(50),
        ),
        child: ListView.builder(
          itemCount: 4,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: size.width * .024),
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              setState(
                () {
                  _page = index;
                  if (index >= 0 && index < 3) {
                    _page = index;
                    if (_page == 0) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const HomeView()),
                      );
                    } else if (_page == 1) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FilterTweets(
                            filters: widget.filters,
                            tweets: widget.tweets,
                          ),
                        ),
                      );
                    }
                  }
                },
              );
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.fastLinearToSlowEaseIn,
                  margin: EdgeInsets.only(
                    bottom: index == _page ? 0 : size.width * .029,
                    right: size.width * .0422,
                    left: size.width * .0422,
                  ),
                  width: size.width * .128,
                  height: index == _page ? size.width * .014 : 0,
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    ),
                  ),
                ),
                Icon(
                  listOfIcons[index],
                  size: size.width * .076,
                  color: index == _page ? Colors.blueAccent : Colors.black38,
                ),
                SizedBox(height: size.width * .03),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.filter_list,
    Icons.settings_rounded,
    Icons.notifications_rounded,
  ];

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.white,
            ),
            title: Container(
              width: double.infinity,
              height: 16.0,
              color: Colors.white,
            ),
            subtitle: Container(
              width: double.infinity,
              height: 16.0,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }

  Widget _buildTweetNotifications() {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: widget.tweets.length,
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
      itemBuilder: (context, index) {
        final tweet = widget.tweets[index];
        final tweetText = tweet['text'] ?? '';
        final avatarUrl = tweet['tweet_avatar'] ?? '';

        final limitedText = (tweetText.split('\n').take(1).join('') +
            (tweetText.split('').length > 1 ? '...' : ''));

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(avatarUrl),
          ),
          title: const Text(
            'Actionable tweet detected:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          subtitle: Text(
            limitedText,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        );
      },
    );
  }
}
