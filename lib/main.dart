import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:news/news_cubit.dart';
import 'package:news/news_state.dart';
import 'package:news/setting.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';
import 'model.dart';
import 'newsDetail.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('id', 'ID'),
        Locale('ko', 'KR'),
      ],
      path: 'assets/translations',
      startLocale: const Locale('id', 'ID'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NewsCubit()),
      ],
      child: GetMaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RxList<News> dataList = <News>[].obs;

  @override
  void initState() {
    super.initState();
    context.read<NewsCubit>().getNews();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      var response = await http.get(Uri.parse(
          'https://newsapi.org/v2/everything?q=apple&from=2024-03-31&to=2024-03-31&sortBy=popularity&apiKey=1b01c8e9ec3249f992946815df9de69f'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<News> value = (data['articles'] as List).map((e) => News.fromJson(e)).toList();

        setState(() {
          dataList.assignAll(value);
        });
      } else {
        print('Gagal mengambil data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('title').tr(),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(Setting());
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: dataList.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(newsDetails(dataList: dataList, author: dataList[index].author.toString(), index: index,));
                    },
                    child: Container(
                      // padding: EdgeInsets.only(left: 15, right: 15),
                      // width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 55,
                                width: 55,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  image: dataList[index].urlToImage != null
                                      ? DecorationImage(
                                          image: NetworkImage(dataList[index]
                                              .urlToImage
                                              .toString()),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dataList[index].author.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width - 95,
                                    child: Text(
                                      dataList[index].title.toString(),
                                      style: TextStyle(
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      // body: SingleChildScrollView(
      //   child: Container(
      //     padding: EdgeInsets.all(10),
      //     child: BlocBuilder<NewsCubit, NewsState>(builder: (context, state) {
      //       if (state is NewsLoaded) {
      //         if (state.news != null && state.news!.isNotEmpty) {
      //           return Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: state.news!
      //                 .map(
      //                   (e) => GestureDetector(
      //                     onTap: () {
      //                       Get.to(newsDetails(e));
      //                     },
      //                     child: Column(
      //                       children: [
      //                         Container(
      //                           padding: EdgeInsets.all(5),
      //                           width: MediaQuery.of(context).size.width,
      //                           color: Colors.white,
      //                           child: Row(
      //                             crossAxisAlignment: CrossAxisAlignment.start,
      //                             children: [
      //                               Container(
      //                                 height: 55,
      //                                 width: 55,
      //                                 decoration: BoxDecoration(
      //                                   color: Colors.grey,
      //                                   image: e.urlToImage != null
      //                                       ? DecorationImage(
      //                                           image: NetworkImage(
      //                                               e.urlToImage.toString()),
      //                                           fit: BoxFit.cover,
      //                                         )
      //                                       : null,
      //                                 ),
      //                               ),
      //                               SizedBox(width: 10),
      //                               Column(
      //                                 crossAxisAlignment:
      //                                     CrossAxisAlignment.start,
      //                                 children: [
      //                                   Container(
      //                                     width: MediaQuery.of(context)
      //                                             .size
      //                                             .width -
      //                                         95,
      //                                     child: Text(
      //                                       e.author.toString(),
      //                                       style: TextStyle(
      //                                         fontWeight: FontWeight.bold,
      //                                         fontSize: 12,
      //                                       ),
      //                                     ),
      //                                   ),
      //                                   Container(
      //                                     width: MediaQuery.of(context)
      //                                             .size
      //                                             .width -
      //                                         95,
      //                                     child: Text(
      //                                       e.title.toString(),
      //                                       style: TextStyle(
      //                                         fontSize: 11,
      //                                       ),
      //                                     ),
      //                                   ),
      //                                 ],
      //                               ),
      //                             ],
      //                           ),
      //                         ),
      //                         Divider(),
      //                       ],
      //                     ),
      //                   ),
      //                 )
      //                 .toList(),
      //           );
      //         } else {
      //           return Center(
      //             child: Text("No news available"),
      //           );
      //         }
      //       } else {
      //         return Center(
      //           child: CircularProgressIndicator(),
      //         );
      //       }
      //     }),
      //   ),
      // ),
    );
  }
}
