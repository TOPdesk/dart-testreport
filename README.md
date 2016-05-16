Test Report
===========

* [Introduction](#introduction)
* [Purpose](#purpose)
* [License and contributors](#license-and-contributors)

Introduction
------------

This library can be used to process the results of dart tests. 

The goal of this library is to process the data from the `json` output emitted by the [dart test runner](https://pub.dartlang.org/packages/test) and provide an API to the interpreted test results.

Purpose
-------

By running

    pub run test simple_test.dart --reporter json

and the contents of `simple_test.dart` is

```Dart
import 'package:test/test.dart';

main() {
  test('simple', () {
    expect(true, true);
  });
}
```
    
the dart test runner will output the results of the test in `json` format as a stream of events:

```JSON
{"protocolVersion":"0.1.0","runnerVersion":"0.12.13+1","type":"start","time":0}
{"count":1,"type":"allSuites","time":0}
{"suite":{"id":0,"platform":"vm","path":"simple_test.dart"},"type":"suite","time":0}
{"test":{"id":1,"name":"loading simple_test.dart","suiteID":0,"groupIDs":[],"metadata":{"skip":false,"skipReason":null}},"type":"testStart","time":0}
{"testID":1,"result":"success","hidden":true,"type":"testDone","time":237}
{"group":{"id":2,"suiteID":0,"parentID":null,"name":null,"metadata":{"skip":false,"skipReason":null},"testCount":1},"type":"group","time":241}
{"test":{"id":3,"name":"simple","suiteID":0,"groupIDs":[2],"metadata":{"skip":false,"skipReason":null}},"type":"testStart","time":242}
{"testID":3,"result":"success","hidden":false,"type":"testDone","time":268}
{"success":true,"type":"done","time":271}
```

From this `json` output, it is not easy to see how many tests were executed, how many failed and how much time was spent in each test.

License and contributors
------------------------

* The MIT License, see [LICENSE](https://github.com/topdesk/dart-testreport/raw/master/LICENSE).
* For contributors, see [AUTHORS](https://github.com/topdesk/dart-testreport/raw/master/AUTHORS).