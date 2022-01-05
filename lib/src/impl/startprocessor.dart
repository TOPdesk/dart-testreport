// Copyright (c) 2016-2021, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:testreport/src/api/model.dart';
import 'package:testreport/src/api/processor.dart';
import 'package:testreport/src/impl/processor1.dart';

class StartProcessor implements Processor {
  Processor? _delegate;
  final DateTime? timestamp;

  StartProcessor(this.timestamp);

  @override
  void process(Map<String, dynamic> event) {
    final type = event['type'] as String?;
    if (type == null) throw ArgumentError("No type in '$event'");
    if (type == 'start') {
      if (_delegate == null) {
        _delegate = _createDelegate(event['protocolVersion'] as String);
        return;
      }
      throw StateError('already started');
    }
    if (_delegate == null) {
      throw StateError('not started');
    }
    _delegate!.process(event);
  }

  @override
  Report get report {
    if (_delegate == null) throw StateError('not started');
    return _delegate!.report;
  }

  Processor _createDelegate(String version) {
    if (version.startsWith('0.')) {
      return Processor1(timestamp);
    }
    throw UnsupportedError(
        "No suitable processor found for version '$version'. "
        "Supported versions:\n'^0.1.0'");
  }
}
