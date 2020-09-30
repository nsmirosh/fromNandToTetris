import 'package:dartAssembler2/parser.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockParser extends Mock implements Parser {}


void main() {
  test('check that dest bits are parsed correctly', ()
  {
    // var actualParser = Parser(mockMyBalls);

    // when(parser.proccessAInstr("balls")).thenReturn("001");
    actualParser.assemblyToBinary("@1111");
    // expect(parser.proccessAInstr("balls"), "001");
    // verify(actualParser.proccessAInstr("@1111"));

  });
}