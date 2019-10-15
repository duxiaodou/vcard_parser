import 'package:flutter_test/flutter_test.dart';

import 'package:vcard_parser/vcard_parser.dart';

void main() {
  test('adds one to input values', () {
    final vcardParser = VcardParser('''
    BEGIN:VCARD
N:姓;名;;;

FN: 名  姓

TITLE:XX集团前端

ADR;WORK:;;北京市五环区北环东路19号;;;;

TEL;CELL,VOICE:159351111111

TEL;TYPE=WORK,VOICE:(111) 555-1212

TEL;WORK,VOICE:010-6666666

TEL;TYPE=CELL;TYPE=PREF:15095850003

URL;WORK:www.wintopgroup.com

EMAIL;INTERNET,HOME:253413617@qq.com


END:VCARD
    ''');
    Map<String,Object> tags = vcardParser.parse();
    print(tags['END']);
  });
}
