// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:testreport/src/api/model.dart';
import 'package:testreport/src/impl/startprocessor.dart';

abstract class Processor {
  factory Processor({DateTime timestamp}) {
    return new StartProcessor(timestamp);
  }

  void process(Map<String, dynamic> event) {}

  Report get report;
}
