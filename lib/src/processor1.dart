// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:collection';
import 'package:testreport/model.dart';
import 'package:testreport/processor.dart';

class Processor1 implements Processor {
  static const resultCodes = const ['success', 'failure', 'error'];

  Map<int, _Suite> suites = new SplayTreeMap();
  Map<int, _Test> tests = {};
  final DateTime timestamp;

  Processor1(this.timestamp) {}

  @override
  void process(Map<String, dynamic> event) {
    String type = event['type'];
    switch (type) {
      case 'testStart':
        var test = event['test'];
        var testCase = new _Test()
          ..startTime = event['time']
          ..name = test['name']
          ..skipReason = test['metadata']['skipReason'];

        tests[test['id']] = testCase;
        suites[test['suiteID']].tests.add(testCase);
        break;

      case 'testDone':
        if (!resultCodes.contains(event['result']))
          throw new ArgumentError("Unknown result in '$event'");

        tests[event['testID']]
          ..endTime = event['time']
          ..hidden = event['hidden'];
        break;

      case 'suite':
        var suite = event['suite'];
        suites[suite['id']] = new _Suite()
          ..path = suite['path']
          ..platform = suite['platform'];
        break;

      case 'error':
        tests[event['testID']].problems.add(new Problem(
            event['error'], event['stackTrace'], event['isFailure']));
        break;

      case 'print':
        tests[event['testID']].prints.add(event['message']);
        break;

      case 'done':
      case 'allSuites':
      case 'group':
        break;

      default:
        throw new ArgumentError("Unknown event type in '$event'");
    }
  }

  @override
  Report get report {
    return new Report(suites.values.map((t) => t.toTestSuite()), timestamp: timestamp);
  }
}

class _Test {
  String name;
  int startTime;
  int endTime = unfinished;
  String skipReason;
  List<Problem> problems = [];
  List<String> prints = [];
  bool hidden;

  Test toTestCase() {
    var duration = endTime == unfinished ? unfinished : endTime - startTime;
    return new Test(name, duration, skipReason, problems, prints,
        hidden && problems.isEmpty);
  }
}

class _Suite {
  String path;
  String platform;
  List<_Test> tests = [];

  Suite toTestSuite() {
    return new Suite(path, platform, tests.map((t) => t.toTestCase()));
  }
}
