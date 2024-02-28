//import 'package:actionable_tweets/constants/assetsconstants.dart';
import 'package:actionable_tweets/auth/screens/home_view.dart';
import 'package:actionable_tweets/auth/screens/notification.dart';
import 'package:flutter/foundation.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class FilterTweets extends StatefulWidget {
  final Map<String, String> filters;
  final List<Map<String, dynamic>> tweets;

  const FilterTweets({super.key, required this.filters, required this.tweets});

  @override
  // ignore: library_private_types_in_public_api
  _FilterTweetsState createState() => _FilterTweetsState();
}

class _FilterTweetsState extends State<FilterTweets> {
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController hashtagsController = TextEditingController();
  TextEditingController keywordsController = TextEditingController();
  int _page = 1;

  void onPageChange(int index) {
    setState(() {
      _page = index;
    });
  }

  void applyFilters() {
    // Get the filtering criteria from the controllers
    String fromDate = fromDateController.text;
    String toDate = toDateController.text;
    String hashtags = hashtagsController.text;
    String keywords = keywordsController.text;

    // Combine new filters with existing filters and pass them back
    widget.filters.addAll({
      'fromDate': fromDate,
      'toDate': toDate,
      'hashtags': hashtags,
      'keywords': keywords,
    });

    // Debugging: Print the updated filters
    if (kDebugMode) {
      print('Applied filters: ${widget.filters}');
    }

    // Pass the updated filters back to HomeView
    Navigator.pop(context, widget.filters);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Filter Tweets',
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 30.0),
              TextField(
                controller: fromDateController,
                decoration: const InputDecoration(labelText: 'From Date'),
              ),
              TextField(
                controller: toDateController,
                decoration: const InputDecoration(labelText: 'To Date'),
              ),
              TextField(
                controller: hashtagsController,
                decoration: const InputDecoration(labelText: 'Hashtags'),
              ),
              TextField(
                controller: keywordsController,
                decoration: const InputDecoration(labelText: 'Keywords'),
              ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
                  // Debugging: Print button pressed
                  if (kDebugMode) {
                    print('Apply Filters button pressed');
                  }
                  applyFilters();
                },
                child: const Text('Apply Filters'),
              ),
            ],
          ),
        ),
        // bottomNavigationBar: CupertinoTabBar(
        //   currentIndex: _page,
        //   onTap: (index) {
        //     setState(() {
        //       _page = index;
        //       if (_page == 0) {
        //         // Navigate to HomeView when first icon is tapped
        //         print('Navigating to HomeView');
        //         Navigator.of(context).pushReplacement(
        //           MaterialPageRoute(builder: (context) => const HomeView()),
        //         );
        //       } else if (_page == 2) {
        //         // Navigate to NotificationActivity when third icon is tapped
        //         print('Navigating to NotificationActivity');
        //         Navigator.of(context).push(
        //           MaterialPageRoute(
        //             builder: (context) => NotificationActivity(
        //               tweets: widget.tweets,
        //               filters: widget.filters,
        //             ),
        //           ),
        //         );
        //       }
        //     });
        //   },
        //   backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        //   items: [
        //     BottomNavigationBarItem(
        //       icon: SvgPicture.asset(
        //         _page == 0
        //             ? AssetsConstants.homeFilledIcon
        //             : AssetsConstants.homeOutlinedIcon,
        //         color: const Color.fromARGB(255, 0, 0, 0),
        //       ),
        //     ),
        //     BottomNavigationBarItem(
        //       icon: SvgPicture.asset(
        //         _page == 1
        //             ? AssetsConstants.filterFilledIcon
        //             : AssetsConstants.filterOutlinedIcon,
        //         height: 25,
        //         width: 25,
        //         fit: BoxFit.scaleDown,
        //         color: const Color.fromARGB(255, 0, 0, 0),
        //       ),
        //     ),
        //     BottomNavigationBarItem(
        //       icon: SvgPicture.asset(
        //         _page == 2
        //             ? AssetsConstants.notifFilledIcon
        //             : AssetsConstants.notifOutlinedIcon,
        //         color: const Color.fromARGB(255, 0, 0, 0),
        //       ),
        //     ),
        //   ],
        // ),
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
                    //_page = index;
                    if (index >= 0 && index < 4) {
                      // Check if the index is within the valid range (0, 1, 2)
                      _page = index; // Update _page when a tab is tapped
                      if (_page == 0) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) =>
                                const HomeView())); // Open filter screen when filter tab is tapped
                      } else if (_page == 3) {
                        // Navigating to the NotificationActivity
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NotificationActivity(
                              tweets: widget.tweets,
                              filters: widget.filters,
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
        ));
  }

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.filter_list,
    Icons.settings_rounded,
    Icons.notifications_rounded,
  ];
}
