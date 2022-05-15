import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

class MovieDetail extends HookConsumerWidget {
  const MovieDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const noImage = 'assets/images/noimage@3x.png';
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            width: double.infinity,
            child: Image.asset(noImage, fit: BoxFit.cover),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.only(top: 10, right: 20),
              child: const Icon(
                  Icons.star,
                  color: Colors.grey,
                  size: 35,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 5,left: 15, right: 15),
            child: Text(
              'タイトルタイトルタイトルタイトルタイトルタイトルタイトルタイトルタイトル',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
