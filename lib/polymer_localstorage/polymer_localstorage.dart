library polymer_localstorage;

import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:polymer/polymer.dart';

@CustomTag('polymer-localstorage')
class PolymerLocalstorage extends PolymerElement {
  
  /**
   * The key to the data stored in localStorage.
   */
  @published String name;
  
  /**
   * The data associated with the specified name.
   */
  @published var value;

  /**
   * If true, the value is stored and retrieved without JSON processing.
   */
  @observable bool useRaw = false;

  /**
   * If true, auto save is disabled.
   */
  @observable bool autoSaveDisabled = false;
  
  bool loaded = false;
  
  PolymerLocalstorage.created() : super.created();
  
  final _logger = new Logger('polymer-localstorage');

  @override
  void enteredView() {
    super.enteredView();
    print('polymer-localstorage inserted');
    
    // let the bindings complete, so run this async
    // TODO: should we use runAsync here?
    scheduleMicrotask(load);
  }

  valueChanged(oldValue) {
    if (loaded && !this.autoSaveDisabled) {
      this.save();
    }
  }
  
  void load() {
    var s = window.localStorage[name];
    if (s != null && !useRaw) {
      try {
        value = JSON.decode(s);
      } catch (x) {
        value = s;
      }
    } else {
      value = s;
    }
    loaded = true;
    //this.asyncFire('polymer-localstorage-load');
  }

  
  void save() {
    window.localStorage[name] = useRaw ? value : JSON.encode(this.value);
  }
  
}