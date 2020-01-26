// Copyright (c) 2016-2020, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:testreport/src/api/model.dart';
import 'package:testreport/src/impl/startprocessor.dart';

/// The Processor consumes events emitted by the [json reporter](https://github.com/dart-lang/test/blob/master/pkgs/test/doc/json_reporter.md).
abstract class Processor {
  Processor._();

  /// Creates a Processor for the given [timestamp].
  factory Processor({DateTime timestamp}) => StartProcessor(timestamp);

  /// Processes a single [event](https://github.com/dart-lang/test/blob/master/pkgs/test/doc/json_reporter.md#events).
  ///
  /// Throws a [StateError] is the [StartEvent](https://github.com/dart-lang/test/blob/master/pkgs/test/doc/json_reporter.md#startevent)
  /// is not the first event.
  void process(Map<String, dynamic> event) {}

  /// The report of the handled events so far.
  ///
  /// Throws a [StateError] if the [StartEvent](https://github.com/dart-lang/test/blob/master/pkgs/test/doc/json_reporter.md#startevent)
  /// has not been processed.
  Report get report;
}
