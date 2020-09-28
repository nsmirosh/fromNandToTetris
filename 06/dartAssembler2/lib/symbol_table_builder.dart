
/*
build the Map<String, int> which corresponds to Map <symbol name, memory / label position>

logic:

if instr starts with "(" :
    1. put it in the symbol table (there can only be 1 place where it's declared so we don't need to check)
     1a put the current line which we're parsing at the moment
    2. check if it's in the list of variables - if yes, remove it from there (make sure that the list actually shrinks, don't just put 0)
if  instr start with a "@":
    1. check if it's in the symbol table (i.e. it's a label)
    2. if not, check if it's in the variable list
    3. if not, put it in the variable list


once finished parsing the whole instruction list (reach the end of file or last instruction).
1. iterate over the list of variables and input them into the symbol table starting from nextFreeRAMPos


 */

var nextFreeRAMPos = 16;
var variables = [];
var labels = [];

class SymbolTableBuilder {

  Map<String, int> buildSymbolTable(String instr) {

   /* if (isLabel(instr)) {
      symbolTable[instr] =
    }*/


  }

  addToVarsIfVar(String instr) {
    if (isLabel(instr) && !isSymbolInTable(instr)) {
      variables.add(instr);
    }
  }

  addToSymbolTableIfLabel(String instruction) {
    if (isLabel(instruction)) {
      // if we encounter a label - put it in the symbolTable + 1 since we're going to
      // remove it before we start converting to binary
      // symbolTable[instruction] = lineNo + 1;
      //remove the label from the vars that were mistakingly added there
      if (variables.contains(instruction)) {
        variables.remove(instruction);
      }
    }
  }

  bool isSymbolInTable(String instruction) =>
      symbolTable.containsKey(instruction);

  // bool isSymbol(line) => !RegExp(r'(\d+)').hasMatch(line[1]) ;

  bool isLabel(line) => line[0] == "(";

  final Map<String, int> symbolTable = {
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
}


