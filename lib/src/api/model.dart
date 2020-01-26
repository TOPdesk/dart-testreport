// Copyright (c) 2016-2020, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

const int unfinished = -1;

class Report {
  final Iterable<Suite> suites;
  final DateTime timestamp;

  Report(Iterable<Suite> suites, {this.timestamp})
      : suites = List.unmodifiable(suites);
}

class Suite {
  static final bool Function(Test t) _skips = (t) => !t.isHidden && t.isSkipped;
  static final bool Function(Test t) _problems =
      (t) => !t.isHidden && t.problems.isNotEmpty;
  static final bool Function(Test t) _tests = (t) => !t.isHidden;
  static final bool Function(Test t) _hidden = (t) => t.isHidden;

  final String path;
  final String platform;
  final Iterable<Test> allTests;

  Suite(this.path, this.platform, Iterable<Test> allTests)
      : allTests = List.unmodifiable(allTests);

  Iterable<Test> get tests => allTests.where(_tests);
  Iterable<Test> get skipped => allTests.where(_skips);
  Iterable<Test> get problems => allTests.where(_problems);
  Iterable<Test> get hidden => allTests.where(_hidden);
}

class Test {
  final String name;
  final int duration;
  final String skipReason;
  final Iterable<Problem> problems;
  final Iterable<String> prints;
  final bool isHidden;

  Test(this.name, this.duration, this.skipReason, Iterable<Problem> problems,
      Iterable<String> prints, this.isHidden)
      : problems = List.unmodifiable(problems),
        prints = List.unmodifiable(prints);

  bool get isSkipped => skipReason != null;
}

class Problem {
  final String message;
  final String stacktrace;
  final bool isFailure;

  Problem(this.message, this.stacktrace, this.isFailure);
}
