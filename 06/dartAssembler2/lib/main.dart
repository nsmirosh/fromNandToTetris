import 'dart:convert';
import 'dart:io';

var currentParsePosition = 0;

main() {
  final fileToReadFrom = new File('readFile.txt');
  Stream<List<int>> inputStream = fileToReadFrom.openRead();

  final fileToWriteTo = File('writeFile.txt').openWrite();
  inputStream
      .transform(utf8.decoder) // Decode bytes to UTF-8.
      .transform(LineSplitter()) // Convert stream to individual lines.
      .listen((String line) {
    fileToWriteTo.write('${_processLine(line)} \n');
  }, onDone: () {
    fileToWriteTo.close();
    print('File is now closed.');
  }, onError: (e) {
    print(e.toString());
    fileToWriteTo.close();
  });
}

String _processLine(String line) {
  var instructionInBinary = "balls";
  // if the first character is @ it's an A instruction
  // we convert it to a 16 bit binary number then
  if (line[0] == "@") {
    //pad the binaryString with additional zeros to make it a 16 bit binary
    instructionInBinary = int.parse(line.substring(1)).toRadixString(2);
    instructionInBinary.padLeft(16 - instructionInBinary.length, '0');
  } else {
    //else it's a C instruction so we can add the first 111 straight away
    // the format of the C instr = 111accccccdddjjj.
    instructionInBinary = "111";

    final destBits = getDestBits(line);
    final compBits = getComputationBits(line, posToStartParsingFrom: currentParsePosition);
  }

  return instructionInBinary;
}

getDestBits(String line) {
  // if the 2nd or 3rd char is '=' it means that there are going to be destination bits
  // if there is none - that means we can map the computation instruction straight away
  var destBits = "000";
  if (line.contains("=")) {
    if (line[1] == '=') {
      destBits = dstMap[line.substring(0, 1)];
      currentParsePosition = 2;
    } else if (line[2] == '=') {
      destBits = dstMap[line.substring(0, 2)];
      currentParsePosition = 3;
    } else if (line[3] == '=') {
      destBits = dstMap[line.substring(0, 3)];
      currentParsePosition = 4;
    }
  }

  return destBits;
}

getComputationBits(String line,/* for testing purposes */ {int posToStartParsingFrom} ) {
  var compBits = "";
  var compInstructionAndForward = line.substring(posToStartParsingFrom);
  // the comp instruction end either at the end of the line
  // or before the ";" symbol
  if (compInstructionAndForward.contains(";")) {
    //if there's a semicolon we're passing either some constant or a D register
    // hence only 1 char passing to the compInstructionMap is enough
    compBits = compInstructionMap[compInstructionAndForward[0]];
  }
  else {
    // if there's no semicolon we can be sure that there isn't going to be any jump
    // so we can just take the rest of the instruction and match it against the compInstructionMap
    compBits = compInstructionMap[compInstructionAndForward];
  }
  currentParsePosition += compBits.length;
  return compBits;
}

const compInstructionMap = {
  //a = 0
  "0": "0101010",
  "1": "0111111",
  "-1": "0111010",
  "D": "0001100",
  "A": "0110000",
  "!D": "0001101",
  "!A": "0110001",
  "-D": "0001111",
  "-A": "0110011",
  "D+1": "0011111",
  "A+1": "0110111",
  "D-1": "0001110",
  "A-1": "0110010",
  "D+A": "0000010",
  "D-A": "0010011",
  "A-D": "0000111",
  "D&A": "0000000",
  "D|A": "0010101",

  //a = 1
  "M": "1110000",
  "!M": "1110001",
  "-M": "1110011",
  "M+1": "1110111",
  "M-1": "1110010",
  "D+M": "1000010",
  "D-M": "1010011",
  "M-D": "1000111",
  "D&M": "1000000",
  "D|M": "1010101",
};

const jmpInstructionMap = {
  null: "000",
  "JGT": "001",
  "JEQ": "010",
  "JGE": "011",
  "JLT": "100",
  "JNE": "101",
  "JLE": "110",
  "JMP": "111",
};

const dstMap = {
  null: "000",
  "M": "001",
  "D": "010",
  "MD": "011",
  "A": "100",
  "AM": "101",
  "AD": "110",
  "AMD": "111",
};
