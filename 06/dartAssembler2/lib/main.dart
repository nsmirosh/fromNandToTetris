import 'dart:convert';
import 'dart:io';

import 'package:dartAssembler2/parser.dart';
import 'package:dartAssembler2/symbol_table_builder.dart';


var lineNo = 0;

main() {
  final assemblyWithSymbols = new File('AssemblyWithSymbols.asm');
  Stream<List<int>> inputStream = assemblyWithSymbols.openRead();
  final pureAssembly = File('PureAssembly.asm').openWrite();

  final symbolTableBuilder = SymbolTableBuilder();

  String wholeFileNoCommentsOrWhitespace;

  inputStream
      .transform(utf8.decoder)
      .transform(LineSplitter())
      .listen((String line) {

    String pureText = removeCommentsAndWhiteSpace(line);
    wholeFileNoCommentsOrWhitespace += "$pureText\n";
  }, onDone: () {
    pureAssembly.close();
    print('File is now closed.');
  }, onError: (e) {
    print(e.toString());
    pureAssembly.close();
  });


  // parser.convertToAssembly(pureInstruction) + "\n"


  final fileToWriteTo = File('MachineLanguage.hack').openWrite();
  final parser = Parser();

}

String removeCommentsAndWhiteSpace(String line) {
  if (line.contains("//")) {
    String lineWithoutStartingWhiteSpace = line.trimLeft();
    int commentStartPos = lineWithoutStartingWhiteSpace.indexOf("//");
    if (commentStartPos != 0) {
      // there's an instruction before the comment so extract that and pass it on.
      // there could be something else, but we don't handle it.
      return lineWithoutStartingWhiteSpace.substring(0, commentStartPos).trim();
    } else {
      // the line starts from a comment so might as well just remove it
      return null;
    }
  } else if (line.trim().length == 0) {
    //it's just whitespace so remove it
    return null;
  }
  return line.trim();
}

