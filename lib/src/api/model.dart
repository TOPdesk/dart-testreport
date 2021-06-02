// Copyright (c) 2016-2020, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

/// Indicates a test that has not yet been been finished.
const int unfinished = -1;

/// Describes the results of a test run.
class Report {
  /// The [Suite]s in the report.
  final Iterable<Suite> suites;

  /// The timestamp of the test. Might be `null`.
  final DateTime? timestamp;

  /// Create a report with the given [suites] and [timestamp].
  Report(Iterable<Suite> suites, {this.timestamp})
      : suites = List.unmodifiable(suites);
}

/// Describes a test Suite.
///
/// Based on [Suite](https://github.com/dart-lang/test/blob/master/pkgs/test/doc/json_reporter.md#suite).
class Suite {
  static final bool Function(Test t) _skips = (t) => !t.isHidden && t.isSkipped;
  static final bool Function(Test t) _problems =
      (t) => !t.isHidden && t.problems.isNotEmpty;
  static final bool Function(Test t) _tests = (t) => !t.isHidden;
  static final bool Function(Test t) _hidden = (t) => t.isHidden;

  /// The path to the suite's file.
  final String? path;

  /// The platform on which the suite is running.
  ///
  /// Might be `null`.
  final String? platform;

  /// All [Test]s contained by this Suite, including the hidden tests.
  final Iterable<Test> allTests;

  /// Create a Suite wit hthe given [path], [platform] and [allTests].
  Suite(this.path, this.platform, Iterable<Test> allTests)
      : allTests = List.unmodifiable(allTests);

  /// The [Test]s contained by this Suite.
  ///
  /// Hidden Tests are omitted.
  Iterable<Test> get tests => allTests.where(_tests);

  /// The skipped [Test]s contained by this Suite.
  ///
  /// Hidden Tests are omitted.
  Iterable<Test> get skipped => allTests.where(_skips);

  /// The [Test]s that have problems, contained by this Suite.
  ///
  /// Hidden Tests are omitted.
  Iterable<Test> get problems => allTests.where(_problems);

  /// The hidden [Test]s contained by this Suite.
  Iterable<Test> get hidden => allTests.where(_hidden);
}

/// Describes a single Test.
class Test {
  /// The name of the test, including prefixes from any containing groups.
  final String? name;

  /// How long did the test take.
  ///
  /// Contains [unfinished] if the test didn't complete (yet).
  final int duration;

  /// Indicates why was the test skipped.
  final String? skipReason;

  /// [Problem]s occurred during the test.
  final Iterable<Problem> problems;

  /// Messages printed during the test.
  final Iterable<String> prints;

  /// Indicates that the test is hidden.
  ///
  /// See [TestDoneEvent](https://github.com/dart-lang/test/blob/master/pkgs/test/doc/json_reporter.md#testdoneevent).
  final bool isHidden;

  /// Creates a Test with the given [name], [duration], [skipReason],
  /// [problems], [prints] and [isHidden].
  Test(this.name, this.duration, this.skipReason, Iterable<Problem> problems,
      Iterable<String?> prints, this.isHidden)
      : problems = List.unmodifiable(problems),
        prints = List.unmodifiable(prints);

  /// Returns whether the test is skipped.
  bool get isSkipped => skipReason != null;
}

/// Describes a problem found during running the test.
///
/// Based on [ErrorEvent](https://github.com/dart-lang/test/blob/master/pkgs/test/doc/json_reporter.md#errorevent).
class Problem {
  /// The result of calling toString() on the error object.
  final String? message;

  /// The error's stack trace, in the stack_trace package format.
  final String? stacktrace;

  /// Whether the error was a TestFailure.
  final bool isFailure;

  /// Creates a Problem with the given [message], [stacktrace] and [isFailure].
  const Problem(this.message, this.stacktrace, this.isFailure);
}
