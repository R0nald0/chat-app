import 'dart:convert';

class Conversation {
  final int? id;
  final int idContact;
  final String lastMassage;
  final String? contactimageUrl;
  final DateTime timeLastMessage;
  final String contactName;
  Conversation({
    this.id,
    this.contactimageUrl,
    required this.idContact,
    required this.lastMassage,
    required this.timeLastMessage,
    required this.contactName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'contactimageUrl' :contactimageUrl,
      'idContact': idContact,
      'lastMassage': lastMassage,
      'timeLastMessage': timeLastMessage.millisecondsSinceEpoch,
      'contactName': contactName,
      
    };
  }

  factory Conversation.fromMap(Map<String, dynamic> map) {

    
    return switch (map) {
      {
        'id': final int id,
        'lastMassage': final String lastMassage,
        'timeLastMessage': final String timeLastMessage,
        'contactName': final String contactName,
        'idContact' : final int idContact,
        'contactimageUrl' : final String contactImageUrl
      } =>
        Conversation(
          id: id,
          contactimageUrl: contactImageUrl ,
          lastMassage:lastMassage,
          timeLastMessage: DateTime.parse(timeLastMessage),
          contactName: contactName,
          idContact: idContact
        ),
      _ => throw ArgumentError("Invalid Json"),
    };
  }

  String toJson() => json.encode(toMap());

  factory Conversation.fromJson(String source) =>
      Conversation.fromMap(json.decode(source));
}
