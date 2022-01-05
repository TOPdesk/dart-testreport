import 'dart:io';
import 'dart:convert';

import 'package:testreport/testreport.dart';

void main(List<String> args) async {
  final file = File(args[0]);
  final lines = LineSplitter().bind(utf8.decoder.bind(file.openRead()));
  final report = await createReport(file.lastModifiedSync(), lines);

  for (final suite in report.suites) {
    for (final test in suite.problems) {
      for (final problem in test.problems) {
        print('${suite.path} - ${test.name}: ${problem.message}');
      }
    }
  }
}

Future<Report> createReport(DateTime when, Stream<String> lines) async {
  var processor = Processor(timestamp: when);
  await for (String line in lines) {
    processor.process(json.decode(line) as Map<String, dynamic>);
  }
  return processor.report;
}
