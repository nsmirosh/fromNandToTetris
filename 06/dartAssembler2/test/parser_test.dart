import 'package:dartAssembler2/parser.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockParser extends Mock implements Parser {}

void main() {
  test('check that dest bits are parsed correctly', ()
  {
    var parser = MockParser();
    when(parser.isAinstr("balls")).thenReturn(true);
    // when(parser.proccessAInstr("balls")).thenReturn("001");
    parser.processLine("balls");
    parser.isAinstr("balls");
    // expect(parser.proccessAInstr("balls"), "001");
    verify(parser.processLine("balls"));
    verify(parser.isAinstr("balls"));

  });
}