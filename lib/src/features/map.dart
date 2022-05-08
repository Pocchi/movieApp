import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Map extends HookWidget {
  const Map({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchText = useState('');

    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Column(
        ),
      ),
    );
  }
}


