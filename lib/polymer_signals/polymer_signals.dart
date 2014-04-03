// Copyright (c) 2013, the polymer_elements.dart project authors.  Please see
// the AUTHORS file for details. All rights reserved. Use of this source code is
// governed by a BSD-style license that can be found in the LICENSE file.
// This work is a port of the polymer-elements from the Polymer project,
// http://www.polymer-project.org/.


library polymer_elements.polymer_signals;

import 'dart:html';

import 'package:polymer/polymer.dart';

@CustomTag('polymer-signals')
class PolymerSignals extends PolymerElement {

  PolymerSignals.created() : super.created();

  void enteredView() {
    super.enteredView();
    _signals.add(this);
  }

  void leftView() {
    _signals.remove(this);
    super.leftView();
  }
}

// private shared database
List _signals = [];

// signal dispatcher
void _notify(name, data) {
  // convert generic-signal event to named-signal event
  var signal = new CustomEvent('polymer-signal' + name, canBubble: true, detail:
      data);

  // workaround for http://stackoverflow.com/questions/22821638
  var l = _signals.toList(growable: false);
  // dispatch named-signal to all 'signals' instances,
  // only interested listeners will react
  l.forEach((s) {
    s.dispatchEvent(signal);
  });
}


@initMethod
void registerListener() {
  // signal listener at document
  document.addEventListener('polymer-signal', (e) {
    _notify(e.detail['name'], e.detail['data']);
  });
}
