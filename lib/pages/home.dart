import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as path;
import 'package:reader/model/file.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = GetStorage();
  final storageKey = 'FileList';

  List<Map<String, dynamic>> storedValue = [];
  @override
  void initState() {
    var data = storage.read(storageKey);
    if (data != null) {
      data.forEach((element) {
        LocalFile localFile = LocalFile(element['path'], element['name']);
        storedValue.add(localFile.toJson());
      });
    }
    super.initState();
  }

  String content = '';
  void getReader() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      String filePath = result.files.single.path!;
      // 判断文件路径是否已经添加到列表中
      if (storedValue
          .where((element) => element['path'] == filePath)
          .isNotEmpty) {
        return;
      }

      String fileName = path.basenameWithoutExtension(filePath);
      var readFile = LocalFile(result.files.single.path!, fileName);
      setState(() {
        storedValue.add(readFile.toJson());
      });
      storage.write(storageKey, storedValue);
    } else {
      // User canceled the picker
    }
  }

  void handleTapBook(LocalFile item) {
    print('handleTapBook: ${item.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: GridView.builder(
              // physics: const NeverScrollableScrollPhysics(), // 禁止滚动
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 24.0,
                childAspectRatio: 0.8,
              ),
              itemCount: storedValue.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    context.push('/reader', extra: storedValue[index]);
                  },
                  child: Container(
                    color: Colors.pink,
                    child: Text(storedValue[index]['name']),
                  ),
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getReader,
        tooltip: 'Increment',
        shape: const StadiumBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
