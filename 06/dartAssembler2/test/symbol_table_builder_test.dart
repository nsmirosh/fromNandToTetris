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

void main() {
  group("description", () {
    setUp(() async {
      print("setUp");
      lineNo = 0;
      symbolTable = testSymbolTable;
    });

    tearDown(() async {
      print("tearDown");
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
  });

/*
  test('is symbol', () {
    expect(addToSymbolTableIfLabel("@stuff"), true);
    expect(isSymbol("@1"), false);
    expect(isSymbol("0;JMP"), false);
  });*/
}
