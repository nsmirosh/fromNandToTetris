import 'package:dartAssembler2/main.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    expect(getDestBits("D=M"), "010");
    expect(getDestBits("AM=D"), "101");
    expect(getDestBits("AMD=1"), "111");
    expect(getDestBits("@1"), "000");
  });
}
