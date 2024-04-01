import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  late SharedPreferences _prefs;
  String selectedLanguage = '';

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  _loadSelectedLanguage() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = _prefs.getString('selectedLanguage') ?? 'id';
    });
  }

  _saveSelectedLanguage(String languageCode) async {
    setState(() {
      selectedLanguage = languageCode;
    });
    await _prefs.setString('selectedLanguage', languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: false,
        title: Text('subtitle').tr(),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            buildLanguageOption('Indonesia', 'id', 'ID'),
            SizedBox(height: 20),
            buildLanguageOption('Korea', 'ko', 'KR'),
          ],
        ),
      ),
    );
  }

  Widget buildLanguageOption(
      String languageName, String languageCode, String countryCode) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(languageName),
        GestureDetector(
          onTap: () {
            _saveSelectedLanguage(languageCode);
            context.setLocale(Locale(languageCode, countryCode));
          },
          child: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              color: (selectedLanguage == languageCode)
                  ? Theme.of(context)
                      .colorScheme
                      .primary // Change to your desired color
                  : Colors.white,
              border: Border.all(width: 1),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
