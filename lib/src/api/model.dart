// Copyright (c) 2016-2018, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

const int unfinished = -1;

class Report {
  final Iterable<Suite> suites;
  final DateTime timestamp;

  Report(Iterable<Suite> suites, {this.timestamp})
      : this.suites = new List.unmodifiable(suites);
}

typedef bool _Filter(Test t);

class Suite {
  static final _Filter _skips = (t) => !t.isHidden && t.isSkipped;
  static final _Filter _problems = (t) => !t.isHidden && t.problems.isNotEmpty;
  static final _Filter _tests = (t) => !t.isHidden;
  static final _Filter _hidden = (t) => t.isHidden;

  final String path;
  final String platform;
  final Iterable<Test> allTests;

  Iterable<Test> get tests => allTests.where(_tests);
  Iterable<Test> get skipped => allTests.where(_skips);
  Iterable<Test> get problems => allTests.where(_problems);
  Iterable<Test> get hidden => allTests.where(_hidden);

  Suite(this.path, this.platform, Iterable<Test> allTests)
      : this.allTests = new List.unmodifiable(allTests);
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
      : this.problems = new List.unmodifiable(problems),
        this.prints = new List.unmodifiable(prints);
}

class Problem {
  final String message;
  final String stacktrace;
  final bool isFailure;

  Problem(this.message, this.stacktrace, this.isFailure);
}
