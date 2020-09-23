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

  final compInstructionMap = {
    //a = 0
    "0":   "0101010",
    "1":   "0111111",
    "-1":  "0111010",
    "D":   "0001100",
    "A":   "0110000",
    "!D":  "0001101",
    "!A":  "0110001",
    "-D":  "0001111",
    "-A":  "0110011",
    "D+1": "0110011",


    //a = 1
  };
}
