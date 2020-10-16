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
int lineNo = 1;

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

List<String> buildAssemblyWithoutSymbols(String wholeFile) {
  LineSplitter ls = LineSplitter();
  List<String> lines = ls.convert(wholeFile);
  buildSymbolTable(lines);

  final List<String> assemblyWithoutSymbols = [];

  lines.forEach((line) {
    if (isLabel(line))
      return; // just don't write the line if it's a label
    else if (isSymbol(line))
      assemblyWithoutSymbols
          .add("@${symbolTable[line]}\n"); // convert the symbol to plain number
    else
      assemblyWithoutSymbols.add(line);
  });

  return assemblyWithoutSymbols;
}

Map<String, int> buildSymbolTable(List<String> wholeFile) {
  wholeFile.forEach((line) {
    if (isLabel(line))
      handleLabel(line);
    else if (isSymbol(line)) handleSymbol(line);
    lineNo++;
  });

  vars.asMap().forEach((index, value) => symbolTable[value] =
      nextFreeRAMPos + index); //add the vars to the symbolTable
  return symbolTable;
}

void handleLabel(String line) {
  final symbol = "@${extractLabelName(line)}";
  symbolTable[symbol] = lineNo - 1; //insert symbol regardless, we insert with lineNo - 1 because the label is going to get removed
  vars.remove(
      symbol); //remove from the vars - if it's not there it's not going to do anything
}

void handleSymbol(String line) {
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


printSymbolTable() {
  symbolTable.keys.forEach((key) {
    print('$key = ${symbolTable[key]}');
  });
}
