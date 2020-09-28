// Real class
import 'c_instruction_constants.dart';


const wordWidthInBits = 16;

class Parser {
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
}

