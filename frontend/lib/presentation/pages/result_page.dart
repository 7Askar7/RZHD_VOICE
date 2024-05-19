import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../service_locator.dart';

class ResultsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final id = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['id'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Результаты анализа речи'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:  Column(
            children: [
              // SummarySection(),
              // SizedBox(height: 20),
              DetailedResultsSection(
                id: id,
              ),
            ],
          ),
      
      ),
    );
  }
}

class SummarySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.yellow[100],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Общие результаты:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Статистика по:'),
            Text('процент реплик с ошибкой'),
            Text(
                'процент слов из общего объема с ошибкой с сегментацией по ролям и без нее'),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: Text('Отображать статистику на время'),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailedResultsSection extends StatelessWidget {
  final String id;
  final Map<String, Color> mapOfColors = {
    'SPEAKER_00': Color.fromARGB(255, 255, 169, 169),
    'SPEAKER_01': Color.fromARGB(171, 202, 255, 244),
    'SPEAKER_02': Color.fromARGB(255, 177, 244, 153),
    'SPEAKER_03': const Color.fromARGB(255, 239, 151, 255),
    'SPEAKER_04': Colors.red,
    'SPEAKER_05': Colors.yellow,
  };

  DetailedResultsSection({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
              future: fetchResults(id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return Container(
                  height: 400,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Детализированные результаты:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                child: Container(
                                  width: 211,
                                  height: 39,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(188, 228, 29, 19),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add,
                                          size: 30,
                                          color:
                                              Color.fromARGB(255, 255, 255, 255)),
                                      SizedBox(width: 10),
                                      Text(
                                        'ЖАЛОБА ОТ РОЛИ',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        ...snapshot.data!.speeches.map((speech) => SpeechCard(
                              role: speech.role,
                              text: speech.text,
                              color: mapOfColors[speech.role],
                            )),
                        SizedBox(height: 10),
                        Legend(
                          errors: snapshot.data!.errors,
                          speeches: snapshot.data!.speeches,
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }

  Future<ParsedResultModel> fetchResults(String id) {
    String url = dotenv.env['URL']! + 'v1/predict/$id';
    String? accessToken = getIt<GlobalVariables>().accessToken;
    var _dio = getIt<Dio>();

    return _dio.get(
      url,
      queryParameters: {"auth_token": accessToken},
    ).then((response) {
      if (response.statusCode == 200) {
        print("in response");
        final rawResult = RawResultModel.fromJson(response.data);
        return ParsedResultModel.fromRawResult(rawResult);
      } else {
        throw Exception('Failed to load results');
      }
    });

//     String result_tr =
//         """<Trans>SPEAKER_00: 2675 или Бежесибирская красавица.</Trans>
// <Trans>SPEAKER_01: 2-6-0-7-6-5, машина из Генбельска, на 2-4-3-4-ком в километре, слушаю.</Trans>
// <Trans>SPEAKER_00: Машинец, здравствуйте, поездной диспетчер, впереди полностью перегон свободен. Пожалуйста, максимальную скорость выдерживать надо 6.08, за вами еще куча-куча поездов.</Trans>
// <Trans>SPEAKER_01: Две шестьсот семьдесят пять, и начнёт геймплейский. Понятно, скорость максимально выдерживаем, шесть ноль восемь градусов, за нами куча проездов.</Trans>
// <Trans>SPEAKER_00: Верно. Стараемся, пожалуйста, в 6.08 пройти.</Trans>
// <Trans></Trans>""";
//     String result_er = """<speech>Роль: SPEAKER_00</speech>
// <error>Ошибка из диалога: Бежесибирская красавица.</error>
// <problem>Описание проблемы из регламента: Неупотребление установленных форм (сокращение установленных форм).</problem>

// <speech>Роль: SPEAKER_00</speech>
// <error>Ошибка из диалога: 2675</error>
// <problem>Описание проблемы из регламента: Неупотребление установленных форм (сокращение установленных форм).</problem>

// <speech>Роль: SPEAKER_01</speech>
// <error>Ошибка из диалога: 2-6-0-7-6-5, машина из Генбельска, на 2-4-3-4-ком в километре, слушаю.</error>
// <problem>Описание проблемы из регламента: Непередача показаний светофоров по маршруту следования (неупотребление установленных форм).</problem>

// <speech>Роль: SPEAKER_00</speech>
// <error>Ошибка из диалога: Машинец, здравствуйте, поездной диспетчер, впереди полностью перегон свободен. Пожалуйста, максимальную скорость выдерживать надо 6.08, за вами еще куча-куча поездов.</error>
// <problem>Описание проблемы из регламента: Неубеждение в правильности восприятия команды (недостаточная четкость).</problem>

// <speech>Роль: SPEAKER_01</speech>
// <error>Ошибка из диалога: Две шестьсот семьдесят пять, и начнёт геймплейский. Понятно, скорость максимально выдерживаем, шесть ноль восемь градусов, за нами куча проездов.</error>
// <problem>Описание проблемы из регламента: Неубеждение в правильности восприятия команды (недостаточная четкость).</problem>

// <speech>Роль: SPEAKER_00</speech>
// <error>Ошибка из диалога: Верно. Стараемся, пожалуйста, в 6.08 пройти.</error>
// <problem>Описание проблемы из регламента: Неубеждение в правильности восприятия команды (недостаточная четкость).</problem>

// <speech>Роль: SPEAKER_01</speech>
// <error>Ошибка из диалога: Получилось 6.08.</error>
// <problem>Описание проблемы из регламента: Неупотребление установленных форм (сокращение установленных форм).</problem>""";

//     return Future.delayed(Duration(seconds: 2), () {
//       return ParsedResultModel.fromRawResult(
//         RawResultModel(
//           result_tr: result_tr,
//           result_er: result_er,
//         ),
//       );
//     });
  }
}

class RawResultModel {
  final String result_tr;
  final String result_er;

  RawResultModel({required this.result_tr, required this.result_er});

  factory RawResultModel.fromJson(Map<String, dynamic> json) {
    print(json['result_er']);
    return RawResultModel(
      result_tr: json['result_tr'],
      result_er: json['result_er'],
    );
  }
}

class ParsedResultModel {
  final List<Speech> speeches;
  final List<SpeechError> errors;

  ParsedResultModel({required this.speeches, required this.errors});

  factory ParsedResultModel.fromRawResult(RawResultModel rawResult) {
    List<Speech> speeches = [];
    List<SpeechError> errors = [];

    print(" in parsed result model");
    speeches = parseSpeeches(rawResult.result_tr);
    errors = parseSpeechErrors(rawResult.result_er);
    return ParsedResultModel(speeches: speeches, errors: errors);
  }
}

List<Speech> parseSpeeches(String text) {
  final RegExp speechRegExp = RegExp(r'<Trans>(SPEAKER_\d+): (.+?)<\/Trans>');
  final Iterable<RegExpMatch> matches = speechRegExp.allMatches(text);

  print("in parse speeches");
  return matches.map((match) {
    final String role = match.group(1)!;
    final String speechText = match.group(2)!;
    return Speech(role: role, text: speechText);
  }).toList();
}

List<SpeechError> parseSpeechErrors(String text) {
  final RegExp speechRegExp = RegExp(
      r'<speech>Роль: (SPEAKER_\d+)<\/speech>\s*<error>Ошибка из диалога: (.+?)<\/error>\s*<problem>Описание проблемы из регламента: (.+?)<\/problem>');
  final Iterable<RegExpMatch> matches = speechRegExp.allMatches(text);

  print("in parse speech errors $text");
  return matches.map((match) {
    final String speechRole = match.group(1)!;
    final String error = match.group(2)!;
    final String problem = match.group(3)!;
    return SpeechError(speech: speechRole, error: error, problem: problem);
  }).toList();
}

class Speech {
  final String role;
  final String text;

  Speech({required this.role, required this.text});
}

class SpeechError {
  final String speech;
  final String error;
  final String problem;

  SpeechError(
      {required this.speech, required this.error, required this.problem});
}

class SpeechCard extends StatelessWidget {
  final String role;
  final String text;
  final Color? color;

  SpeechCard({required this.role, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(role),
        subtitle: Text(text),
      ),
    );
  }
}

class Legend extends StatelessWidget {
  final List<SpeechError> errors;
  final List<Speech> speeches;

  Legend({this.errors = const [], required this.speeches});
  @override
  Widget build(BuildContext context) {
    int count = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...errors.map((error) {
          if (error.problem != 'Нет' && count < speeches.length) {
            return Container(
              child: LegendItem(
                text: error.speech + ':' + speeches[count++].text,
                error: error.error,
                problem: error.problem,
              ),
            );
          } else {
            return Container();
          }
        }),
      ],
    );
  }
}

class LegendItem extends StatelessWidget {
  final String text;
  final String error;
  final String problem;

  LegendItem({required this.text, required this.error, required this.problem});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text),
        Text("Ошибка из диалога $error"),
        Text("Описание проблемы из регламента: $problem"),
        SizedBox(
          height: 15,
        )
      ],
    );
  }
}
