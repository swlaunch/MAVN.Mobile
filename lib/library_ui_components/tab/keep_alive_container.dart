import 'package:flutter/material.dart';

class KeepAliveContainer extends StatefulWidget {
  const KeepAliveContainer(this.body);

  final Widget body;

  @override
  _KeepAliveContainerState createState() => _KeepAliveContainerState();
}

class _KeepAliveContainerState extends State<KeepAliveContainer>
    with AutomaticKeepAliveClientMixin<KeepAliveContainer> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(child: widget.body);
  }

  @override
  bool get wantKeepAlive => true;
}
