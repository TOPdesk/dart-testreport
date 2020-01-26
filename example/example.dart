import 'dart:io';
import 'dart:convert';

import 'package:testreport/testreport.dart';

void main(List<String> args) async {
  var file = File(args[0]);
  var lines = LineSplitter().bind(utf8.decoder.bind(file.openRead()));
  var report = await createReport(file.lastModifiedSync(), lines);

  report.suites.forEach((s) {
    s.problems.forEach((t) {
      t.problems.forEach((p) {
        print('${s.path} - ${t.name}: ${p.message}');
      });
    });
  });
}

Future<Report> createReport(DateTime when, Stream<String> lines) async {
  var processor = Processor(timestamp: when);
  await for (String line in lines) {
    processor.process(json.decode(line) as Map<String, dynamic>);
  }
  return processor.report;
}
