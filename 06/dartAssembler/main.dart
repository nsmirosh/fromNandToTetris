import 'dart:convert';
import 'dart:io';

main() {
  final fileToReadFrom = new File('readFile.txt');
  Stream<List<int>> inputStream = fileToReadFrom.openRead();

  final fileToWriteTo = File('writeFile.txt').openWrite();
  inputStream
      .transform(utf8.decoder) // Decode bytes to UTF-8.
      .transform(LineSplitter()) // Convert stream to individual lines.
      .listen((String line) {
    fileToWriteTo.write('$line: ${line.length} bytes\n');
  }, onDone: () {
    fileToWriteTo.close();
    print('File is now closed.');
  }, onError: (e) {
    print(e.toString());
    fileToWriteTo.close();
  });
}
