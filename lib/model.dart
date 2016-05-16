// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:built_collection/built_collection.dart';

const int unfinished = -1;

class Report {
  final Iterable<Suite> suites;
  final DateTime timestamp;

  Report(Iterable<Suite> suites, {this.timestamp}) : this.suites = new BuiltList<Suite>(suites);
}

class Suite {
  static final _skips = (Test t) => !t.isHidden && t.isSkipped;
  static final _problems = (Test t) => !t.isHidden && t.problems.isNotEmpty;
  static final _tests = (Test t) => !t.isHidden;
  static final _hidden = (Test t) => t.isHidden;

  final String path;
  final String platform;
  final Iterable<Test> allTests;

  Iterable<Test> get tests => allTests.where(_tests);
  Iterable<Test> get skipped => allTests.where(_skips);
  Iterable<Test> get problems => allTests.where(_problems);
  Iterable<Test> get hidden => allTests.where(_hidden);

  Suite(this.path, this.platform, Iterable<Test> allTests)
      : this.allTests = new BuiltList<Test>(allTests);
}

class Test {
  final String name;
  final int duration;
  final String skipReason;
  final Iterable<Problem> problems;
  final Iterable<String> prints;
  final bool isHidden;

  bool get isSkipped => skipReason != null;

  Test(this.name, this.duration, this.skipReason, Iterable<Problem> problems,
      Iterable<String> prints, this.isHidden)
      : this.problems = new BuiltList<Problem>(problems),
        this.prints = new BuiltList<String>(prints);
}

class Problem {
  final String message;
  final String stacktrace;
  final bool isFailure;

  Problem(this.message, this.stacktrace, this.isFailure);
}
