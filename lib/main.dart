import 'package:flutter/material.dart';
import 'package:flutter_weather/Weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Wetter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const APIKEY = "682baa9a0a0f2605d6402fdea1168837";

  Weather _data;
  bool _isLoading;

  void loadWeather({double lat, double lng}) async {
    setState(() {
      _isLoading = true;
    });
    if (lat == null || lng == null) {
      Position position = await _determinePosition();
      lat = position.latitude;
      lng = position.longitude;
    }
    final url =
        "https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lng&APPID=$APIKEY&units=metric";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Weather weather = Weather.fromJson(response.body);
      print(weather);
      setState(() {
        _data = weather;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception(
          'Failed to load weather - ${response.statusCode} - ${response.toString()}');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        forceAndroidLocationManager: true);
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    initializeDateFormatting('de');

    loadWeather();
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    if (!_isLoading) {
      children.addAll(
        <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Icon(
                      _data.currentWeather.weatherCondition.icon,
                      size: 72,
                    ),
                    Text(
                      _data.currentWeather.weatherCondition.name,
                      style: Theme.of(context).textTheme.headline6,
                    )
                  ],
                ),
                Text(
                  _data.currentWeather.temperatur.round().toString() + " °C",
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(MdiIcons.weatherSunsetUp),
                ),
                Text(
                  DateFormat('Hm', 'de').format(_data.currentWeather.sunrise),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(MdiIcons.weatherSunsetDown),
                ),
                Text(
                  DateFormat('Hm', 'de').format(_data.currentWeather.sunset),
                ),
                Spacer(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Divider(),
          ),
        ],
      );
      children.addAll(
        _data.daily
            .map(
              (e) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Spacer(),
                        Text(
                          DateFormat('EE dd.MM', 'de').format(e.date),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(MdiIcons.weatherSunsetUp),
                        ),
                        Text(
                          DateFormat('Hm', 'de').format(e.sunrise),
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(MdiIcons.weatherSunsetDown),
                        ),
                        Text(
                          DateFormat('Hm', 'de').format(e.sunset),
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Spacer(),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(
                                e.weatherCondition.icon,
                                size: 32,
                              ),
                              Text(
                                e.weatherCondition.name,
                                style: Theme.of(context).textTheme.subtitle2,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_upward,
                              ),
                              Text(
                                e.temperaturMax.round().toString() + " °C",
                                style: Theme.of(context).textTheme.subtitle2,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_downward,
                              ),
                              Text(
                                e.temperaturMin.round().toString() + " °C",
                                style: Theme.of(context).textTheme.subtitle2,
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
            .toList(),
      );
      children.add(
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Divider(),
        ),
      );
      _data.hourly.asMap().forEach((i, e) {
        if (i % 3 == 0 && i <= _data.hourly.length - 3)
          children.add(Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      DateFormat("EE HH 'Uhr'", 'de')
                          .format(_data.hourly[i].date),
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Icon(_data.hourly[i].weatherCondition.icon),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            _data.hourly[i].temperatur.round().toString() +
                                " °C",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _data.hourly[i].weatherCondition.name,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      DateFormat("EE HH 'Uhr'", 'de')
                          .format(_data.hourly[i + 1].date),
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child:
                              Icon(_data.hourly[i + 1].weatherCondition.icon),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            _data.hourly[i + 1].temperatur.round().toString() +
                                " °C",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _data.hourly[i + 1].weatherCondition.name,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      DateFormat("EE HH 'Uhr'", 'de')
                          .format(_data.hourly[i + 2].date),
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child:
                              Icon(_data.hourly[i + 2].weatherCondition.icon),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            _data.hourly[i + 2].temperatur.round().toString() +
                                " °C",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _data.hourly[i + 2].weatherCondition.name,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ));
      });
      children.addAll(_data.hourly
          .map(
            (e) => Row(
              children: [
                Column(
                  children: [],
                )
              ],
            ),
          )
          .toList());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : ListView(children: children),
      ),
      floatingActionButton: IconButton(
        icon: Icon(Icons.refresh),
        onPressed: () => loadWeather(),
      ),
    );
  }

  String parseDate(DateTime date,
      {bool weekday, bool time, bool dayAndMonth, bool year}) {
    String res = "";
    if (weekday ?? false) res = res + DateFormat('EE', 'de').format(date);
    if (dayAndMonth ?? false)
      res = res +
          date.day.toString().padLeft(2, '0') +
          "." +
          date.month.toString().padLeft(2, '0');
    if (year ?? false) res = res + date.year.toString();
    if (time ?? false) res = res + 'time';
    return res;
  }
}
