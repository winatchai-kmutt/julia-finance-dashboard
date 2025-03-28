import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dashboard/features/invoices/domain/entities/client_info.dart';
import 'package:financial_dashboard/features/invoices/domain/repos/client_info_repo.dart';

class FirebaseClientInfoRepo implements ClientInfoRepo {
  final collectionReference = FirebaseFirestore.instance.collection(
    'client_infos',
  );

  @override
  Future addClientInfo(ClientInfo clientInfo) async {
    try {
      await collectionReference.doc(clientInfo.uid).set(clientInfo.toJson());
    } catch (e) {
      throw Exception("Error adding client info: $e");
    }
  }

  @override
  Future<List<ClientInfo>> fetchClientInfos() async {
    try {
      final allClientInfos = await collectionReference.get();

      // convert Json to ClientInfo List
      final clientInfos =
          allClientInfos.docs.map((doc) {
            return ClientInfo.fromJson(json: doc.data());
          }).toList();

      return clientInfos;
    } catch (e) {
      throw Exception("Error fetching client infos: $e");
    }
  }
}
