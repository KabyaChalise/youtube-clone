import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscribeRepository {
  FirebaseFirestore firestore;
  SubscribeRepository({
    required this.firestore,
  });

  Future<void> subscribeChannel({
    required channelId,
    required currentUserId,
    required List subscriptions,
  }) async {
    if (subscriptions.contains(currentUserId)) {
      await firestore.collection('channels').doc(channelId).update({
        'subscriptions': FieldValue.arrayRemove([currentUserId])
      });
      
    }
    if (!subscriptions.contains(currentUserId)) {
     await  firestore.collection('channels').doc(channelId).update({
        'subscriptions': FieldValue.arrayUnion([currentUserId])
      });
      
    }
  }
}
final subscribeChannelProvider = Provider((ref) => SubscribeRepository(firestore: FirebaseFirestore.instance));