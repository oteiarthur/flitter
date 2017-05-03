library flitter.common.chat_room_widget;

import 'dart:async';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flitter/intl/messages_all.dart' as intl;

class ChatRoomWidget extends StatefulWidget {
  final List<Message> messages;
  final StreamController<Null> _onNeedData;

  @override
  _ChatRoomWidgetState createState() => new _ChatRoomWidgetState();

  ChatRoomWidget({@required this.messages: const []})
      : _onNeedData = new StreamController();

  Stream<Null> get onNeedDataStream => onNeedDataController.stream;
  StreamController<Null> get onNeedDataController => _onNeedData;
}

class _ChatRoomWidgetState extends State<ChatRoomWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.white,
      child: new ListView.builder(
        reverse: true,
        itemCount: widget.messages.length,
        itemBuilder: (BuildContext context, int index) {
          Message message = widget.messages[index];
          if (index == widget.messages.length - 5) {
            widget.onNeedDataController.add(null);
          }
          return new ChatMessageWidget(
            leading: new CircleAvatar(
                backgroundImage:
                    new NetworkImage(message.fromUser.avatarUrlSmall)),
            body: new Text(message.text, softWrap: true),
            title:
                "${message.fromUser.displayName} - @${message.fromUser.username}",
          );
        },
      ),
    );
  }
}

class ChatInput extends StatefulWidget {
  final ValueChanged<String> onSubmit;

  ChatInput({@required this.onSubmit});

  @override
  _ChatInputState createState() => new _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  TextEditingController textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Form(
      child: new Container(
        padding: new EdgeInsets.only(left: 8.0, right: 8.0),
        child: new TextField(
          controller: textController,
          decoration: new InputDecoration(hintText: intl.typeChatMessage()),
          onSubmitted: (String value) {
            textController.clear();
            widget.onSubmit(value);
          },
        ),
      ),
    );
  }
}

class ChatMessageWidget extends StatelessWidget {
  final Widget leading;
  final String title;
  final Widget body;

  ChatMessageWidget(
      {@required this.leading, @required this.body, @required this.title});

  TextStyle _titleTextStyle() {
    return new TextStyle(color: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    final children = [];
    children.add(new Column(children: [
      new Container(
          margin: new EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
          width: 40.0,
          child: leading)
    ], crossAxisAlignment: CrossAxisAlignment.start));
    final content = new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new AnimatedDefaultTextStyle(
              style: _titleTextStyle(),
              duration: kThemeChangeDuration,
              child: new Container(
                  padding: new EdgeInsets.only(bottom: 6.0),
                  child: new Text(title, softWrap: true))),
          body
        ]);
    children.add(new Expanded(child: content));
    return new Column(children: [
      new Padding(
          child: new Row(
              children: children, crossAxisAlignment: CrossAxisAlignment.start),
          padding: new EdgeInsets.only(bottom: 8.0, top: 8.0, right: 12.0)),
      new Divider(height: 1.0, color: Colors.grey[200])
    ]);
  }
}
