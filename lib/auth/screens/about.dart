import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Project'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'The world is not prone to disasters whether they are in the form of floods, earthquakes, wildfires, or in the form of unnatural disasters such as Covid-19, the Chornobyl disaster, crime/terrorism, etc. they are bound to happen. It is out of the reach of humankind to control them or to limit their occurrence. The only thing we can do is to minimize the effects of disasters through disaster management.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Disaster Management:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Text(
              'To do that, we must first understand what disaster management actually means. As we know, disasters have affected humankind since the beginning of time. In response, people at an individual level or in the form of communities have made many efforts to reduce the impact of a disaster, developing measures to address the initial impact, as well as post-disaster response and recovery. Regardless of the adopted approach, all of these efforts have only one common goal: disaster management.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Expanded(
                child: Text(
              'Project Overview:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            )),
            Expanded(
                child: Text(
              'In this final year project, my partner and I aim to build an application that will provide a crucial solution to the problem of disaster management with the help of Twitter data. As the title suggests, this project aims to build a system capable of supporting decision-makers to identify and detect actionable tweets during a disaster.',
              style: TextStyle(fontSize: 16.0),
            )),
            SizedBox(height: 16.0),
            Expanded(
                child: Text(
              'What is an Actionable Tweet?',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            )),
            Text(
              'Let’s take an example of three tweets related to a disaster, one tweet is telling the readers about the affected areas, the number of casualties, total damages, etc. the second tweet is about a famous personality sympathizing with the affected community and the third tweet is about a person asking for help who is stuck in a building surrounded by flood water. At this point, I think it is pretty evident that the third tweet is an actionable tweet.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Challenges and Solutions:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Text(
              'The problem with actionable tweets is that they don’t get many likes or retweets, so they are really far below in the Twitter feed. So, it is a huge challenge to implement methods to detect such tweets. To implement such methods machine learning and natural language processing techniques will be used in order to test and train a model capable of detecting actionable tweets.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Expanded(
                child: Text(
              'Mobile Application:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            )),
            Expanded(
                child: Text(
              'A mobile application will be developed using Flutter framework to make the system user-friendly and easily accessible. The mobile application will consist of a tweet feed where all the actionable tweets will be displayed. Similarly, if an actionable tweet contains information about its location, then the location of such tweets will be displayed on a map view. In this way, emergency responders and rescue teams can act quickly to locate the affected individuals and provide the necessary aid.',
              style: TextStyle(fontSize: 16.0),
            )),
          ],
        ),
      ),
    );
  }
}
