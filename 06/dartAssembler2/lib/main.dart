import 'dart:convert';
import 'dart:io';

import 'c_instruction_constants.dart';

const wordWidthInBits = 16;
var nextRAMPos = 16;

main() {
  final fileToReadFrom = new File('readFile.asm');
  Stream<List<int>> inputStream = fileToReadFrom.openRead();

  final fileToWriteTo = File('writeFile.hack').openWrite();
  inputStream
      .transform(utf8.decoder) // Decode bytes to UTF-8.
      .transform(LineSplitter()) // Convert stream to individual lines.
      .listen((String line) {
    String pureInstruction = removeUneccessaryStuff(line);
    if (pureInstruction != null) {
      fileToWriteTo.write(processLine(pureInstruction) + "\n");
    }
  }, onDone: () {
    fileToWriteTo.close();
    print('File is now closed.');
  }, onError: (e) {
    print(e.toString());
    fileToWriteTo.close();
  });
}

String removeUneccessaryStuff(String line) {
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

String preProcessTheInstruction(String instruction) {
  /*
  1. put the "unknown" symbols into the symbol table along with their value
  2. delete the jump labels from the code
  3. subsitute the symbol from the symbol table
   */


}

insertSymbolIntoTable(String instruction) {
  if (isSymbol(instruction)) {
    if(!symbolTable.containsKey(instruction)) {

      //if it's a var - insert it into with the next vacant memory position in RAM
      //we can tell that it's a var if we don't encounter the "(" character for it anywhere
      symbolTable[instruction] = nextRAMPos;
      nextRAMPos++;



      //save it is a var and if we encounter the "(" change it's type to jump and assign it the jump position

    }
  }
}

String processLine(String line) {
  /*
  Perform two passes, the first one is going to:
  1. Strip everything to leave only the instructions and the symbols
  2. put the "unknown" symbols into the symbol table along with their value
  3. delete the "unknown" symbol table references from the code

  second one:
  1. Translate the symbol/comment/whitespace-free code into binary (basically what it's doing right now


   */

  if (isAinstr(line)) {
    return proccessAInstr(line);
  }
  return processCInstr(line);
}

bool isAinstr(line) => line[0] == "@";

bool isSymbol(line) => !RegExp(r'(\d+)').hasMatch(line[1]) && isAinstr(line);

bool isLabel(line) => line[0] == "(";

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

final Map<String, int>symbolTable = {
  "SP": 0,
  "LCL": 1,
  "ARG": 2,
  "THIS": 3,
  "THAT": 4,
  "R0": 0,
  "R1": 1,
  "R2": 2,
  "R3": 3,
  "R4": 4,
  "R5": 5,
  "R6": 6,
  "R7": 7,
  "R8": 8,
  "R9": 9,
  "R10": 10,
  "R11": 11,
  "R12": 12,
  "R13": 13,
  "R14": 14,
  "R15": 15,
  "SCREEN": 16384,
  "KBD": 24576,
};
