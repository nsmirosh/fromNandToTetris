


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

  test('build symbol table', () {
    expect(buildSymbolTable(instructions)["@OUTPUT_FIRST"], 4);
  });

/*
  test('is symbol', () {
    expect(addToSymbolTableIfLabel("@stuff"), true);
    expect(isSymbol("@1"), false);
    expect(isSymbol("0;JMP"), false);
  });*/
}