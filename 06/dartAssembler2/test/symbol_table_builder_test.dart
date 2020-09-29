import 'package:dartAssembler2/symbol_table_builder.dart';
import 'package:test/test.dart';

Map<String, int> testSymbolTable = {
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

String instructions = '''
@R1
D=M
@OUTPUT_D
0;JMP
(OUTPUT_FIRST)
  ''';

String instructions1 = '''
@R0
D=M
@R1
D=D-M
@OUTPUT_FIRST
D;JGT
@R1
D=M
@OUTPUT_D
0;JMP
(OUTPUT_FIRST)
@R0
D=M
(OUTPUT_D)
@R2
M=D
(INFINITE_LOOP)
@INFINITE_LOOP
0;JMP''';

void main() {
  group("description", () {
    setUp(() async {
      print("setUp");
      lineNo = 0;
      vars = [];
      nextFreeRAMPos = 16;
      symbolTable = Map();
      symbolTable.addAll(testSymbolTable);
    });

    tearDown(() async {
      print("tearDown");
      symbolTable = null;
      lineNo = 0;
      vars = null;
    });

    test('extract label name', () {
      expect(extractLabelName("(OUTPUT_FIRST)"), "OUTPUT_FIRST");
    });

    test('build symbol table inserts a single label at position 4', () {
      expect(buildSymbolTable(instructions)["@OUTPUT_FIRST"], 4);
    });

    test(
        'build symbol table inserts a single label at position 4, removes it from a list of variable',
        () {
      vars = ["@OUTPUT_FIRST", "@someVar"];
      buildSymbolTable(instructions);
      expect(vars.length, 2);
      expect(vars[0], "@someVar");
      expect(vars[1], "@OUTPUT_D");
    });

    test('isLabel works OK', () {
      expect(isLabel("(OUTPUT_FIRST)"), true);
      expect(isLabel("D=M"), false);
      expect(isLabel("@OUTPUT_D"), false);
      expect(isLabel("0;JMP"), false);
    });

    test('isSymbol works OK', () {
      expect(isSymbol("(OUTPUT_FIRST)"), false);
      expect(isSymbol("D=M"), false);
      expect(isSymbol("@OUTPUT_D"), true);
      expect(isSymbol("0;JMP"), false);
    });

    test('handleLabel inserts into symbolTable correctly with no Label in vars',
        () {
      vars = ["@someVar", "@someBalls"];
      lineNo = 5;
      handleLabel("(OUTPUT_FIRST)");
      expect(symbolTable["@OUTPUT_FIRST"], 5);
    });

    test('handleLabel removes from vars a lable that should not be there', () {
      vars = ["@someVar", "@someBalls", "@OUTPUT_FIRST", "@someBalls2"];
      lineNo = 5;
      handleLabel("(OUTPUT_FIRST)");
      expect(symbolTable["@OUTPUT_FIRST"], 5);
      expect(vars[0], "@someVar");
      expect(vars[1], "@someBalls");
      expect(vars[2], "@someBalls2");
    });

    test('handleSymbol does not add anything to the symbols or vars if the symbol is already in the vars ', () {

      vars = ["@someVar", "@someBalls", "@out", "@someBalls2"];
      expect(symbolTable.length, 23);
      handleSymbol("@out");
      expect(symbolTable.length, 23);
      expect(vars[0], "@someVar");
      expect(vars[1], "@someBalls");
      expect(vars[2], "@out");
      expect(vars[3], "@someBalls2");

    });

    test('handleSymbol does not do anything if the symbol is already in the symbol table ', () {

      vars = ["@someVar", "@someBalls", "@out", "@someBalls2"];
      expect(symbolTable.length, 23);
      symbolTable["@OUTPUT_FIRST"] = 10;
      expect(symbolTable.length, 24);
      handleSymbol("@OUTPUT_FIRST");
      expect(symbolTable.length, 24);
      expect(vars[0], "@someVar");
      expect(vars[1], "@someBalls");
      expect(vars[2], "@out");
      expect(vars[3], "@someBalls2");

    });

    test('handleSymbol does not do anything if the symbol is already in the symbol table ', () {

      vars = ["@someVar", "@someBalls", "@out", "@someBalls2"];
      expect(symbolTable.length, 23);
      symbolTable["@OUTPUT_FIRST"] = 10;
      expect(symbolTable.length, 24);
      handleSymbol("@OUTPUT_FIRST");
      expect(symbolTable.length, 24);
      expect(vars[0], "@someVar");
      expect(vars[1], "@someBalls");
      expect(vars[2], "@out");
      expect(vars[3], "@someBalls2");

    });

    test('handleSymbol adds to the vars if the symbol is not in the vars and not in the symboltable ', () {

      vars = ["@someVar", "@someBalls", "@out", "@someBalls2"];
      expect(symbolTable.length, 23);
      handleSymbol("@someBalls3");
      expect(symbolTable.length, 23);
      expect(vars[0], "@someVar");
      expect(vars[1], "@someBalls");
      expect(vars[2], "@out");
      expect(vars[3], "@someBalls2");
      expect(vars[4], "@someBalls3");
    });


    test('handleSymbol does not to the var a var that is already in the symbol table ', () {

      vars = ["@someVar", "@someBalls", "@out", "@someBalls2"];
      expect(symbolTable.length, 23);
      handleSymbol("@R0");
      expect(symbolTable.length, 23);
      expect(vars[0], "@someVar");
      expect(vars[1], "@someBalls");
      expect(vars[2], "@out");
      expect(vars[3], "@someBalls2");
    });

    test(
        'build symbol table with longer instructions but no variables',
            () {
          final result = buildSymbolTable(instructions1);

          //vars aren't touched since there are no vars
          expect(vars.length, 0);

          expect(result["@OUTPUT_FIRST"], 10);
        });
  });
}
