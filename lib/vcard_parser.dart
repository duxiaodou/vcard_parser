library vcard_parser;

class VcardParser {
  final VCARD_BEGIN_SIGN      = 'BEGIN:VCARD';
  final VCARD_END_SIGN        = 'END:VCARD';
  final VCARD_FIELD_SEPARATORS = [';', '='];
  final VCARD_TAG_SEPARATOR = '\n';
  final VCARD_TAG_KE_VALUE_SEPARATOR = ':';
  final List<String> VCARD_TAG_VALUE_IGONE_SEPARATOR = [',', ''];
  final VCARD_TAGS = [
    'ADR',
    'AGENT',
    'BDAY',
    'CATEGORIES',
    'CLASS',
    'EMAIL',
    'FN',
    'GEO',
    'IMPP',
    'KEY',
    'LABEL',
    'LOGO',
    'MAILER',
    'N',
    'NAME',
    'NICKNAME',
    'NOTE',
    'ORG',
    'PHOTO',
    'PRODID',
    'PROFILE',
    'REV',
    'ROLE',
    'SORT-STRING'
    'SOUND',
    'SOURCE',
    'TEL',
    'TITLE',
    'TZ',
    'UID',
    'URL',
    'VERSION',
  ];

  String content = null;
  Map<String, Object> tags = new Map<String,Object>();
  VcardParser(String content) {
    this.content= content;
    print(content);
  }

  Map<String, Object> parse() {
    Map<String,Object> tags = new Map<String, Object>();

    // 去除;; 并将文本内容按行切分
    List<String> lines = content.replaceAll(";;", "").split(VCARD_TAG_SEPARATOR);
    lines.forEach((field) {
      String key = null;
      Object value= null;

      // 提取每行中的标签和值
      List<String> tagAndValue = field.split(VCARD_TAG_KE_VALUE_SEPARATOR);
      if (tagAndValue.length != 2) {
        return ;
      }

      key = tagAndValue[0].trim();
      value = tagAndValue[1].trim().replaceAll(VCARD_TAG_VALUE_IGONE_SEPARATOR[0], VCARD_TAG_VALUE_IGONE_SEPARATOR[1]);

      // 若复杂字段，则需进一步解析数据
      if (key.contains(VCARD_FIELD_SEPARATORS[0])) {
        value = parseFields(field.trim());
      }

      // 新增或合并数据
      if(tags.containsKey(key)) {
        List<Map<String,String>> oldValues = new List<Map<String,String>>();
        // 如果之前未合并，则用List保存旧的和新的数据
        if(tags[key] is Map) {
          Map<String,String> oldValue = tags[key];
          oldValues.add(oldValue);
          oldValues.add(value);
          value = oldValues;
        } else {
          // 之前合并过，则将新数据追加到旧数据
          oldValues = tags[key];
          oldValues.add(value);
          value = oldValues;
        }
      }
      // 将解析后的字段添加到tags
      tags[key] = value;
    });

    this.tags = tags;
    return tags;
  }

  /*
    解析字段
   */
  Object parseFields(String line) {
    Object field = new Object();
    List<String> rawFields = line.split(VCARD_FIELD_SEPARATORS[0]);

    // 切分得到的原始字段中，第0个元素便是key，因此忽略
    rawFields.getRange(1, rawFields.length).forEach((rawField) {
        List<String> items = new List<String>();
        List<String> rawItems = rawField.split(VCARD_FIELD_SEPARATORS[0]);
        if(rawItems.length == 1) {
          rawItems = rawField.split(VCARD_FIELD_SEPARATORS[1]);
        }

        // 提取item的key和value
        if(rawItems.length > 0) {
          rawItems.forEach((itemValue) {
            items = itemValue.split(VCARD_TAG_KE_VALUE_SEPARATOR);
          });
        }

        // item的key和value保存在数组，因此其元素数量为2
        if (items.length == 2) {
          field = {'name': items.elementAt(0), 'value': items.elementAt(1).replaceAll(VCARD_TAG_VALUE_IGONE_SEPARATOR[0], VCARD_TAG_VALUE_IGONE_SEPARATOR[1])};
        }
      });
      return field;
  }
}
