import 'package:flutter/material.dart';
import 'package:tractian_challenge/domain/models/three_node_model.dart';
import 'package:tractian_challenge/presentation/pages/asset_three/widgets/three_node_widget.dart';

class TreeViewWidget extends StatefulWidget {
  final TreeNode node;
  final int level;

  const TreeViewWidget({Key? key, required this.node, this.level = 0})
      : super(key: key);

  @override
  _TreeViewWidgetState createState() => _TreeViewWidgetState();
}

class _TreeViewWidgetState extends State<TreeViewWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final hasChildren = widget.node.children.isNotEmpty;

    return Padding(
      padding: EdgeInsets.only(left: (widget.level * 16.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TreeNodeWidget(
            node: widget.node,
            isExpanded: _isExpanded,
            onTap: () {
              if (hasChildren) {
                setState(() => _isExpanded = !_isExpanded);
              }
            },
          ),
          if (_isExpanded)
            Column(
              children: widget.node.children
                  .map((child) =>
                      TreeViewWidget(node: child, level: widget.level + 1))
                  .toList(),
            ),
        ],
      ),
    );
  }
}
