import 'package:dartAssembler2/main.dart';
import 'package:test/test.dart';

void main() {
  test('check that dest bits are parsed correctly', () {
    expect(getDestBits("D=M"), "010");
    expect(getDestBits("AM=D"), "101");
    expect(getDestBits("AMD=1"), "111");
  });

  test('check that comp bits are parsed correctly', () {
    expect(getComputationBits("D=M", 2), "1110000");
    expect(getComputationBits("D;JLE", 0), "0001100");
    expect(getComputationBits("D=D+A", 2), "0000010");
    expect(getComputationBits("0;JMP", 0), "0101010");
  });

  test('check that jump bits are parsed correctly', () {
    expect(getJumpBits("D;JLE"), "110");
    expect(getJumpBits("0;JMP"), "111");
  });

  test('process the A instruction', () {
    expect(proccessAInstr("@16384"), "0100000000000000");
    expect(proccessAInstr("@5"), "0000000000000101");
  });

  //111accccccdddjjj
  test('process the whole line', () {
    expect(processLine("MD=M-1"), "111" + "1110010" + "011" + "000");
  });

  test('remove comments and whitespace from the line', () {
    expect(removeUneccessaryStuff("// This file is part of www.nand2tetris.org"), null);
    expect(removeUneccessaryStuff("0;JMP    // infinite loop"), "0;JMP");
    expect(removeUneccessaryStuff("M=D//big balls"), "M=D");
    expect(removeUneccessaryStuff("    M=D"), "M=D");
    expect(removeUneccessaryStuff("A=D"), "A=D");
    expect(removeUneccessaryStuff("D=D-M     "), "D=D-M");
    expect(removeUneccessaryStuff("            \n"), null);
  });

  test('is symbol', () {
    expect(isSymbol("@R0"), true);
    expect(isSymbol("@1"), false);
    expect(isSymbol("0;JMP"), false);
  });
}
