const databaseString = '''
方藥,治療方法,月經量,,,經血顏色,,,,,,經血質地,,,,經痛,,,,,,,,,,,,,,,,經期,白帶,,,,,,,面色,,,,,腰酸腿軟,周身痛,眼花,眼睛通紅且痛,聽覺較弱,耳鳴,頭暈,頭痛,口又苦又乾,口乾,精神不振,精神差,情緒波動大,經常嘆氣,身體發熱，比較傾向喝冷飲,怕冷,手腳冰冷,胸部、腹側或乳房脹痛,胸悶,心胸煩熱,自覺心臟不正常跳動,不夠氣,胃氣多,胃口不佳,腹脹,腹瀉,口淡味寡,大便硬,便秘,大便不成形,小便色黃,尿頻,尿多而頻,夜尿多,水腫,性慾減退,四肢麻痹、發抖,四肢無力,睡眠不足，發夢多,掌心熱,容易疲倦,身形較肥胖,容易受驚,健忘,指甲無血色,唇色淡,皮膚容易乾燥,口乾不欲飲,夜間出汗,身體長期低熱,黃昏後發熱
,,少,正常,多,淺,正常,鮮紅,深紅,紫紅,深紫,稀,正常,黏稠,有血塊,無,經前,經期間,經後,絞痛,長期隱隱痛,冷痛,灼痛,用溫暖的東西敷肚會改善,按壓會改善,按之痛甚,血塊下後痛減,有固定痛點，如針刺狀,脹痛連及腹側,有下墜感,腹部有包塊，而此包塊推之可移，按之可散,月經來得不暢,量多,色透明,色黃或帶有血絲,質地稀,有臭味,陰部痕癢,陰部反覆感染,黯淡無光,臉頰通紅,偏黃,蒼白,青白,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
大補元煎,補腎益氣,T,,,T,,,,,,T,,,,,,T,T,,T,,,,T,,,,,,,,,,,,,,,T,,,,,T,,,,,,T,,,,T,,,,,,,,,,,,,,,,,,,,,T,,,,,,,,,,,,,,,,,,,
左歸丸,滋腎益陰,T,,,,,T,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,T,,,,T,,,,,,T,,,T,,,,,,,,,,,,,,,,,,,,,,,,,,,,,T,T,,,,,,,,,T,,
烏藥湯,疏肝解鬱,,,,,,,T,,,,,,,,,,,,,,,,,,,,T,,,,,,,,,,,,,,,,,,,,,,,,,,,,,T,,,,T,T,,,,T,T,,,,,,,,,,,,,,,,,,,,,,,,,,,
歸脾湯,健脾氣,,,T,T,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,T,T,T,,,,,,,,,,,T,,,,,,,,,,,,,
完帶湯,健脾利濕,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,T,,,,,,,,,,,,,,,,,T,T,,,,T,T,,T,T,,,,,,,,,,T,,,,,,T,T,,,,,,,,,
四物湯,養血柔肝,T,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,T,,,,,,,,,T,,,,,,,,,,,,,,T,,,,,,,,,,,,,,,,,,T,,T,,T,T,,,,,,,
舉元煎,補氣,,,T,,,,,,,T,,,,,,,,,,,,,,,,,,T,,,T,,,,,,,,,,T,,,,T,,,,T,,,,,,,,,,,,,,,T,,,,,,,,,,,,,,,,,,,T,,,,,,,,,,
烏藥湯,行氣,,,,,,,,,,,,,,,T,T,,,,,,,,,,,T,,T,,,,,,,,,,,,,,,T,,,,,,,,,,,,,,,,,T,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
人參養榮湯,補血養血,T,,,T,,,,,,T,,,,,,T,T,,T,,,,T,,,,,,,,,,,,,,,,,T,T,,,,T,,,,T,,,,T,T,,,,,,,,,T,,,,,,,,,,,,,,,,T,T,T,,T,,,,T,T,T,,,,
桃紅四物湯,活血化瘀,,,,,,,,T,T,,,,T,,T,T,,,,,,,,T,T,T,,,T,T,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,T,,T,T,,,
清經散,清熱涼血,,,T,,,,,T,,,,T,T,,T,T,,,,,T,,,T,,,,,,,,,,,,,,,T,,,,,,,,,,,,,T,,,,,T,,,,T,,,,,,,,,,T,,T,,,,,,,,,,,,,,,,,,,,
固經丸,益陰涼血,T,,,,,T,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,T,,,,,,,,,,,,,T,,,,,,,,,,T,,,,,,,,,,,,,,,,,,,T,T,,,,,,,,,T,T,T
溫經湯 + 右歸丸,溫經扶陽,T,,,T,,,,,,,,,,,,,,T,,T,,T,,,,,,,,,,,,,,,,,,,,T,,,,,,,,,,,,,,,,,T,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
溫經湯,溫經散寒,T,,,,,T,,T,T,,,,T,,T,T,,,T,T,,T,T,,,,,,,,,,,,,,,,,,,,T,,,,,,T,,,,,,,,,,,,,,,T,,,,,,,,,,,,,,,,,,,,,,,,,,,,,''';

const databaseV2Json = [
  {
    "question": "請在日曆中劃出你最近一次的月經期（從第一天到最後一天）",
    "title": "經期",
    "options": "",
    "group": 0,
    "optionSeparator": "",
    "optionAdditionalStep": "",
    "isMultipleChoice": "",
    "expectedAnsFormat": "date",
    "isOptional": "",
    "logicReference":
        "正常,28-35 days\n月經先期,<21 days (連續2次)\n月經後期,>35 days (連續2次)\n月經先後不定期,+/- 7-14 days (連續3次)\n閉經,>6 months",
    "reference": "Step1",
  },
  // {
  //   "question": "對上一次月經的第一天",
  //   "options": "",
  //   "group": 0,
  //   "optionSeparator": "",
  //   "optionAdditionalStep": "",
  //   "isMultipleChoice": "",
  //   "expectedAnsFormat": "date",
  //   "isOptional": "",
  //   "logicReference": "",
  //   "reference": "Step1",
  // },
  {
    "question": "你平常的月經規律嗎？",
    "title": "週期",
    // "textReplaceData": "早來,遲來,不定期？",
    "options": "是,不是",
    "group": 0,
    "optionSeparator": "",
    "optionAdditionalStep": "",
    "isMultipleChoice": "",
    "expectedAnsFormat": "options",
    "isOptional": "TRUE",
    "logicReference": "",
    "reference": "Step1",
  },
  {
    "question": "一般來說，你的月經週期是多少天？",
    "options": "5-7 days,<5 days,8 days-13 days,>14 days",
    "optionSeparator": "",
    "optionAdditionalStep": "",
    "isMultipleChoice": "",
    "group": 0,
    "expectedAnsFormat": "numberText",
    "isOptional": "",
    "logicReference":
        "正常,5-7 days\n月經過短,<5 days\n月經延長,8 days-13 days\n崩漏,>14 days",
    "reference": "Step1",
  },
  {
    "question": "經量：月經期最多的一天日用衛生巾（23cm）的使用量",
    "options": "<2,2-4,>4",
    "optionSeparator": "",
    "group": 1,
    "optionAdditionalStep": "",
    "isMultipleChoice": "",
    "expectedAnsFormat": "options",
    "isOptional": "",
    "logicReference": "<2,月經過少\n2-4,正常\n>4,月經過多",
    "reference": "Step2",
  },
  {
    "question": "月經一般的顏色",
    "options":
        "淡紅(#FAE2E3),淡黯(#E2DADB),鮮紅(#F80322),深紅(#9A1D2D),深紫(#7C0313),紫紅(#B2404F),正常(#B2404F)",
    "optionSeparator": "",
    "group": 1,
    "optionAdditionalStep": "colorParser",
    "isMultipleChoice": "",
    "expectedAnsFormat": "options",
    "isOptional": "",
    "logicReference":
        "月經過少\",\"月經過多\",\"正常\"\n\"淡紅\",\"脾陽不振(痰濕)\n肝虛血少(心脾兩虛)\n血寒（虛）\",\"脾氣虛弱\n氣虛\n血虛\"\n\"淡黯\",\"腎氣虛\",\"\"\n\"鮮紅\",\"腎陰虛\n血熱（虛）\",\"血熱（實）\"\n\"深紅\",\"肝氣鬱結\",\"肝氣鬱結\n血熱（實）\"\n\"紫紅\",\"肝鬱化火\n血瘀\n血寒（實）\",\"肝鬱化火\n血瘀\n血熱（實）\n濕熱蘊結\"\n\"深紫\",\"血瘀\n血寒（實）\",\"血瘀\"\n\"正常\",\"\",\"",
    "reference": "Step2",
  },
  {
    "question": "經質",
    "options": "稀,黏稠,有血塊",
    "optionSeparator": "",
    "group": 1,
    "optionAdditionalStep": "",
    "isMultipleChoice": "TRUE",
    "expectedAnsFormat": "options",
    "isOptional": "TRUE",
    "logicReference": "",
    "reference": "Step2",
  },
  {
    "question": "你有沒有經痛的問題？",
    "options": "有,沒有",
    "optionSeparator": "",
    "group": 2,
    "optionAdditionalStep": "",
    "isMultipleChoice": "",
    "expectedAnsFormat": "options",
    "isOptional": "",
    "logicReference": "無（直接到（5））",
    "reference": "Step3,q1",
  },
  {
    "question": "經痛通常在什麼時候發生？(可選多項)",
    "options": "經前,經期間,經後",
    "optionSeparator": "",
    "group": 2,
    "optionAdditionalStep": "",
    "isMultipleChoice": "TRUE",
    "expectedAnsFormat": "options",
    "isOptional": "TRUE",
    "logicReference": "",
    "reference": "Step3,q2",
  },
  {
    "question": "怎樣的痛法？",
    "options":
        "月經來得不暢、絞痛、冷痛、灼痛、有固定痛點，如針刺狀、脹痛連及腹側、腹部有包塊，而此包塊推之可移，按之可散、痛連腰骶,月經來得不暢、絞痛、長期隱隱痛、冷痛、灼痛、有固定痛點，如針刺狀、脹痛連及腹側、有下墜感、腹部有包塊，而此包塊推之可移，按之可散、痛連腰骶,長期隱隱痛、有下墜感、痛連腰骶",
    "optionSeparator": "、",
    "group": 2,
    "optionAdditionalStep": "filteringByLastAnsIndex",
    "isMultipleChoice": "",
    "expectedAnsFormat": "options",
    "canSkipChoice": "TRUE",
    "isOptional": "",
    "logicReference":
        "月經來得不暢\",\"絞痛\",\"長期隱隱痛\",\"冷痛\",\"灼痛\",\"有固定痛點，如針刺狀\",\"脹痛連及腹側\",\"有下墜感\",\"腹部有包塊，而此包塊推之可移，按之可散\"\n\"經前\",\"血瘀\",\"血寒\",\"\",\"血寒\",\"濕熱蘊結\n血熱\",\"血瘀\",\"肝氣鬱結\n肝鬱化火\",\"\"\n\"經期間\",\"血瘀\",\"血寒\",\"氣虛\n血虛\",\"血寒\",\"濕熱蘊結\n血熱\",\"血瘀\",\"肝氣鬱結\n肝鬱化火\",\"氣虛\"\n\"經後\",\"\",\"\",\"氣虛\n血虛\",\"\",\"\",\"\",\"\",\"氣虛",
    "reference": "Step3,q3",
  },
  {
    "question": "經痛會加重或改善？",
    "options": "用溫暖的東西敷肚會改善,按壓會改善,按之痛甚,血塊下後痛減",
    "optionSeparator": "",
    "optionAdditionalStep": "",
    "isMultipleChoice": "TRUE",
    "expectedAnsFormat": "options",
    "isOptional": "TRUE",
    "logicReference": "(ask only if (1)-(3) can’t diagnosis)",
    "reference": "Step3,q4",
  },
  {
    "question": "經期間不適",
    "options": "發熱,頭痛,吐血或流鼻血,大便洩瀉,乳房作脹,煩躁易怒，或情志抑鬱",
    "optionSeparator": "",
    "optionAdditionalStep": "",
    "isMultipleChoice": "",
    "expectedAnsFormat": "options",
    "isOptional": "",
    "logicReference": "",
    "reference": "Step3,q5",
  }
];

const textureData = [
  {"稀": "T", "正常": "", "黏稠": "", "有血塊": ""},
  {"稀": "", "正常": "", "黏稠": "T", "有血塊": ""},
  {"稀": "", "正常": "", "黏稠": "", "有血塊": "T"},
  {"稀": "", "正常": "", "黏稠": "T", "有血塊": "T"},
  {"稀": "T", "正常": "", "黏稠": "", "有血塊": ""},
  {"稀": "", "正常": "", "黏稠": "T", "有血塊": ""},
  {"稀": "T", "正常": "", "黏稠": "", "有血塊": ""},
  {"稀": "T", "正常": "", "黏稠": "", "有血塊": ""},
  {"稀": "", "正常": "", "黏稠": "T", "有血塊": "T"},
  {"稀": "T", "正常": "", "黏稠": "", "有血塊": ""},
  {"稀": "", "正常": "", "黏稠": "T", "有血塊": "T"},
  {"稀": "", "正常": "", "黏稠": "T", "有血塊": "T"},
  {"稀": "", "正常": "", "黏稠": "T", "有血塊": ""},
  {"稀": "", "正常": "", "黏稠": "", "有血塊": "T"},
  {"稀": "T", "正常": "", "黏稠": "", "有血塊": ""},
];

const menstruationPainData = {
  "Time": "經期間",
  "月經來得不暢": "血瘀",
  "絞痛": "血寒",
  "長期隱隱痛": "氣虛\n血虛",
  "冷痛": "血寒",
  "灼痛": "濕熱蘊結\n血熱",
  "有固定痛點，如針刺狀": "血瘀",
  "脹痛連及腹側": "肝氣鬱結\n肝鬱化火",
  "有下墜感": "氣虛",
  "腹部有包塊，而此包塊推之可移，按之可散": "肝鬱化火\n血瘀",
};

const painImprovementData = [
  {"用溫暖的東西敷肚會改善": "", "按壓會改善": "T", "按之痛甚": "", "血塊下後痛減": ""},
  {"用溫暖的東西敷肚會改善": "", "按壓會改善": "", "按之痛甚": "", "血塊下後痛減": ""},
  {"用溫暖的東西敷肚會改善": "", "按壓會改善": "", "按之痛甚": "", "血塊下後痛減": ""},
  {"用溫暖的東西敷肚會改善": "", "按壓會改善": "", "按之痛甚": "T", "血塊下後痛減": ""},
  {"用溫暖的東西敷肚會改善": "", "按壓會改善": "", "按之痛甚": "", "血塊下後痛減": ""},
  {"用溫暖的東西敷肚會改善": "", "按壓會改善": "", "按之痛甚": "", "血塊下後痛減": ""},
  {"用溫暖的東西敷肚會改善": "", "按壓會改善": "", "按之痛甚": "", "血塊下後痛減": ""},
  {"用溫暖的東西敷肚會改善": "", "按壓會改善": "T", "按之痛甚": "", "血塊下後痛減": ""},
  {"用溫暖的東西敷肚會改善": "", "按壓會改善": "", "按之痛甚": "", "血塊下後痛減": ""},
  {"用溫暖的東西敷肚會改善": "", "按壓會改善": "T", "按之痛甚": "", "血塊下後痛減": ""},
  {"用溫暖的東西敷肚會改善": "", "按壓會改善": "", "按之痛甚": "T", "血塊下後痛減": "T"},
  {"用溫暖的東西敷肚會改善": "", "按壓會改善": "", "按之痛甚": "T", "血塊下後痛減": ""},
  {"用溫暖的東西敷肚會改善": "", "按壓會改善": "", "按之痛甚": "", "血塊下後痛減": ""},
  {"用溫暖的東西敷肚會改善": "T", "按壓會改善": "", "按之痛甚": "", "血塊下後痛減": ""},
];
