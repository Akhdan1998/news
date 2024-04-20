import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:news/model.dart';
import 'package:url_launcher/url_launcher.dart';

class newsDetails extends StatefulWidget {
  // News berita;
  // newsDetails({required this.berita});
  final RxList<News> dataList;
  final String author;
  final int index;
  newsDetails({required this.dataList, required this.author, required this.index,});

  @override
  State<newsDetails> createState() => _newsDetailsState();
}

class _newsDetailsState extends State<newsDetails> {
  // Future<void> _launchUrl() async {
  //   var wkwk = Uri.parse(widget.berita.url ?? '');
  //   if (!await launchUrl(wkwk)) {
  //     throw Exception('Could not launch $wkwk');
  //   }
  // }

  Future<void> _launchUrl(int index) async {
    // Pastikan index berada dalam rentang yang valid
    if (index >= 0 && index < widget.dataList.length) {
      var wkwk = Uri.parse(widget.dataList[index].url.toString());
      if (!await launchUrl(wkwk)) {
        throw Exception('Could not launch $wkwk');
      }
    } else {
      throw Exception('Invalid index: $index');
    }
  }

  @override
  Widget build(BuildContext context) {
    // DateTime haha = DateFormat('yyyy-MM-ddTHH:mm:ssZ').parse(widget.berita.publishedAt.toString());
    DateTime haha = DateFormat('yyyy-MM-ddTHH:mm:ssZ').parse(widget.dataList[widget.index].publishedAt.toString());
    String date = DateFormat('dd MMMM yyy').format(haha);
    String time = DateFormat('HH:mm:ss').format(haha);
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   automaticallyImplyLeading: false,
      //   leading: IconButton(
      //     onPressed: () {
      //       Get.back();
      //     },
      //     icon: Icon(Icons.arrow_back),
      //   ),
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   centerTitle: false,
      //   title: Text(
      //     widget.berita.author ?? '',
      //     style: TextStyle(fontSize: 17),
      //   ),
      // ),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: false,
        title: Text(
          widget.author,
          style: TextStyle(fontSize: 17),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container(
            //   height: 150,
            //   width: MediaQuery.of(context).size.width,
            //   decoration: BoxDecoration(
            //     color: Colors.grey,
            //     image: widget.berita.urlToImage.toString() != null
            //         ? DecorationImage(
            //       image:
            //       NetworkImage(widget.berita.urlToImage.toString()),
            //       fit: BoxFit.cover,
            //     )
            //         : null,
            //   ),
            // ),
            Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey,
                image: widget.dataList[widget.index].urlToImage.toString() != null
                    ? DecorationImage(
                  image:
                  NetworkImage(widget.dataList[widget.index].urlToImage.toString()),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.dataList[widget.index].title ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        widget.dataList[widget.index].source!.name ?? '',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        ' - $date',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.dataList[widget.index].content ?? '',
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.dataList[widget.index].description ?? '',
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(height: 5),
                  GestureDetector(
                      onTap: () {
                        _launchUrl(widget.index);
                      },
                      child: Container(
                        color: Colors.white,
                        child: Text(
                          widget.dataList[widget.index].url ?? '',
                          style: TextStyle(color: Colors.blue),
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
