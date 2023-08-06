import 'dart:io';

List<File> getAllDartFiles(Directory directory) {
  List<File> dartFiles = [];

  directory.listSync(recursive: true).forEach((entity) {
    if (entity is File && entity.path.endsWith('.dart')) {
      dartFiles.add(entity);
    }
  });

  return dartFiles;
}

void main() {
  Directory projectDirectory = Directory('C:/Users/Kirill/StudioProjects/zenlyapp/lib');
  List<File> dartFiles = getAllDartFiles(projectDirectory);

  dartFiles.forEach((file) {
    print(file.path);
  });
}