library flitter.common.drawer;

import 'package:flitter/redux/store.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter/painting.dart';
import 'package:flitter/intl/messages_all.dart' as intl;
import 'package:flitter/auth.dart';
import 'package:flitter/routes.dart';

class FlitterDrawer extends StatefulWidget {
  final VoidCallback onTapAllConversation;
  final VoidCallback onTapPeoples;

  FlitterDrawer(
      {@required this.onTapAllConversation, @required this.onTapPeoples});

  @override
  _FlitterDrawerState createState() => new _FlitterDrawerState();
}

class _FlitterDrawerState extends State<FlitterDrawer> {
  @override
  Widget build(BuildContext context) {
    final child = [
      _buildDrawerHeader(context),
      new ListTile(
          leading: new Icon(Icons.home),
          title: new Text(intl.allConversations()),
          onTap: widget.onTapAllConversation),
      new ListTile(
          leading: new Icon(Icons.person),
          title: new Text(intl.people()),
          onTap: widget.onTapPeoples),
    ];

    child.addAll(_drawerCommunities(context));
    child.addAll(_drawerFooter(context));

    return new Drawer(child: new ListView(children: child));
  }

  ////////

  List<Widget> _drawerCommunities(BuildContext context) {
    final communities = <Widget>[
      new Divider(),
      new ListTile(title: new Text(intl.communities()), dense: true)
    ];

    communities.addAll(_buildCommunities(context));

    return communities;
  }

  List<Widget> _drawerFooter(BuildContext context) => [
        new Divider(),
        new ListTile(
            leading: new Icon(Icons.exit_to_app),
            title: new Text(intl.logout()),
            onTap: () {
              logout(context).then((_) {
                LoginView.go(context);
              });
            }),
      ];

  Widget _buildDrawerHeader(BuildContext context) =>
      new UserAccountsDrawerHeader(
          accountName: new Text(store.state.user.username),
          accountEmail: new Text(store.state.user.displayName),
          currentAccountPicture: new CircleAvatar(
              backgroundImage:
                  new NetworkImage(store.state.user.avatarUrlMedium)),
          decoration: new BoxDecoration(
              image: new DecorationImage(
                  image: new AssetImage('assets/images/banner.jpg'),
                  fit: BoxFit.cover)));

  List<Widget> _buildCommunities(BuildContext context) {
    return store.state.groups.map((group) {
      return new ListTile(
          dense: false,
          title: new Text(group.name),
          leading: new CircleAvatar(
              backgroundImage: new NetworkImage(group.avatarUrl),
              backgroundColor: Theme.of(context).canvasColor),
          trailing: null, //TODO: unread inside roomsOf(group)
          onTap: () {
            GroupRoomView.go(context, group);
          });
    }).toList();
  }
}
