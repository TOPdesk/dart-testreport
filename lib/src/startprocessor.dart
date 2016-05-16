// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:testreport/model.dart';
import 'package:testreport/processor.dart';
import 'processor1.dart';

class StartProcessor implements Processor {
  Processor _delegate;
  final DateTime timestamp;

  StartProcessor(this.timestamp) {}

  @override
  void process(Map<String, dynamic> event) {
    var type = event['type'];
    if (type == null) throw new ArgumentError("No type in '$event'");
    if (type == 'start') {
      if (_delegate == null) {
        _delegate = _createDelegate(event['protocolVersion']);
        return;
      }
      throw new StateError('already started');
    }
    _delegate.process(event);
  }

  @override
  Report get report {
    if (_delegate == null) throw new StateError('not started');
    return _delegate.report;
  }

  Processor _createDelegate(String version) {
    if (version.startsWith('0.')) {
      return new Processor1(timestamp);
    }
    throw new UnsupportedError(
        "No suitable processor found for version '$version'. "
        "Supported versions:\n'^0.1.0'");
  }
}
