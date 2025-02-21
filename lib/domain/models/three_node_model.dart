enum NodeType { location, asset, component }

class TreeNode {
  final String id;
  final String name;
  final NodeType type;
  final String? parentId;
  final String? sensorType;
  final String? status;
  final List<TreeNode> children;

  TreeNode({
    required this.id,
    required this.name,
    required this.type,
    this.parentId,
    this.sensorType,
    this.status,
    this.children = const [],
  });

  TreeNode copyWith({List<TreeNode>? children}) {
    return TreeNode(
      id: id,
      name: name,
      type: type,
      parentId: parentId,
      sensorType: sensorType,
      status: status,
      children: children ?? this.children,
    );
  }
}
