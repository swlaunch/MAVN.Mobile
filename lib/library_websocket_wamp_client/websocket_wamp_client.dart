import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Web socket WAMP Client
///
/// This code has been copied and adapted from
/// https://github.com/kkazuo/dart-wamp-client/
///
/// LICENSE
/// Copyright (c) 2017 Koga Kazuo
///
/// Permission to use, copy, modify, and/or distribute this software for any
/// purpose with or without fee is hereby granted, provided that the above
/// copyright notice and this permission notice appear in all copies.
/// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
/// WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
/// MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
/// SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
/// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
/// OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
/// CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
///
/// UPDATES AND CHANGES
/// 1. Updated code to use the new Dart 2 syntax
/// 2. Added Ticket Authentication
/// 3. Added a way to disconnect the web socket
/// 4. Added onDisconnect and onError streams
///
/// HOW IT WORKS:
/// TODO

class WampCode {
  static const int hello = 1;
  static const int welcome = 2;
  static const int abort = 3;
  static const int challenge = 4;
  static const int authenticate = 5;
  static const int goodbye = 6;
  static const int error = 8;
  static const int publish = 16;
  static const int published = 17;
  static const int subscribe = 32;
  static const int subscribed = 33;
  static const int unsubscribe = 34;
  static const int unsubscribed = 35;
  static const int event = 36;
  static const int call = 48;
  static const int cancel = 49;
  static const int result = 50;
  static const int register = 64;
  static const int registered = 65;
  static const int unregister = 66;
  static const int unregistered = 67;
  static const int invocation = 68;
  static const int interrupt = 69;
  static const int yield = 70;
}

/// WAMP RPC arguments.
class WampArgs {
  const WampArgs([
    this.args = const <dynamic>[],
    this.params = const <String, dynamic>{},
  ]);

  factory WampArgs._toWampArgs(List<dynamic> msg, [int idx = 4]) => WampArgs(
      idx < msg.length ? (msg[idx] as List<dynamic>) : (const <dynamic>[]),
      idx + 1 < msg.length
          ? (msg[idx + 1] as Map<String, dynamic>)
          : (const <String, dynamic>{}));

  /// Array arguments.
  final List<dynamic> args;

  /// Keyword arguments.
  final Map<String, dynamic> params;

  List toJson() => <dynamic>[args, params];

  @override
  String toString() => jsonEncode(this);
}

/// WAMP RPC procedure type.
typedef WampProcedure = WampArgs Function(WampArgs args);

/// WAMP event.
class WampEvent {
  const WampEvent(this.id, this.details, this.args);

  final int id;
  final Map details;
  final WampArgs args;

  Map toJson() => <String, dynamic>{}
    ..['id'] = id
    ..['details'] = details
    ..['args'] = args.args
    ..['params'] = args.params;

  @override
  String toString() => jsonEncode(this);
}

class _Subscription {
  _Subscription() : controller = StreamController.broadcast();

  final StreamController<WampEvent> controller;
}

/// WAMP RPC registration.
class WampRegistration {
  const WampRegistration(this.id);

  final int id;

  @override
  String toString() => 'WampRegistration(id: $id)';
}

class TicketAuth {
  TicketAuth({@required this.authId});

  final String authId;
}

/// onConnect handler type.
typedef WampOnConnect = void Function(WampClient client);
typedef WampOnDisconnect = void Function(WampClient client);
typedef WampOnError = void Function(Exception error, WampClient client);

/// WAMP Client.
///
///     var wamp = new WampClient('realm1')
///       ..onConnect = (c) {
///         // setup code here...
///       };
///
///     await wamp.connect('ws://localhost:8080/ws');
///
///
/// * [publish] / [subscribe] for PubSub.
/// * [register] / [call] for RPC.
///
class WampClient {
  WampClient({
    @required this.url,
    @required this.realm,
  })  : _random = Random.secure(),
        _inFlights = <int, StreamController<dynamic>>{},
        _subscriptions = {},
        _registrations = {};

  final String url;
  final String realm;
  TicketAuth ticketAuth;
  WampOnConnect onConnect;
  WampOnDisconnect onDisconnect;
  WampOnError onError;

  WebSocket _ws;
  var _sessionState = #closed;

  //var _sessionId = 0;
  //var _sessionDetails = const <String, dynamic>{};
  final Random _random;
  final Map<int, StreamController<dynamic>> _inFlights;
  final Map<int, _Subscription> _subscriptions;
  final Map<int, WampProcedure> _registrations;

  /// default client roles.
  static const Map<String, dynamic> defaultClientRoles = <String, dynamic>{
    'publisher': <String, dynamic>{},
    'subscriber': <String, dynamic>{},
    'callee': <String, dynamic>{},
    'caller': <String, dynamic>{},
  };

  static const _keyAcknowledge = 'acknowledge';

  /// [publish] should await acknowledge from server.
  static const Map<String, dynamic> optShouldAcknowledge = <String, dynamic>{
    _keyAcknowledge: true
  };

  /// [subscribe] ([register]) should prefix match on topic (url).
  static const Map<String, dynamic> optPrefixMatching = <String, dynamic>{
    'match': 'prefix'
  };

  /// [subscribe] ([register]) should wildcard match on topic (url).
  static const Map<String, dynamic> optWildcardMatching = <String, dynamic>{
    'match': 'wildcard'
  };

  void init({
    TicketAuth ticketAuth,
    WampOnConnect onConnect,
    WampOnDisconnect onDisconnect,
    WampOnError onError,
  }) {
    disconnect();

    this.ticketAuth = ticketAuth;
    this.onConnect = onConnect;
    this.onDisconnect = onDisconnect;
    this.onError = onError;
  }

  /// connect to WAMP server at [url].
  ///
  ///     await wamp.connect('wss://example.com/ws');
  Future connect() async {
    try {
      _ws = await WebSocket.connect(url, protocols: ['wamp.2.json'])
        ..pingInterval = const Duration(minutes: 1);

      _hello();

      await for (final m in _ws) {
        final s = m is String ? m : const Utf8Decoder().convert(m as List<int>);
        final msg = jsonDecode(s) as List<dynamic>;
        print('message received: $msg');
        _handleMessage(msg);
      }
      if (onDisconnect != null) {
        onDisconnect(this);
      }
    } catch (e) {
      if (onError != null) {
        onError(e, this);
      }
    }
  }

  void _handleMessage(List<dynamic> msg) {
    switch (msg[0] as int) {
      case WampCode.hello:
        if (_sessionState == #establishing) {
          _sessionState = #closed;
        } else if (_sessionState == #established) {
          _sessionState = #failed;
        } else if (_sessionState == #shutting_down) {
          // ignore.
        } else {
          throw Exception('on: $_sessionState, msg: $msg');
        }
        break;

      case WampCode.welcome:
        if (_sessionState == #establishing) {
          _sessionState = #established;
//          _sessionId = msg[1] as int;
//          _sessionDetails = msg[2] as Map<String, dynamic>;

          if (onConnect != null) {
            onConnect(this);
          }
        } else if (_sessionState == #shutting_down ||
            _sessionState == #established) {
          // ignore.
        } else {
          throw Exception('on: $_sessionState, msg: $msg');
        }
        break;

      case WampCode.abort:
        if (_sessionState == #shutting_down) {
          // ignore.
        } else if (_sessionState == #establishing) {
          _sessionState = #closed;
          print('aborted $msg');
        }
        break;

      case WampCode.goodbye:
        if (_sessionState == #shutting_down) {
          _sessionState = #closed;
          print('closed both!');
        } else if (_sessionState == #established) {
          _sessionState = #closing;
          goodbye();
        } else if (_sessionState == #establishing) {
          _sessionState = #failed;
        } else {
          throw Exception('on: $_sessionState, msg: $msg');
        }
        break;

      case WampCode.subscribed:
        final code = msg[1] as int;
        final subscriptionId = msg[2] as int;
        final controller = _inFlights[code];
        if (controller != null) {
          _inFlights.remove(code);
          final sub = _Subscription();
          sub.controller.onCancel = () {
            _unsubscribe(subscriptionId);
          };
          _subscriptions[subscriptionId] = sub;
          controller
            ..add(sub.controller.stream)
            ..close();
        } else {
          print('unknown subscribed: $msg');
        }
        break;

      case WampCode.unsubscribed:
        final code = msg[1] as int;
        final controller = _inFlights[code];
        if (controller != null) {
          _inFlights.remove(code);
          controller
            ..add(null)
            ..close();
        } else {
          print('unknown unsubscribed: $msg');
        }
        break;

      case WampCode.published:
        final code = msg[1] as int;
        final controller = _inFlights[code];
        if (controller != null) {
          _inFlights.remove(code);
          controller
            ..add(null)
            ..close();
        } else {
          print('unknown published: $msg');
        }
        break;

      case WampCode.event:
        final subscriptionId = msg[1] as int;
        final publishingId = msg[2] as int;
        final details = msg[3] as Map<String, dynamic>;
        final event = WampEvent(
            publishingId,
            details,
            WampArgs(
                4 < msg.length
                    ? (msg[4] as List<dynamic>)
                    : (const <dynamic>[]),
                5 < msg.length
                    ? (msg[5] as Map<String, dynamic>)
                    : (const <String, dynamic>{})));
        final sub = _subscriptions[subscriptionId];
        if (sub != null) {
          sub.controller.add(event);
        }
        break;

      case WampCode.registered:
        final code = msg[1] as int;
        final registrationId = msg[2] as int;
        final controller = _inFlights[code];
        if (controller != null) {
          _inFlights.remove(code);
          controller
            ..add(registrationId)
            ..close();
        } else {
          print('unknown registered: $msg');
        }
        break;

      case WampCode.unregistered:
        final code = msg[1] as int;
        final controller = _inFlights[code];
        if (controller != null) {
          _inFlights.remove(code);
          controller
            ..add(null)
            ..close();
        } else {
          print('unknown registered: $msg');
        }
        break;

      case WampCode.invocation:
        _invocation(msg);
        break;

      case WampCode.result:
        final code = msg[1] as int;
        final controller = _inFlights[code];
        if (controller != null) {
          _inFlights.remove(code);
          final args = WampArgs._toWampArgs(msg, 3);
          controller
            ..add(args)
            ..close();
        } else {
          print('unknown result: $msg');
        }
        break;

      case WampCode.error:
        final cmd = msg[1] as int;
        switch (cmd) {
          case WampCode.call:
            final code = msg[2] as int;
            final controller = _inFlights[code];
            if (controller != null) {
              _inFlights.remove(code);
              final args = WampArgs._toWampArgs(msg, 5);
              controller
                ..addError(args)
                ..close();
            } else {
              print('unknown invocation error: $msg');
            }
            break;

          case WampCode.register:
            final code = msg[2] as int;
            final controller = _inFlights[code];
            if (controller != null) {
              _inFlights.remove(code);
              final args = msg[4] as String;
              controller
                ..addError(WampArgs(<dynamic>[args]))
                ..close();
            } else {
              print('unknown register error: $msg');
            }
            break;

          case WampCode.unregister:
            final code = msg[2] as int;
            final controller = _inFlights[code];
            if (controller != null) {
              _inFlights.remove(code);
              final args = msg[4] as String;
              controller
                ..addError(WampArgs(<dynamic>[args]))
                ..close();
            } else {
              print('unknown unregister error: $msg');
            }
            break;

          default:
            print('unimplemented error: $msg');
        }
        break;

      case WampCode.publish:
      case WampCode.subscribe:
      case WampCode.unsubscribe:
      case WampCode.call:
      case WampCode.register:
      case WampCode.unregister:
      case WampCode.yield:
        if (_sessionState == #shutting_down) {
          // ignore.
        } else if (_sessionState == #establishing) {
          _sessionState = #failed;
        } else {
          print('unimplemented: $msg');
        }
        break;

      case WampCode.challenge:
        // Authorizing the realm
        if (ticketAuth != null) {
          _ws.add(jsonEncode([WampCode.authenticate, ticketAuth.authId, {}]));
        }
        break;

      case WampCode.authenticate:
      case WampCode.cancel:
      case WampCode.interrupt:

      default:
        print('unexpected: $msg');
        break;
    }
  }

  void _invocation(List<dynamic> msg) {
    final code = msg[1] as int;
    final registrationId = msg[2] as int;
    final args = WampArgs._toWampArgs(msg);
    final procedure = _registrations[registrationId];
    if (procedure != null) {
      try {
        final result = procedure(args);
        _ws.add(jsonEncode([
          WampCode.yield,
          code,
          <String, dynamic>{},
          result.args,
          result.params
        ]));
      } on WampArgs catch (ex) {
        print('ex=$ex');
        _ws.add(jsonEncode([
          WampCode.error,
          WampCode.invocation,
          code,
          <String, dynamic>{},
          'wamp.error',
          ex.args,
          ex.params
        ]));
      } catch (ex) {
        _ws.add(jsonEncode([
          WampCode.error,
          WampCode.invocation,
          code,
          <String, dynamic>{},
          'error'
        ]));
      }
    } else {
      print('unknown invocation: $msg');
    }
  }

  void _hello() {
    if (_sessionState != #closed) {
      throw Exception('cant send Hello after session established.');
    }

    _ws.add(jsonEncode([
      WampCode.hello,
      realm,
      {
        'roles': defaultClientRoles,
        if (ticketAuth != null) 'authMethods': ['ticket'],
      },
    ]));

    _sessionState = #establishing;
  }

  void disconnect() {
    try {
      _sessionState = #closed;
      _ws?.close();
    } catch (e) {
      // nothing to do here
    }
  }

  void goodbye([Map<String, dynamic> details = const <String, dynamic>{}]) {
    if (_sessionState != #established && _sessionState != #closing) {
      throw Exception('cant send Goodbye before session established.');
    }

    void sendGoodbye(String reason, Symbol next) {
      _ws.add(jsonEncode([
        WampCode.goodbye,
        details,
        reason,
      ]));
      _sessionState = next;
    }

    if (_sessionState == #established) {
      sendGoodbye('wamp.error.close_realm', #shutting_down);
    } else {
      sendGoodbye('wamp.error.goodbye_and_out', #closed);
    }
  }

//  void _abort([Map<String, dynamic> details = const <String, dynamic>{}]) {
//    if (_sessionState != #establishing) {
//      throw Exception('cant send Goodbye before session established.');
//    }
//
//    _ws.add(jsonEncode([
//      WampCode.abort,
//      details,
//      'abort',
//    ]));
//    _sessionState = #closed;
//  }

  /// register RPC at [uri] with [procedure].
  ///
  ///     wamp.register('your.rpc.name', (arg) {
  ///       print('got $arg');
  ///       return arg;
  ///     });
  Future<WampRegistration> register(
    String uri,
    WampProcedure procedure, [
    Map options = const <String, dynamic>{},
  ]) {
    final controller = StreamController<int>();
    _goFlight(controller, (code) => [WampCode.register, code, options, uri]);
    return controller.stream.last.then((registrationId) {
      _registrations[registrationId] = procedure;
      return WampRegistration(registrationId);
    });
  }

  /// unregister RPC [id].
  ///
  ///     wamp.unregister(your_rpc_id);
  // ignore: prefer_void_to_null
  Future<Null> unregister(WampRegistration reg) {
    final controller = StreamController<int>();
    _goFlight(controller, (code) => [WampCode.unregister, code, reg.id]);
    return controller.stream.last.then((dynamic _) {
      _registrations.remove(reg.id);
      return null;
    });
  }

  /// call RPC with [args] and [params].
  ///
  ///     wamp.call('your.rpc.name', ['myArg', 3], {'hello': 'world'})
  ///       .then((result) {
  ///         print('got result=$result');
  ///       })
  ///       .catchError((error) {
  ///         print('call error=$error');
  ///       });
  Future<WampArgs> call(
    String uri, [
    List<dynamic> args = const <dynamic>[],
    Map<String, dynamic> params = const <String, dynamic>{},
    Map options = const <String, dynamic>{},
  ]) {
    final controller = StreamController<WampArgs>();
    _goFlight(controller,
        (code) => [WampCode.call, code, options, uri, args, params]);
    return controller.stream.last;
  }

  /// subscribe [topic].
  ///
  ///     wamp.subscribe('topic').then((stream) async {
  ///       await for (var event in stream) {
  ///         print('event=$event');
  ///       }
  ///     });
  Future<Stream<WampEvent>> subscribe(
    String topic, [
    Map options = const <String, dynamic>{},
  ]) {
    final controller = StreamController<Stream<WampEvent>>();
    _goFlight(controller, (code) => [WampCode.subscribe, code, options, topic]);
    return controller.stream.last;
  }

  Future _unsubscribe(int subscriptionId) {
    _subscriptions.remove(subscriptionId);

    // ignore: prefer_void_to_null
    final controller = StreamController<Null>();
    if (_sessionState != #closed) {
      _goFlight(
          controller, (code) => [WampCode.unsubscribe, code, subscriptionId]);
    }
    return controller.stream.last;
  }

  /// publish [topic].
  ///
  ///     wamp.publish('topic');
  // ignore: prefer_void_to_null
  Future<Null> publish(
    String topic, [
    List<dynamic> args = const <dynamic>[],
    Map<String, dynamic> params = const <String, dynamic>{},
    Map options = const <String, dynamic>{},
  ]) {
    // ignore: prefer_void_to_null
    final controller = StreamController<Null>();
    final code = _goFlight(controller,
        (code) => [WampCode.publish, code, options, topic, args, params]);

    final dynamic acknowledge = options[_keyAcknowledge];
    if (acknowledge is bool && acknowledge) {
      return controller.stream.last;
    } else {
      _inFlights.remove(code);
      // ignore: prefer_void_to_null
      return Future<Null>.value(null);
    }
  }

  int _flightCode(StreamController<dynamic> val) {
    var code = 0;
    do {
      code = _random.nextInt(1000000000);
    } while (_inFlights.containsKey(code));

    _inFlights[code] = val;
    return code;
  }

  int _goFlight(
      StreamController<dynamic> controller, dynamic Function(int code) data) {
    final code = _flightCode(controller);
    try {
      _ws.add(jsonEncode(data(code)));
      return code;
    } catch (_) {
      _inFlights.remove(code);
      rethrow;
    }
  }
}
