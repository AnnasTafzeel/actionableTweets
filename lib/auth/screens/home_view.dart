import 'package:actionable_tweets/auth/screens/about.dart';
import 'package:actionable_tweets/auth/screens/model.dart';
import 'package:actionable_tweets/auth/screens/signin.dart';
import 'package:actionable_tweets/auth/screens/signup.dart';
import "package:actionable_tweets/constants/constants.dart";
import 'package:actionable_tweets/auth/screens/filter_tweets.dart'; // Import FilterTweets screen
import 'package:actionable_tweets/auth/screens/savetweets.dart';
import 'package:actionable_tweets/auth/screens/notification.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shimmer/shimmer.dart';

class HomeView extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const HomeView(),
      );

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

List<Map<String, dynamic>> savedTweets = [];

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin<HomeView> {
  @override
  bool get wantKeepAlive => true;
  int _page = 0;
  final appBar = UIConstants.appBar();
  List<Widget> tweetsWidgets = [];
  Map<String, String> filters = {};
  List<Map<String, dynamic>> tweets = [];
  final List<Map<String, dynamic>> filteredTweets = [];
  final ScrollController _scrollController = ScrollController();
  bool isDashboardVisible = false;

  @override
  void initState() {
    super.initState();
    // Call the fetchTweets method in initState to fetch tweets when the screen loads
    fetchTweets({});
  }

  void toggleDashboard() {
    setState(() {
      isDashboardVisible = !isDashboardVisible;
    });
  }

  void onPageChange(int index) {
    setState(() {
      _page = index;
    });
  }

  //Function to show a snackbar message
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

//Function to save a tweet
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

  Widget _buildTweetWidget(Map<String, dynamic> tweet) {
    // final imageUrl = tweet['tweet_avatar'] ?? '';
    // // Check if the image URL is valid
    // final imageWidget = Uri.tryParse(imageUrl)?.isAbsolute == true
    //     ? ClipOval(
    //         child: Image.network(
    //           imageUrl,
    //           width: 30.0,
    //           height: 30.0,
    //         ),
    //       )
    //     : const SizedBox(); // If not, display an empty SizedBox
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
              // Wrap everything in a Row
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
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start, // Added
                    //   children: [
                    //     Flexible(
                    //       child: Text(
                    //         tweet['fullname'] ?? '',
                    //         style: const TextStyle(
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //         overflow: TextOverflow.ellipsis,
                    //       ),
                    //     ),
                    //     Text(
                    //       ' ${tweet['username'] ?? ''}',
                    //       style: const TextStyle(
                    //         color: Colors.grey,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Text(tweet['text'] ?? ''),
                    // Row(
                    //   children: [
                    //     SvgPicture.asset(AssetsConstants.retweetIcon),
                    //     //const Icon(Icons.repeat),
                    //     Text(' ${tweet['retweets'] ?? ''}'),
                    //     const SizedBox(width: 16.0),
                    //     SvgPicture.asset(AssetsConstants.commentIcon),
                    //     Text(' ${tweet['replies'] ?? ''}'),
                    //     const SizedBox(width: 16.0),
                    //     Expanded(
                    //       // Wrap the timestamp in Expanded
                    //       child: Row(
                    //         children: [
                    //           const Icon(Icons.access_time),
                    //           const SizedBox(width: 4.0),
                    //           Flexible(
                    //             // Wrap the timestamp in Flexible
                    //             child: Text(
                    //               '${tweet['timestamp'] ?? ''}',
                    //               overflow: TextOverflow
                    //                   .ellipsis, // Add ellipsis for long timestamps
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
              // Place the PopupMenuButton here
              PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: tweet, // Pass the tweet data (map) here
                      child: const Text('Save Tweet'),
                    ),
                  ];
                },
                onSelected: (value) {
                  // Handle the selected menu item
                  // ignore: unnecessary_type_check
                  if (value is Map<String, dynamic>) {
                    saveTweet(value);
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

  Future<void> fetchTweets(Map<String, String> filters) async {
    // const apiKey = 'apify_api_okBl2LfN6IM1SwXyUBQIHMZSQop2v017TZKJ';
    // const url =
    //     'https://api.apify.com/v2/datasets/4vMGvGxc9XmlYJx1K/items?token$apiKey';
    // final response = await http.get(Uri.parse(url));

    // if (response.statusCode == 200) {
    //   final jsonData = jsonDecode(response.body);

    //   if (jsonData is List) {
    //     tweets = jsonData.cast<Map<String, dynamic>>();
    final String csvString = await rootBundle.loadString('assets/dataset.csv');

    // Parse CSV data using csv package
    final List<List<dynamic>> csvList =
        const CsvToListConverter().convert(csvString);

    // Convert CSV list to a list of maps
    tweets = csvList.map((List<dynamic> row) {
      return {
        'text':
            row[0], // Replace with the actual column index for the tweet text
      };
    }).toList();
    setState(() {
      if (filters.isEmpty) {
        //tweetsWidgets.clear();
        tweetsWidgets = tweets.map((tweet) {
          return _buildTweetWidget(tweet);
        }).toList();
        // Debugging: Print the fetched tweets and applied filters
        //print('Fetched ${tweets.length} tweets with filters: $filters');
        // print(tweets.isNotEmpty ? tweets.first : 'No tweets available');
      } else {
        tweetsWidgets.clear();
        filteredTweets.clear();
        for (final tweet in tweets) {
          //final timestamp = tweet['timestamp'] ?? '';
          final fromDate = filters['fromDate'] ?? '';
          final toDate = filters['toDate'] ?? '';

          final hashtags = filters['hashtags']?.toLowerCase() ?? '';
          final keywords = filters['keywords']?.toLowerCase() ?? '';

          final containsHashtags = tweet['text']
              .toLowerCase()
              .contains(RegExp(hashtags.replaceAll('#', '')));

          final containsKeywords =
              tweet['text'].toLowerCase().contains(RegExp(keywords));
          if (kDebugMode) {
            print('Tweet: $tweet');
          }
          if (kDebugMode) {
            print(
                'Filter criteria - FromDate: $fromDate, ToDate: $toDate, Hashtags: $hashtags, Keywords: $keywords');
          }
          if (kDebugMode) {
            print(
                'Contains Hashtags: $containsHashtags, Contains Keywords: $containsKeywords');
          }

          if (containsHashtags == true || containsKeywords == true) {
            filteredTweets.add(tweet);
          }
          if (kDebugMode) {
            print('Filtered ${filteredTweets.length} tweets');
          }
          if (kDebugMode) {
            print('Filtered $filteredTweets tweets');
          }
        }
        tweetsWidgets.clear();
        tweetsWidgets.addAll(filteredTweets.map((tweet) {
          return _buildTweetWidget(tweet);
        }).toList());
      }
    });
  }

  void openFilterTweetsScreen() async {
    final Map<String, String> newFilters = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FilterTweets(
                filters: filters,
                tweets: tweets,
              )),
    );

// Debugging: Print the received filters
    if (kDebugMode) {
      print('Received filters: $newFilters');
    }
    // If filters are applied, update the state
    setState(() {
      filters = newFilters;
    });
    fetchTweets(filters);
  }

  void clearFilters() {
    setState(() {
      filters.clear();
      fetchTweets({});
    });
  }

  void openNotificationsScreen(List<Map<String, dynamic>> tweets) async {
    bool tweetsStructureValid = true;
    // Check the structure of each tweet in the list
    for (final tweet in tweets) {
      if (!tweet.containsKey('text')
          // ||
          //     !tweet.containsKey('timestamp') ||
          //     !tweet.containsKey('fullname') ||
          //     !tweet.containsKey('username')
          ) {
        // If a tweet is missing any of the required keys, set the flag to false
        if (kDebugMode) {
          print(tweets.isNotEmpty ? tweets.first : 'No tweets available');
        }
        tweetsStructureValid = false;
        // Exit the loop early, no need to check further
        break;
      }
    }

    if (tweetsStructureValid) {
      if (kDebugMode) {
        print(tweets.isNotEmpty ? tweets.first : 'No tweets available');
        print("Valid Tweet Structure");
      }
      // If tweet data structure is valid, show shimmer effect
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => NotificationActivity(
            tweets: tweets,
            filters: filters,
          ),
        ),
      );
    } else {
      if (kDebugMode) {
        print('Invalid tweet data structure');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        drawer: const CustomDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Actionable Tweets Feed",
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
              )),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  if (isDashboardVisible) const CustomDrawer(),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  // Check the scroll position and update the visibility of the "Fetch Tweets" button
                  return tweetsWidgets.isNotEmpty
                      ? tweetsWidgets[index]
                      : _buildShimmerEffect();
                },
                childCount: tweetsWidgets.isNotEmpty ? tweetsWidgets.length : 1,
              ),
            ),
          ],
          controller: _scrollController,
        ),
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
                    if (index >= 0 && index < 4) {
                      // Check if the index is within the valid range (0, 1, 2)
                      _page = index; // Update _page when a tab is tapped
                      if (_page == 1) {
                        openFilterTweetsScreen(); // Open filter screen when filter tab is tapped
                      } else if (_page == 2) {
                        // Navigating to the NotificationActivity
                      } else if (_page == 3) {
                        // Navigating to the NotificationActivity
                        openNotificationsScreen(tweets);
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
        ));
  }

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.filter_list,
    Icons.settings_rounded,
    Icons.notifications_rounded,
  ];
}

Widget _buildShimmerEffect() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Column(
      children: List.generate(
        5, // Adjust the number of shimmer items as needed
        (index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Adjust the shimmer layout based on your tweet widget structure
              Container(
                width: 30.0,
                height: 30.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 16.0,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      width: double.infinity,
                      height: 16.0,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      width: double.infinity,
                      height: 16.0,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        Container(
                          width: 20.0,
                          height: 20.0,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 16.0),
                        Container(
                          width: 20.0,
                          height: 20.0,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 16.0),
                        Container(
                          width: 20.0,
                          height: 20.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class CustomListTile extends StatelessWidget {
  final bool isCollapsed;
  final IconData icon;
  final String title;
  final IconData? doHaveMoreOptions;
  final int infoCount;
  final VoidCallback? onTap;

  const CustomListTile({
    Key? key,
    required this.isCollapsed,
    required this.icon,
    required this.title,
    this.doHaveMoreOptions,
    required this.infoCount,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: isCollapsed ? 300 : 80,
        height: 40,
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      icon,
                      color: Colors.white,
                    ),
                    if (infoCount > 0)
                      Positioned(
                        right: -5,
                        top: -5,
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (isCollapsed) const SizedBox(width: 10),
            if (isCollapsed)
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    if (infoCount > 0)
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 139, 167, 218),
                          ),
                          child: Center(
                            child: Text(
                              infoCount.toString(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            if (isCollapsed) const Spacer(),
            if (isCollapsed)
              Expanded(
                flex: 1,
                child: doHaveMoreOptions != null
                    ? IconButton(
                        icon: Icon(
                          doHaveMoreOptions,
                          color: Colors.white,
                          size: 12,
                        ),
                        onPressed: () {},
                      )
                    : const Center(),
              ),
          ],
        ),
      ),
    );
  }
}

class CustomDrawerHeader extends StatelessWidget {
  final bool isColapsed;

  const CustomDrawerHeader({
    Key? key,
    required this.isColapsed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: 60,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const FlutterLogo(size: 30),
          if (isColapsed) const SizedBox(width: 10),
          if (isColapsed)
            const Expanded(
              flex: 3,
              child: Text(
                'Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                maxLines: 1,
              ),
            ),
          if (isColapsed) const Spacer(),
          if (isColapsed)
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class BottomUserInfo extends StatelessWidget {
  final bool isCollapsed;

  const BottomUserInfo({
    Key? key,
    required this.isCollapsed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isCollapsed ? 70 : 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: isCollapsed
          ? Center(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset('assets/download.png',
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Annas',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'annas1@gmail.com',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const Signin(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.logout,
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child:
                          Image.asset('assets/download.png', fit: BoxFit.cover),
                    ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedContainer(
        curve: Curves.easeInOutCubic,
        duration: const Duration(milliseconds: 500),
        width: _isCollapsed ? 300 : 70,
        margin: const EdgeInsets.only(bottom: 10, top: 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: Color.fromRGBO(20, 20, 20, 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomDrawerHeader(isColapsed: _isCollapsed),
              const Divider(
                color: Colors.grey,
              ),
              //
              // ListTile(
              //   title: const Text('New Actionable Tweets'),
              //   onTap: () {
              //     // Navigate to the screen for new actionable tweets
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (context) => const HomeView(),
              //       ),
              //     );
              //   },
              // ),
              //   title: const Text('Saved Actionable Tweets'),
              //   onTap: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (context) =>
              //             SavedTweetsActivity(savedTweets: savedTweets),
              //       ),
              //     );
              //   },
              // ),
              // ListTile(
              //   title: const Text('MapView'),
              //   onTap: () {
              //     // Navigate to the map view screen
              //   },
              // ),
              // const Divider(),
              // ListTile(
              //   title: const Text('Help and Support'),
              //   onTap: () {
              //     // Navigate to the help and support screen
              //   },
              // ),
              // ListTile(
              //   title: const Text('Log Out'),
              //   onTap: () {
              //     // Navigate to the help and support screen
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (context) => const WelcomeScreen(),
              //       ),
              //     );
              //   },
              // ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.calendar_today,
                title: 'Predict Tweets',
                infoCount: 0,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const TweetList(),
                    ),
                  );
                },
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.bookmark,
                title: 'Bookmarks',
                infoCount: 0,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          SavedTweetsActivity(savedTweets: savedTweets),
                    ),
                  );
                },
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.message_rounded,
                title: 'About',
                infoCount: 0,
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.cloud,
                title: 'Help & Support',
                infoCount: 0,
                //doHaveMoreOptions: Icons.arrow_forward_ios,
              ),
              // CustomListTile(
              //   isCollapsed: _isCollapsed,
              //   icon: Icons.airplane_ticket,
              //   title: 'Flights',
              //   infoCount: 0,
              //   doHaveMoreOptions: Icons.arrow_forward_ios,
              // ),
              const Divider(color: Colors.grey),
              const Spacer(),
              // CustomListTile(
              //   isCollapsed: _isCollapsed,
              //   icon: Icons.notifications,
              //   title: 'Notifications',
              //   infoCount: 2,
              // ),
              // CustomListTile(
              //   isCollapsed: _isCollapsed,
              //   icon: Icons.settings,
              //   title: 'Settings',
              //   infoCount: 0,
              // ),
              // const SizedBox(height: 10),
              BottomUserInfo(isCollapsed: _isCollapsed),
              Align(
                alignment: _isCollapsed
                    ? Alignment.bottomRight
                    : Alignment.bottomCenter,
                child: IconButton(
                  splashColor: Colors.transparent,
                  icon: Icon(
                    _isCollapsed
                        ? Icons.arrow_back_ios
                        : Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                  onPressed: () {
                    setState(() {
                      _isCollapsed = !_isCollapsed;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
