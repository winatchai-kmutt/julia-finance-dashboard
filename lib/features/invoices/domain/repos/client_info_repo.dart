import 'package:financial_dashboard/features/invoices/domain/entities/client_info.dart';

abstract class ClientInfoRepo {
  // Fetch all clients info
  Future<List<ClientInfo>> fetchClientInfos();

  // Add client info
  Future addClientInfo(ClientInfo clientInfo);
}
