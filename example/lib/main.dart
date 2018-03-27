import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hockeyapp/flutter_hockeyapp.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  TextEditingController controller = TextEditingController();

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterHockeyapp.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Plugin example app'),
        ),
        body: new Center(
          child: new Column(
            children: <Widget>[
              new Text('Running on: $_platformVersion\n'),
              new RaisedButton(
                  onPressed: () async {
                    await FlutterHockeyapp.configure();
                  },
                  child: new Text("Configure HockeyApp")),
              new RaisedButton(
                  onPressed: () async {
                    await FlutterHockeyapp.showFeedback();
                  },
                  child: new Text("Show Feedback")),
              new RaisedButton(
                  onPressed: () async {
                    await FlutterHockeyapp.checkForUpdates();
                  },
                  child: new Text("Check for updates")),
              new TextField(controller: controller),
              new RaisedButton(
                  onPressed: () async {
                    if (controller.text.isNotEmpty)
                      await FlutterHockeyapp.trackEvent(controller.text);
                  },
                  child: new Text("Track event"))
            ],
          ),
        ),
      ),
    );
  }
}