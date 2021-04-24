import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Weather {
  CurrentWeather currentWeather;
  List<Daily> daily;
  List<Hourly> hourly;
  Weather({
    this.currentWeather,
    this.daily,
    this.hourly,
  });

  Weather copyWith({
    CurrentWeather currentWeather,
    List<Daily> daily,
    Hourly hourly,
  }) {
    return Weather(
      currentWeather: currentWeather ?? this.currentWeather,
      daily: daily ?? this.daily,
      hourly: hourly ?? this.hourly,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currentWeather': currentWeather.toMap(),
      'daily': daily?.map((x) => x.toMap())?.toList(),
      'hourly': hourly?.map((x) => x.toMap())?.toList(),
    };
  }

  factory Weather.fromMap(Map<String, dynamic> map) {
    return Weather(
      currentWeather: CurrentWeather.fromMap(map['current']),
      daily: List<Daily>.from(map['daily']?.map((x) => Daily.fromMap(x))),
      hourly: List<Hourly>.from(map['hourly']?.map((x) => Hourly.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Weather.fromJson(String source) =>
      Weather.fromMap(json.decode(source));

  @override
  String toString() =>
      'Weather(currentWeather: $currentWeather, daily: $daily, hourly: $hourly)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Weather &&
        other.currentWeather == currentWeather &&
        listEquals(other.daily, daily) &&
        other.hourly == hourly;
  }

  @override
  int get hashCode =>
      currentWeather.hashCode ^ daily.hashCode ^ hourly.hashCode;
}

class CurrentWeather {
  DateTime date;
  DateTime sunrise;
  DateTime sunset;
  double temperatur;
  WeatherConditions weatherCondition;
  CurrentWeather({
    this.date,
    this.sunrise,
    this.sunset,
    this.temperatur,
    this.weatherCondition,
  });

  CurrentWeather copyWith({
    DateTime date,
    DateTime sunrise,
    DateTime sunset,
    double temperatur,
    WeatherConditions weatherCondition,
  }) {
    return CurrentWeather(
      date: date ?? this.date,
      sunrise: sunrise ?? this.sunrise,
      sunset: sunset ?? this.sunset,
      temperatur: temperatur ?? this.temperatur,
      weatherCondition: weatherCondition ?? this.weatherCondition,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.millisecondsSinceEpoch,
      'sunrise': sunrise.millisecondsSinceEpoch,
      'sunset': sunset.millisecondsSinceEpoch,
      'temperatur': temperatur,
      'weatherCondition': weatherCondition.toString(),
    };
  }

  factory CurrentWeather.fromMap(Map<String, dynamic> map) {
    return CurrentWeather(
      date: DateTime.fromMillisecondsSinceEpoch(map['dt'] * 1000),
      sunrise: DateTime.fromMillisecondsSinceEpoch(map['sunrise'] * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch(map['sunset'] * 1000),
      temperatur: map['temp'].toDouble(),
      weatherCondition: WeatherConditionsExtension.fromString(
          map['weather'][0]['main'].toLowerCase()),
    );
  }

  String toJson() => json.encode(toMap());

  factory CurrentWeather.fromJson(String source) =>
      CurrentWeather.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CurrentWeather(date: $date, sunrise: $sunrise, sunset: $sunset, temperatur: $temperatur, weatherCondition: $weatherCondition)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CurrentWeather &&
        other.date == date &&
        other.sunrise == sunrise &&
        other.sunset == sunset &&
        other.temperatur == temperatur &&
        other.weatherCondition == weatherCondition;
  }

  @override
  int get hashCode {
    return date.hashCode ^
        sunrise.hashCode ^
        sunset.hashCode ^
        temperatur.hashCode ^
        weatherCondition.hashCode;
  }
}

class Daily {
  DateTime date;
  DateTime sunrise;
  DateTime sunset;
  double temperaturMax;
  double temperaturMin;
  WeatherConditions weatherCondition;
  Daily({
    this.date,
    this.sunrise,
    this.sunset,
    this.temperaturMax,
    this.temperaturMin,
    this.weatherCondition,
  });

  Daily copyWith({
    DateTime date,
    DateTime sunrise,
    DateTime sunset,
    double temperaturMax,
    double temperaturMin,
    WeatherConditions weatherCondition,
  }) {
    return Daily(
      date: date ?? this.date,
      sunrise: sunrise ?? this.sunrise,
      sunset: sunset ?? this.sunset,
      temperaturMax: temperaturMax ?? this.temperaturMax,
      temperaturMin: temperaturMin ?? this.temperaturMin,
      weatherCondition: weatherCondition ?? this.weatherCondition,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.millisecondsSinceEpoch,
      'sunrise': sunrise.millisecondsSinceEpoch,
      'sunset': sunset.millisecondsSinceEpoch,
      'temperaturMax': temperaturMax,
      'temperaturMin': temperaturMin,
      'weatherCondition': weatherCondition.toString(),
    };
  }

  factory Daily.fromMap(Map<String, dynamic> map) {
    return Daily(
      date: DateTime.fromMillisecondsSinceEpoch(map['dt'] * 1000),
      sunrise: DateTime.fromMillisecondsSinceEpoch(map['sunrise'] * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch(map['sunset'] * 1000),
      temperaturMax: map['temp']['max'].toDouble(),
      temperaturMin: map['temp']['min'].toDouble(),
      weatherCondition: WeatherConditionsExtension.fromString(
          map['weather'][0]['main'].toLowerCase()),
    );
  }

  String toJson() => json.encode(toMap());

  factory Daily.fromJson(String source) => Daily.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Daily(date: $date, sunrise: $sunrise, sunset: $sunset, temperaturMax: $temperaturMax, temperaturMin: $temperaturMin, weatherCondition: $weatherCondition)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Daily &&
        other.date == date &&
        other.sunrise == sunrise &&
        other.sunset == sunset &&
        other.temperaturMax == temperaturMax &&
        other.temperaturMin == temperaturMin &&
        other.weatherCondition == weatherCondition;
  }

  @override
  int get hashCode {
    return date.hashCode ^
        sunrise.hashCode ^
        sunset.hashCode ^
        temperaturMax.hashCode ^
        temperaturMin.hashCode ^
        weatherCondition.hashCode;
  }
}

class Hourly {
  DateTime date;
  double temperatur;
  WeatherConditions weatherCondition;
  Hourly({
    this.date,
    this.temperatur,
    this.weatherCondition,
  });

  Hourly copyWith({
    DateTime date,
    double temperatur,
    WeatherConditions weatherCondition,
  }) {
    return Hourly(
      date: date ?? this.date,
      temperatur: temperatur ?? this.temperatur,
      weatherCondition: weatherCondition ?? this.weatherCondition,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.millisecondsSinceEpoch,
      'temperatur': temperatur,
      'weatherCondition': weatherCondition.toString(),
    };
  }

  factory Hourly.fromMap(Map<String, dynamic> map) {
    return Hourly(
      date: DateTime.fromMillisecondsSinceEpoch(map['dt'] * 1000),
      temperatur: map['temp'].toDouble(),
      weatherCondition: WeatherConditionsExtension.fromString(
          map['weather'][0]['main'].toLowerCase()),
    );
  }

  String toJson() => json.encode(toMap());

  factory Hourly.fromJson(String source) => Hourly.fromMap(json.decode(source));

  @override
  String toString() =>
      'Hourly(date: $date, temperatur: $temperatur, weatherCondition: $weatherCondition)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Hourly &&
        other.date == date &&
        other.temperatur == temperatur &&
        other.weatherCondition == weatherCondition;
  }

  @override
  int get hashCode =>
      date.hashCode ^ temperatur.hashCode ^ weatherCondition.hashCode;
}

enum WeatherConditions {
  rain,
  clear,
  thunderstorm,
  clouds,
  snow,
  drizzle,
  haze,
  mist,
}

extension WeatherConditionsExtension on WeatherConditions {
  String get name {
    switch (this) {
      case WeatherConditions.rain:
        return "Regen";
      case WeatherConditions.clear:
        return "Sonnig";
      case WeatherConditions.thunderstorm:
        return "Gewitter";
      case WeatherConditions.clouds:
        return "Bewölkt";
      case WeatherConditions.snow:
        return "Schnee";
      case WeatherConditions.drizzle:
        return "Niesel";
      case WeatherConditions.haze:
        return "Niesel";
      case WeatherConditions.mist:
        return "Nebel";
      default:
        return "Wetter nicht gefunden";
    }
  }

  IconData get icon {
    switch (this) {
      case WeatherConditions.rain:
        return MdiIcons.weatherPouring;
      case WeatherConditions.clear:
        return MdiIcons.weatherSunny;
      case WeatherConditions.thunderstorm:
        return MdiIcons.weatherLightning;
      case WeatherConditions.clouds:
        return MdiIcons.weatherCloudy;
      case WeatherConditions.snow:
        return MdiIcons.weatherSnowy;
      case WeatherConditions.drizzle:
        return MdiIcons.weatherRainy;
      case WeatherConditions.haze:
        return MdiIcons.weatherRainy;
      case WeatherConditions.mist:
        return MdiIcons.weatherFog;
      default:
        return MdiIcons.alert;
    }
  }

  static WeatherConditions fromString(String string) =>
      WeatherConditions.values.firstWhere(
        (e) => e.toString().split('.').last == string,
        orElse: () => null,
      );
}
