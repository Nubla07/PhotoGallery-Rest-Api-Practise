import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'secondScreen.dart';

class Photos {
  final String title;
  final String thumbnailUrl;
  final String id;

  Photos({required this.title, required this.thumbnailUrl, required this.id});
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  List<Photos> photoList = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Photo Gallery App",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: photoList.length,
                  itemBuilder: (context, index) {
                    final photo = photoList[index];
                    return SingleChildScrollView(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8),
                        leading: Image.network(
                          photo.thumbnailUrl,
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.2,
                        ),
                        title: Text(photo.title),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SecondScreen(photo: photo),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }

  Future<void> fetchData() async {
    const String photoUrl = "https://jsonplaceholder.typicode.com/photos";
    Uri uri = Uri.parse(photoUrl);
    try {
      Response response = await get(uri);
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          photoList = decodedData
              .map((item) => Photos(
                    title: item['title'],
                    thumbnailUrl: item['thumbnailUrl'],
                    id: item['id'].toString(),
                  ))
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Loading Data Failed!";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "An error occurred: $e";
        isLoading = false;
      });
    }
  }
}
