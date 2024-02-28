import 'package:actionable_tweets/auth/screens/filter_tweets.dart';
import 'package:actionable_tweets/auth/screens/home_view.dart';
import 'package:actionable_tweets/auth/screens/notification.dart';
import 'package:flutter/material.dart';

class SavedTweetsActivity extends StatefulWidget {
  final List<Map<String, dynamic>> savedTweets;
  //final Map<String, String> filters;
  //final List<Map<String, dynamic>> tweets;

  const SavedTweetsActivity({
    super.key,
    required this.savedTweets,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SavedTweetsActivityState createState() => _SavedTweetsActivityState();
}

class _SavedTweetsActivityState extends State<SavedTweetsActivity> {
  //int _page = 0;
  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Bookmarks',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        itemCount: widget.savedTweets.length,
        itemBuilder: (context, index) {
          final tweet = widget.savedTweets[index];
          //final user = tweet['user'];
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //imageWidget,
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(tweet['tweet_avatar'] ?? ''),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  tweet['fullname'] ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                '${tweet['username'] ?? ''}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                            ],
                          ),
                          Text(
                            tweet['text'] ?? '',
                          ),
                          // Row(
                          //   children: [
                          //     const Icon(Icons.repeat),
                          //     Text('${tweet['retweets'] ?? ''}'),
                          //     const SizedBox(width: 16.0),
                          //     const Icon(Icons.message),
                          //     Text('${tweet['replies'] ?? ''}'),
                          //     const SizedBox(width: 16.0),
                          //     Flexible(
                          //       child: Text(
                          //         '${tweet['timestamp'] ?? ''}',
                          //         style: const TextStyle(
                          //           color: Colors.grey,
                          //         ),
                          //         overflow: TextOverflow.ellipsis,
                          //       ),
                          //     )
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
            ],
          );
        },
      ),
      // bottomNavigationBar: Container(
      //   margin: const EdgeInsets.all(20),
      //   height: size.width * .155,
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black.withOpacity(.15),
      //         blurRadius: 30,
      //         offset: const Offset(0, 10),
      //       ),
      //     ],
      //     borderRadius: BorderRadius.circular(50),
      //   ),
      //   child: ListView.builder(
      //     itemCount: 4,
      //     scrollDirection: Axis.horizontal,
      //     padding: EdgeInsets.symmetric(horizontal: size.width * .024),
      //     itemBuilder: (context, index) => InkWell(
      //       onTap: () {
      //         setState(
      //           () {
      //             _page = index;
      //             if (index >= 0 && index < 4) {
      //               // Check if the index is within the valid range (0, 1, 2)
      //               _page = index; // Update _page when a tab is tapped
      //               if (_page == 0) {
      //                 Navigator.of(context).pushReplacement(
      //                   MaterialPageRoute(
      //                       builder: (context) => const HomeView()),
      //                 );
      //               } else if (_page == 1) {
      //                 Navigator.of(context).push(
      //                   MaterialPageRoute(
      //                     builder: (context) => FilterTweets(
      //                       filters: widget.filters,
      //                       tweets: widget.tweets,
      //                     ),
      //                   ),
      //                 );
      //               } else if (_page == 3) {
      //                 Navigator.of(context).push(
      //                   MaterialPageRoute(
      //                     builder: (context) => NotificationActivity(
      //                       filters: widget.filters,
      //                       tweets: widget.tweets,
      //                     ),
      //                   ),
      //                 );
      //               }
      //             }
      //           },
      //         );
      //       },
      //       splashColor: Colors.transparent,
      //       highlightColor: Colors.transparent,
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           AnimatedContainer(
      //             duration: const Duration(milliseconds: 1500),
      //             curve: Curves.fastLinearToSlowEaseIn,
      //             margin: EdgeInsets.only(
      //               bottom: index == _page ? 0 : size.width * .029,
      //               right: size.width * .0422,
      //               left: size.width * .0422,
      //             ),
      //             width: size.width * .128,
      //             height: index == _page ? size.width * .014 : 0,
      //             decoration: const BoxDecoration(
      //               color: Colors.blueAccent,
      //               borderRadius: BorderRadius.vertical(
      //                 bottom: Radius.circular(10),
      //               ),
      //             ),
      //           ),
      //           Icon(
      //             listOfIcons[index],
      //             size: size.width * .076,
      //             color: index == _page ? Colors.blueAccent : Colors.black38,
      //           ),
      //           SizedBox(height: size.width * .03),
      //         ],
      //       ),
      //     ),
      //   ),
      // )
    );
  }

  // List<IconData> listOfIcons = [
  //   Icons.home_rounded,
  //   Icons.filter_list,
  //   Icons.settings_rounded,
  //   Icons.notifications_rounded,
  // ];
}
