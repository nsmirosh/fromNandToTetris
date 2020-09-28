


import 'package:dartAssembler2/symbol_table_builder.dart';
import 'package:test/test.dart';

void main() {

  String instructions = '''
@R1
D=M
@OUTPUT_D
0;JMP
(OUTPUT_FIRST)
  ''';

  test('extract label name', () {
    expect(extractLabelName("(OUTPUT_FIRST)"), "OUTPUT_FIRST");
  });

  test('build symbol table inserts a single label at position 4', () {
    expect(buildSymbolTable(instructions)["@OUTPUT_FIRST"], 4);
  });


  test('handle symbol does not insert into vars ', () {
    expect(buildSymbolTable(instructions)["@OUTPUT_FIRST"], 4);
  });

  test('build symbol table inserts a single label at position 4, removes it from a list of variable', () {
    vars = ["@OUTPUT_FIRST", "@someVar"];
    buildSymbolTable(instructions);
    expect(vars.length, 3);
    expect(vars[0], "@someVar");
  });

/*
  test('is symbol', () {
    expect(addToSymbolTableIfLabel("@stuff"), true);
    expect(isSymbol("@1"), false);
    expect(isSymbol("0;JMP"), false);
  });*/
}