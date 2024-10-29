import 'package:flutter/material.dart';
import 'package:morama/data/index.dart';

class MangaDiscoverWidget extends StatefulWidget {
  final Map<String, dynamic>? params;
  final MangaController controller;
  final String title;

  const MangaDiscoverWidget({
    super.key,
    this.params,
    required this.controller,
    required this.title,
  });

  @override
  State<MangaDiscoverWidget> createState() => _MangaDiscoverWidgetState();
}

class _MangaDiscoverWidgetState extends State<MangaDiscoverWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const Gap(16),
          Container(
            height: 52,
            margin: const EdgeInsets.only(left: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: index == 0
                        ? Colors.amberAccent
                        : Colors.white.withOpacity(.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: const Center(
                    child: Text(
                      "Mystery",
                    ),
                  ),
                );
              },
            ),
          ),
          const Gap(16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  "83 books",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Spacer(),
                Text(
                  "by Popularity",
                  style: TextStyle(color: Colors.white),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                )
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(
                16.0,
                16,
                16,
                0,
              ),
              child: AllMangaWidget(
                controller: widget.controller,
                params: widget.params,
                canLoadMore: true,
              ),
            ),
        ],
      ),
    );
  }
}
