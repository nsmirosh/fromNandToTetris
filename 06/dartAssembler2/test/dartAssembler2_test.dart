import 'package:dartAssembler2/main.dart';
import 'package:test/test.dart';

void main() {
  test('check dest bits are parsed correctly', () {
    expect(getDestBits("D=M"), "010");
    expect(getDestBits("AM=D"), "101");
    expect(getDestBits("AMD=1"), "111");
    expect(getDestBits("@1"), "000");
  });

  test('check comp bits are parsed correctly', () {
    expect(getComputationBits("D=M", posToStartParsingFrom: 2), "1110000");
    expect(getComputationBits("D;JLE", posToStartParsingFrom: 0), "0001100");
    expect(getComputationBits("D=D+A", posToStartParsingFrom: 2), "0000010");
    expect(getComputationBits("0;JMP", posToStartParsingFrom: 0), "0101010");
  });
}
