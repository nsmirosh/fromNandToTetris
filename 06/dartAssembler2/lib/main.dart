import 'dart:convert';
import 'dart:io';

const wordWidthInBits = 16;

main() {
  final fileToReadFrom = new File('readFile.txt');
  Stream<List<int>> inputStream = fileToReadFrom.openRead();

  final fileToWriteTo = File('writeFile.txt').openWrite();
  inputStream
      .transform(utf8.decoder) // Decode bytes to UTF-8.
      .transform(LineSplitter()) // Convert stream to individual lines.
      .listen((String line) {
    fileToWriteTo.write('${processLine(line)}\n');
  }, onDone: () {
    fileToWriteTo.close();
    print('File is now closed.');
  }, onError: (e) {
    print(e.toString());
    fileToWriteTo.close();
  });
}

String processLine(String line) {
  if (isAinstr(line)) {
    return proccessAInstr(line);
  }
  return processCInstr(line);
}

bool isAinstr(line) => line[0] == "@";

String proccessAInstr(String line) {
  var aInstrInBinary = int.parse(line.substring(1)).toRadixString(2);
  //pad the binaryString with additional zeros to make it a 16 bit binary
  return aInstrInBinary.padLeft(wordWidthInBits, '0');
}

String processCInstr(String line) {
  var cInstrInBinary = "111";
  var destBits = "000";
  var currentParsePosition = 0;
  if (line.contains("=")) {
    destBits = getDestBits(line);
    currentParsePosition = line.indexOf('=') + 1;
  }
  final compBits = getComputationBits(line, currentParsePosition);

  var jumpBits = "000";
  if (line.contains(";")) {
    jumpBits = getJumpBits(line);
  }
  cInstrInBinary += compBits + destBits + jumpBits;
  return cInstrInBinary;
}

getDestBits(String line) {
  final destInstr = line.substring(0, line.indexOf('='));
  return dstMap[destInstr];
}

getComputationBits(String line,
    /* for testing purposes */ [int posToStartParsingFrom]) {
  var compBits = "";
  var compInstructionAndForward = line.substring(posToStartParsingFrom);
  // the comp instruction end either at the end of the line
  // or before the ";" symbol
  if (compInstructionAndForward.contains(";")) {
    //if there's a semicolon we're passing either some constant or a D register
    // hence only 1 char passing to the compInstructionMap is enough
    compBits = compInstructionMap[compInstructionAndForward[0]];
  } else {
    // if there's no semicolon we can be sure that there isn't going to be any jump
    // so we can just take the rest of the instruction and match it against the compInstructionMap
    compBits = compInstructionMap[compInstructionAndForward];
  }
  return compBits;
}

getJumpBits(String line) {
  var jumpInstruction = line.substring(line.indexOf(';') + 1);
  return jmpInstructionMap[jumpInstruction];
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
  "JGT": "001",
  "JEQ": "010",
  "JGE": "011",
  "JLT": "100",
  "JNE": "101",
  "JLE": "110",
  "JMP": "111",
};

const dstMap = {
  "M": "001",
  "D": "010",
  "MD": "011",
  "A": "100",
  "AM": "101",
  "AD": "110",
  "AMD": "111",
};
