import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> data = [];

  @override
  void initState() {
    getApiData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testing Api'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          data[index]['name'].toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                        subtitle: Text(data[index]['address'].toString()),
                        trailing: Text('${data[index]['age']}'),
                      );
                    }))
          ],
        ),
      ),
    );
  }

  void getApiData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:4000/'));
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      print(data);
    } else {
      print('Error Occured in Api fetching');
    }
  }
}
