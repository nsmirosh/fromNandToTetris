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

import 'dart:convert';

var nextFreeRAMPos = 16;
var vars = [];
int lineNo = 0;

Map<String, int> symbolTable = {
  "@SP": 0,
  "@LCL": 1,
  "@ARG": 2,
  "@THIS": 3,
  "@THAT": 4,
  "@R0": 0,
  "@R1": 1,
  "@R2": 2,
  "@R3": 3,
  "@R4": 4,
  "@R5": 5,
  "@R6": 6,
  "@R7": 7,
  "@R8": 8,
  "@R9": 9,
  "@R10": 10,
  "@R11": 11,
  "@R12": 12,
  "@R13": 13,
  "@R14": 14,
  "@R15": 15,
  "@SCREEN": 16384,
  "@KBD": 24576,
};

Map<String, int> buildSymbolTable(String instr) {
  LineSplitter ls = LineSplitter();
  List<String> lines = ls.convert(instr);

  lines.forEach((line) {
    if (isLabel(line))
      handleLabel(line);
    else if (isSymbol(line)) handleSymbol(line);
    lineNo++;
  });

  return symbolTable;
}

void handleLabel(String line) {
  final symbol = "@${extractLabelName(line)}";
  symbolTable[symbol] = lineNo; //insert symbol regardless
  final removed = vars.remove(
      symbol); //remove from the vars - if it's not there it's not going to do anything
  print("$symbol removed == $removed");
}

void handleSymbol(String line) {
  print("symbolTable.containsKey($line) == ${symbolTable.containsKey(line)}");
  print("vars.contains($line) == ${vars.contains(line)}");

  if (symbolTable.containsKey(line) || vars.contains(line)) {
    return;
  }
  vars.add(line);
}

bool isLabel(line) => line[0] == "(";
bool isSymbol(line) => line[0] == "@";

extractLabelName(String label) {
  return label.substring(1, label.length - 1);
}
