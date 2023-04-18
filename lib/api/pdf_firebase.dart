import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class PDFApi{
  static Future<File> loadFirebase(String url) async{
    final refPDF=FirebaseStorage.instance.ref().child(url);
    final bytes= await refPDF.getData();

    return _storeFile(url,bytes as List<int>);
  }
  static Future<File> _storeFile(String url,List<int> bytes) async{
    final fileName=basename(url);
    final dir= await getApplicationDocumentsDirectory();
    String path='${dir.path}/$fileName';
    final file=File(path);
    await file.writeAsBytes(bytes,flush:true);
    return file;

  }
}