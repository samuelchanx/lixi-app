const userAnswerMap = {
  "0": {
    "text": "",
    "dateRange": ["2023-01-29T00:00:00.000", "2023-02-03T00:00:00.000"],
    "selectedOptionIndex": [],
  },
  "1": {
    "text": "",
    "selectedOptionIndex": [1],
  },
  "3": {"text": "2", "selectedOptionIndex": []},
  "4": {
    "text": "",
    "selectedOptionIndex": [5],
  },
  "5": {
    "text": "",
    "selectedOptionIndex": [2],
  },
  "6": {"text": "2", "selectedOptionIndex": []},
  "7": {
    "text": "",
    "selectedOptionIndex": [1, 0],
  },
  "8": {
    "text": "",
    "selectedOptionIndex": [6, 9],
  },
  "9": {
    "text": "",
    "selectedOptionIndex": [4],
  },
  "10": {
    "text": "",
    "selectedOptionIndex": [3, 5],
  },
  "11": {
    "text": "",
    "selectedOptionIndex": [2, 5],
  },
};

const testingData = [
  {
    "1": "20240317-20240321",
    "2": "",
    "3": 0,
    "4": 28,
    "5": 5,
    "6": "0,3",
    "7": 0,
    "8": 1,
    "9": "0,1,2",
    "10": "0,1,3,5,7",
    "11": "",
    "12": "",
    "13": "",
    "Questions": 1,
    "診斷": "氣虛+血虛",
    "Remarks": "",
  },
  {
    "1": "20240301-20240322",
    "2": "",
    "3": 0,
    "4": 35,
    "5": 1,
    "6": "0,1",
    "7": 0,
    "8": 4,
    "9": 0,
    "10": "3,4",
    "11": "",
    "12": "",
    "13": "TBC",
    "Questions": 2,
    "診斷": "血虛 or 腎氣虛 or 肝虛血少 or 血寒(虛)",
    "Remarks":
        "When the result for amount + colour is contradictary to m pain features, take the amount + colour as the dominating factor, and ask the 其他症狀 for final diagnosis",
  },
  {
    "1": "20240401-20240402",
    "2": "",
    "3": 0,
    "4": 27,
    "5": 3,
    "6": "5,6",
    "7": "0,3",
    "8": 6,
    "9": 1,
    "10": "5,6",
    "11": 3,
    "12": "",
    "13": "",
    "Questions": 3,
    "診斷": "血瘀",
    "Remarks": "經血質地不可能又清稀又有血塊，在此要看經色有跟清稀或有血塊比較類近而排除另一個答案",
  },
  {
    "1": "20240110-20240120",
    "2": "",
    "3": 0,
    "4": 21,
    "5": 2,
    "6": 2,
    "7": 2,
    "8": 10,
    "9": 2,
    "10": "1,4,7",
    "11": 2,
    "12": "",
    "13": "",
    "Questions": 4,
    "診斷": "血瘀",
    "Remarks": "黏稠跟經後發生經痛是不會一次出現，在此以黏稠+正常繼續診斷",
  },
  {
    "1": "20240230-20240303",
    "2": "",
    "3": 0,
    "4": 42,
    "5": 5,
    "6": 3,
    "7": "2,3",
    "8": 4,
    "9": "1,2",
    "10": "0,7",
    "11": "",
    "12": "",
    "13": "",
    "Questions": 5,
    "診斷": "血熱（實）",
    "Remarks": "",
  },
  {
    "1": "20240323-20240326",
    "2": "",
    "3": 1,
    "4": 45,
    "5": 7,
    "6": 3,
    "7": "2,3",
    "8": 3,
    "9": "0,1",
    "10": "2,5",
    "11": "2,3",
    "12": "",
    "13": "",
    "Questions": 6,
    "診斷": "血熱(實)",
    "Remarks": "",
  },
  {
    "1": "20240312-20240320",
    "2": "",
    "3": 1,
    "4": 30,
    "5": 2,
    "6": 3,
    "7": 1,
    "8": 5,
    "9": "0,2",
    "10": "3,5",
    "11": 3,
    "12": "",
    "13": "TBC",
    "Questions": 7,
    "診斷": "腎陰虛 or 血熱（虛)",
    "Remarks": "經痛的表現跟經量、經色不同的時候，要多問其他症狀以確認",
  },
  {
    "1": "20240301-20240306",
    "2": "",
    "3": 1,
    "4": 30,
    "5": 1,
    "6": "4,5",
    "7": 1,
    "8": 7,
    "9": "0,1,2",
    "10": "4,7",
    "11": 0,
    "12": "",
    "13": "",
    "Questions": 8,
    "診斷": "血寒(實)",
    "Remarks": "",
  },
  {
    "1": 20240410,
    "2": 5,
    "3": 0,
    "4": 30,
    "5": 1,
    "6": "3,6",
    "7": 0,
    "8": 2,
    "9": 0,
    "10": "2,4,5,7",
    "11": "",
    "12": "",
    "13": "",
    "Questions": 9,
    "診斷": "血瘀",
    "Remarks": "",
  },
  {
    "1": "20240317-20240321",
    "2": "",
    "3": 0,
    "4": 28,
    "5": 5,
    "6": "0,5",
    "7": "0,3",
    "8": 3,
    "9": 0,
    "10": "0,1,2,3",
    "11": "",
    "12": "",
    "13": "",
    "Questions": 10,
    "診斷": "血瘀",
    "Remarks": "",
  },
  {
    "1": "20240320-20240322",
    "2": "",
    "3": 1,
    "4": 28,
    "5": 3,
    "6": 5,
    "7": "0,2",
    "8": 1,
    "9": 2,
    "10": "3,7,2",
    "11": "",
    "12": "",
    "13": "",
    "Questions": 11,
    "診斷": "血瘀",
    "Remarks": "經血質地不可能又清稀又黏稠，在此要看經色有跟清稀或有血塊比較類近而排除另一個答案",
  },
  {
    "1": "20240318-20240323",
    "2": "",
    "3": 1,
    "4": 31,
    "5": 3,
    "6": "4,5,6",
    "7": "1,3",
    "8": 0,
    "9": "",
    "10": "",
    "11": "",
    "12": "",
    "13": "TBC",
    "Questions": 12,
    "診斷": "血寒(實) or 肝氣鬱結 or 濕熱蘊結 or 肝鬱化火 or 血瘀 or 血熱(實)",
    "Remarks": "",
  },
  {
    "1": "20240317-20240324",
    "2": "",
    "3": 0,
    "4": 32,
    "5": 2,
    "6": 0,
    "7": 1,
    "8": 0,
    "9": "",
    "10": "",
    "11": "",
    "12": "",
    "13": "TBC",
    "Questions": 13,
    "診斷": "肝虛血少(心脾兩虛) or 血寒（虛）or 脾氣虛弱 or 脾陽不振(痰濕) or 氣虛 or 血虛",
    "Remarks": "",
  },
  {
    "1": "20240319-20240325",
    "2": "",
    "3": 1,
    "4": 38,
    "5": 2,
    "6": 3,
    "7": 1,
    "8": 0,
    "9": "",
    "10": "",
    "11": "",
    "12": "",
    "13": "TBC",
    "Questions": 14,
    "診斷": "腎陰虛 or 血熱（虛）or 血熱(實)",
    "Remarks": "",
  },
  {
    "1": 20240319,
    "2": 10,
    "3": 0,
    "4": 25,
    "5": 1,
    "6": 3,
    "7": 1,
    "8": 3,
    "9": "0,2",
    "10": 0,
    "11": "",
    "12": "",
    "13": "TBC",
    "Questions": 15,
    "診斷": "腎陰虛 or 血熱（虛）",
    "Remarks": "",
  }
];
