// Copyright (c) 2016-2021, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:collection';
import 'package:testreport/src/api/model.dart';
import 'package:testreport/src/api/processor.dart';

class Processor1 implements Processor {
  static const resultCodes = ['success', 'failure', 'error'];

  final Map<int, _Suite> suites = SplayTreeMap();
  final Map<int, _Test> tests = <int, _Test>{};
  final DateTime? timestamp;

  Processor1(this.timestamp);

  @override
  void process(Map<String, dynamic> event) {
    final type = event['type'] as String?;
    switch (type) {
      case 'testStart':
        final test = event['test'] as Map<String, dynamic>;
        final testCase = _Test()
          ..startTime = event['time'] as int
          ..name = test['name'] as String
          ..skipReason = test['metadata']['skipReason'] as String?;

        tests[test['id'] as int] = testCase;
        suites[test['suiteID']]!.tests.add(testCase);
        break;

      case 'testDone':
        if (!resultCodes.contains(event['result'])) {
          throw ArgumentError("Unknown result in '$event'");
        }

        tests[event['testID'] as int]!
          ..endTime = event['time'] as int
          ..hidden = event['hidden'] as bool;
        break;

      case 'suite':
        final suite = event['suite'] as Map<String, dynamic>;
        suites[suite['id'] as int] = _Suite()
          ..path = suite['path'] as String
          ..platform = suite['platform'] as String;
        break;

      case 'error':
        tests[event['testID']]!.problems.add(Problem(event['error'] as String,
            event['stackTrace'] as String, event['isFailure'] as bool));
        break;

      case 'print':
        tests[event['testID'] as int]!.prints.add(event['message'] as String);
        break;

      case 'done':
      case 'allSuites':
      case 'group':
      case 'debug':
        break;

      default:
        throw ArgumentError("Unknown event type in '$event'");
    }
  }

  @override
  Report get report {
    return Report(suites.values.map((t) => t.toTestSuite()),
        timestamp: timestamp);
  }
}

class _Test {
  String name = '';
  int startTime = unfinished;
  int endTime = unfinished;
  String? skipReason;
  List<Problem> problems = <Problem>[];
  List<String> prints = <String>[];
  bool hidden = false;

  Test toTestCase() => Test(
        name,
        endTime == unfinished ? unfinished : endTime - startTime,
        skipReason,
        problems,
        prints,
        hidden && problems.isEmpty,
      );
}

class _Suite {
  String path = '';
  String platform = '';
  final List<_Test> tests = <_Test>[];

  Suite toTestSuite() => Suite(
        path,
        platform,
        tests.map((t) => t.toTestCase()),
      );
}
