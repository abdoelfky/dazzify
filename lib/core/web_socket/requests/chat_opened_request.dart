class ChatOpenedRequest {
  final String type;
  final String branchId;

  ChatOpenedRequest({this.type = 'chat', required this.branchId});

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "branchId": branchId,
    };
  }
}
