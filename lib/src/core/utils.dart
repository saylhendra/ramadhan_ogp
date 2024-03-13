// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

/// Example event class.
class Event {
  final String title;
  const Event(this.title);
  @override
  String toString() => title;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

void toJsonFormatLogger(dynamic param) {
  JsonEncoder encoder = const JsonEncoder.withIndent('  ');
  encoder.convert(param);
}

String maskingContact(String value, String type) {
  String results = value;
  if (type == 'email') {
    results = maskingEmail(value);
  } else if (type == 'phone') {
    results = maskingPhone(value);
  }
  return results;
}

String maskingPhone(String paramPhone) {
  String results = paramPhone;
  if (results.length > 3) {
    String asterixChar = generateAsterix(results.length - 3);
    results = results.replaceRange(0, (results.length - 3), asterixChar);
  } else {
    results = '***???***';
  }
  return results;
}

String maskingEmail(String paramEmail) {
  String results = paramEmail;
  if (results.length > 3) {
    var emailName = results.split('@')[0];
    var emailDomain = results.split('@')[1];
    String asterixChar = generateAsterix(emailName.length - 3);
    results = '${emailName.replaceRange(3, (emailName.length), asterixChar)}@$emailDomain';
  } else {
    results = '***???***@***.***';
  }
  return results;
}

String generateAsterix(int length) {
  String hasil = '';
  for (int i = 0; i < length; i++) {
    hasil += '*';
  }
  return hasil;
}

String getBreadcrumb(String url) {
  return camelToSentence(url.split('/').last.replaceAll('-', ' '));
}

String camelToSentence(String text) {
  var result = text.replaceAll(RegExp(r'(?<!^)(?=[A-Z])'), r" ");
  var finalResult = result[0].toUpperCase() + result.substring(1);
  return finalResult;
}

String formattedListDays(List<String> days) {
  if (days.isEmpty) return '...';

  days.sort((a, b) => getDayIndex(a) - getDayIndex(b));

  if (days.length == 1) {
    return capitalize(days[0]);
  } else if (days.length == 2) {
    return '${capitalize(days[0])} and ${capitalize(days[1])}';
  } else {
    List<String> formattedDays = days.map((day) => capitalize(day)).toList();
    return formattedDays.join(', ');
  }
}

String capitalize(String word) {
  return word[0].toUpperCase() + word.substring(1);
}

int getDayIndex(String day) {
  List<String> orderedDays = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
  return orderedDays.indexOf(day);
}

String phoneNumberNonZero(String paramPhone, String paramCountryCode) {
  var phone = paramPhone.replaceAll(paramCountryCode, '').replaceAll('-', '').trim();
  var firstNonZero = phone.replaceFirstMapped(RegExp(r'^0+'), (match) => '');
  return firstNonZero.trim();
}

String getTimeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);
  if (difference.inSeconds < 60) {
    return '${difference.inSeconds}s';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}m';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}h';
  } else if (difference.inDays < 7) {
    return '${difference.inDays}d';
  } else if ((difference.inDays > 7)) {
    final difference = now.difference(dateTime);
    return '${(difference.inDays / 7).floor()} w';
  } else {
    final formatter = DateFormat.yMMMd();
    return formatter.format(dateTime);
  }
}

int getTimeAgoInt(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);
  if (difference.inSeconds < 60) {
    return difference.inSeconds;
  } else if (difference.inMinutes < 60) {
    return difference.inMinutes;
  } else if (difference.inHours < 24) {
    return difference.inHours;
  } else if (difference.inDays < 7) {
    return difference.inDays;
  } else if ((difference.inDays > 7)) {
    final difference = now.difference(dateTime);
    return (difference.inDays / 7).floor();
  } else {
    final formatter = DateFormat.yMMMd();
    return formatter.format(dateTime) as int;
  }
}

String getTwoLetters(String myFormListData) {
  String twoLetters = '';
  if (myFormListData.split(" ").length > 1) {
    twoLetters = myFormListData.split(" ").map((e) => e[0]).join().substring(0, 2).toUpperCase();
  } else if (myFormListData.split(" ").length == 1) {
    twoLetters = myFormListData.substring(0, 2).toUpperCase();
  } else {
    twoLetters = myFormListData.substring(0, 2).toUpperCase();
  }
  return twoLetters;
}

double defaultBreakpoint() {
  return 1400;
}

String convertBackDateFormat(String? inputDate) {
  if (inputDate == null || inputDate.isEmpty) {
    return '';
  } else {
    final inputFormat = DateFormat('dd MMM yyyy');
    final outputFormat = DateFormat('yyyy-MM-dd');
    final date = inputFormat.parse(inputDate);
    final outputDate = outputFormat.format(date);

    return outputDate;
  }
}

String convertDateFormat(String? inputDate) {
  if (inputDate == null || inputDate.isEmpty) {
    return '';
  } else {
    final inputFormat = DateFormat('yyyy-MM-dd');
    final outputFormat = DateFormat('dd MMM yyyy');
    final date = inputFormat.parse(inputDate);
    final outputDate = outputFormat.format(date);
    return outputDate;
  }
}

String formatDateForExcel(DateTime date) {
  return DateFormat('dd MMM yyyy').format(date);
}

//indonesia thounsad separator
String thousandFormatNumber(int number) {
  return NumberFormat.decimalPattern('id').format(number);
}

//indonesia local date format with time zone
String simpleDateFormat(String? date) {
  return DateFormat('dd MMM yyyy').format(DateTime.parse(date ?? ''));
}

String simpleDateTimeFormat(String? date) {
  return DateFormat('dd MMM yyyy | HH:mm:ss').format(DateTime.parse(date ?? ''));
}

Future<void> launchInBrowser(String link) async {
  Uri url = Uri.parse(link);
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $url');
  }
}

Future<void> launchInWebViewOrVC(String link) async {
  Uri url = Uri.parse(link);
  if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
    throw Exception('Could not launch $url');
  }
}

Future<void> launchAsInAppWebViewWithCustomHeaders(String link) async {
  Uri url = Uri.parse(link);
  if (!await launchUrl(
    url,
    mode: LaunchMode.inAppWebView,
    webViewConfiguration: const WebViewConfiguration(headers: <String, String>{'my_header_key': 'my_header_value'}),
  )) {
    throw Exception('Could not launch $url');
  }
}

Future<void> launchInWebViewWithoutJavaScript(String link) async {
  Uri url = Uri.parse(link);
  if (!await launchUrl(
    url,
    mode: LaunchMode.inAppWebView,
    webViewConfiguration: const WebViewConfiguration(enableJavaScript: false),
  )) {
    throw Exception('Could not launch $url');
  }
}

Future<void> launchInWebViewWithoutDomStorage(String link) async {
  Uri url = Uri.parse(link);
  if (!await launchUrl(
    url,
    mode: LaunchMode.inAppWebView,
    webViewConfiguration: const WebViewConfiguration(enableDomStorage: false),
  )) {
    throw Exception('Could not launch $url');
  }
}

Future<void> launchUniversalLinkIos(String link) async {
  Uri url = Uri.parse(link);
  final bool nativeAppLaunchSucceeded = await launchUrl(
    url,
    mode: LaunchMode.externalNonBrowserApplication,
  );
  if (!nativeAppLaunchSucceeded) {
    await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
    );
  }
}

Widget launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
  if (snapshot.hasError) {
    return Text('Error: ${snapshot.error}');
  } else {
    return const Text('');
  }
}

//create function generate uuid
String generateUUID() {
  var uuid = const Uuid();
  return uuid.v4();
}

String getBase64FormateFile(File file) {
  List<int> fileInByte = file.readAsBytesSync();
  String fileInBase64 = base64Encode(fileInByte);
  return fileInBase64;
}
