import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';

import '../models/chat_model.dart';
import '../models/secret_model.dart';
import '../models/user_model.dart';
import 'remote_data_source.dart';

class RemoteDataSourceImpl implements RemoteDataSource {
  FirebaseFirestore instance;
  Client client;

  RemoteDataSourceImpl({required this.instance, required this.client});

  @override
  Future<void> addUser(UserModel user) async {
    try {
      final docUser = instance.collection("users").doc();
      await docUser.set({
        'id': docUser.id,
        'mail': user.mail,
        'userUid': user.userUid,
        'name': user.name,
        'emailVerified': user.emailVerified
      });
    } catch (e) {
      throw FirebaseException(
          code: "remote_datasource_impl-addUser",
          message: e.toString(),
          plugin: 'Firestore');
    }
  }

  @override
  Future<void> updateUserVerifiedEmail(UserModel user) async {
    try {
      await instance
          .collection("users")
          .doc(user.id)
          .update({"emailVerified": user.emailVerified});
    } catch (e) {
      throw FirebaseException(
          code: "remote_datasource_impl-updateUserVerifiedEmail",
          message: e.toString(),
          plugin: 'Firestore');
    }
  }

  @override
  Stream<List<UserModel>> getUser(UserModel user) {
    final collectionRef =
        instance.collection("users").where("userUid", isEqualTo: user.userUid);

    return collectionRef.snapshots().map((querySnap) => querySnap.docs
        .map((docSnap) => UserModel.fromSnapshot(docSnap.data()))
        .toList());
  }

  @override
  Future<void> updateChatMemory(ChatModel chat) async {
    try {
      await instance
          .collection("chats")
          .doc(chat.id)
          .update({"memory": chat.memory});
    } catch (e) {
      throw FirebaseException(
          code: "remote_datasource_impl-updateChatMemory",
          message: e.toString(),
          plugin: 'Firestore');
    }
  }

  @override
  Future<void> updateMessageFailure(ChatModel chat) async {
    try {
      await instance
          .collection("chats")
          .doc(chat.id)
          .update({"lastMessageFailed": chat.lastMessageFailed});
    } catch (e) {
      throw FirebaseException(
          code: "remote_datasource_impl-updateMessageFailure",
          message: e.toString(),
          plugin: 'Firestore');
    }
  }

  @override
  Future<void> updateChatSelection(ChatModel chat) async {
    try {
      await instance
          .collection("chats")
          .doc(chat.id)
          .update({"selected": chat.selected});
    } catch (e) {
      throw FirebaseException(
          code: "remote_datasource_impl-updateChatSelection",
          message: e.toString(),
          plugin: 'Firestore');
    }
  }

  @override
  Future<String> addChat(ChatModel chat) async {
    try {
      final docChat = instance.collection("chats").doc();
      await docChat.set({
        'creationDate': chat.creationDate,
        'id': docChat.id,
        'memory': chat.memory,
        'userUid': chat.userUid,
        'selected': chat.selected,
        'conversation': chat.conversation,
        'lastMessageFailed': chat.lastMessageFailed
      });
      return docChat.id;
    } catch (e) {
      throw FirebaseException(
          code: "remote_datasource_impl-addChat",
          message: e.toString(),
          plugin: 'Firestore');
    }
  }

  @override
  Future<void> deleteChat(ChatModel chat) async {
    try {
      await instance.collection("chats").doc(chat.id).delete();
    } catch (e) {
      throw FirebaseException(
          code: "remote_datasource_impl-deleteChat",
          message: e.toString(),
          plugin: 'Firestore');
    }
  }

  @override
  Future<void> deleteLastMessage(ChatModel chat, String lastInput) async {
    try {
      await instance.collection("chats").doc(chat.id).update({
        "conversation": FieldValue.arrayRemove([lastInput])
      });
    } catch (e) {
      throw FirebaseException(
          code: "remote_datasource_impl-deleteLastMessage",
          message: e.toString(),
          plugin: 'Firestore');
    }
  }

  @override
  Future<void> addMessageInConversation(ChatModel chat, String message) async {
    try {
      await instance.collection("chats").doc(chat.id).update({
        "conversation": FieldValue.arrayUnion([message])
      });
    } catch (e) {
      throw FirebaseException(
          code: "remote_datasource_impl-addMessageInConversation",
          message: e.toString(),
          plugin: 'Firestore');
    }
  }

  @override
  Stream<List<ChatModel>> getChats(String userUid) {
    final collectionRef =
        instance.collection("chats").where("userUid", isEqualTo: userUid);

    return collectionRef.snapshots().map((querySnap) => querySnap.docs
        .map((docSnap) => ChatModel.fromSnapshot(docSnap.data()))
        .toList());
  }

  @override
  Future<Map> sendChat(String input, var memory, var apiKey) async {
    try {
      final response = await client.post(
          Uri.https('chats2.herokuapp.com', '/chat'),
          body: jsonEncode({"input": input, "memory": memory}),
          headers: {
            'Authorization': apiKey,
            "Access-Control-Allow-Origin": "*",
            'Content-Type': 'application/json',
            'Accept': '*/*',
            'Accept-Encoding': 'gzip, deflate, br',
            'Connection': 'keep-alive'
          });

      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map;
        return decodedResponse;
      } else {
        throw UnimplementedError();
      }
    } catch (e) {
      throw UnimplementedError();
    } finally {
      client.close();
    }
  }

  @override
  Future<List<SecretsModel>> getSecrets() async {
    try {
      final secretsRef = instance
          .collection("secrets")
          .withConverter<SecretsModel>(
              fromFirestore: (snapshot, _) =>
                  SecretsModel.fromJson(snapshot.data()!),
              toFirestore: (data, _) => data.toJson());
      var querySnapshot = await secretsRef.get();
      var secretList = querySnapshot.docs.map((doc) => doc.data()).toList();
      return secretList;
    } catch (e) {
      throw FirebaseException(
          code: "remote_datasource_impl-getSecrets",
          message: e.toString(),
          plugin: 'Firestore');
    }
  }
}
