import 'package:financial_dashboard/features/invoices/domain/entities/client_info.dart';

abstract class ClientInfoState {}

// Initial state
class ClientInfoInitial extends ClientInfoState {}

// Loading state
class ClientInfoLoading extends ClientInfoState {}

// Error state
class ClientInfoError extends ClientInfoState {
  final String message;
  ClientInfoError({required this.message});
}

// Success state
class ClientInfoLoaded extends ClientInfoState {
  final List<ClientInfo> clientInfos;
  ClientInfoLoaded({required this.clientInfos});
}
