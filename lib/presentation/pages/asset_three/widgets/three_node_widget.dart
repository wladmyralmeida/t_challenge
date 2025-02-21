import 'package:flutter/material.dart';
import 'package:tractian_challenge/domain/models/three_node_model.dart';

class TreeNodeWidget extends StatelessWidget {
  final TreeNode node;
  final bool isExpanded;
  final VoidCallback onTap;

  const TreeNodeWidget({
    Key? key,
    required this.node,
    required this.isExpanded,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    switch (node.type) {
      case NodeType.location:
        iconData = Icons.location_on;
        break;
      case NodeType.asset:
        iconData = Icons.settings;
        break;
      case NodeType.component:
        iconData = Icons.build;
        break;
    }

    return ListTile(
      leading: Icon(iconData),
      title: Text(node.name),
      trailing: node.children.isNotEmpty
          ? Icon(isExpanded ? Icons.expand_less : Icons.expand_more)
          : null,
      onTap: onTap,
    );
  }
}
