
import 'dart:io';
import 'package:path/path.dart';

const extensionDefault = 'txt';

Directory getDirectoryCustomer(String cnpj, String representante) {
  return getDirectory(cnpj, representante, DirectoryType.customers);
}

Directory getDirectoryOrders(String cnpj, String representante) {
  return getDirectory(cnpj, representante, DirectoryType.orders);
}

void writeFile(String path, String filename, String content) {
  File newFile = File('$path/$filename.$extensionDefault');
  newFile.createSync(recursive: true);
  newFile.writeAsStringSync(content);
}

void createDirectoryBackup(String basePath){
  _createDirectory('$basePath/backup');
}

void moveToBackup(File current){
  final name = nameFile(current.path);
  createDirectoryBackup(current.parent.path);
  current.renameSync('${current.parent.path}/backup/$name');
}

String nameFile(String path){
  return basename(path);
}

void _createDirectory(String path) {
  return Directory(path).createSync(recursive: true);
}

Directory getDirectory(String cnpj, String representante, DirectoryType type) {
  return Directory('files/$cnpj/$representante/${type==DirectoryType.orders ? "orders" : "customers"}');
}


enum DirectoryType {
  orders, customers
}