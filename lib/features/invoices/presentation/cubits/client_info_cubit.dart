import 'package:financial_dashboard/features/image_storage/domain/repos/image_storage_repo.dart';
import 'package:financial_dashboard/features/invoices/domain/entities/client_info.dart';
import 'package:financial_dashboard/features/invoices/domain/repos/client_info_repo.dart';
import 'package:financial_dashboard/features/invoices/presentation/cubits/client_info_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class ClientInfoCubit extends Cubit<ClientInfoState> {
  final ClientInfoRepo clientInfoRepo;
  final ImageStorageRepo imageStorageRepo;

  ClientInfoCubit({
    required this.clientInfoRepo,
    required this.imageStorageRepo,
  }) : super(ClientInfoInitial());

  Future<void> fetchClientInfos() async {
    try {
      emit(ClientInfoLoading());

      final clientInfos = await clientInfoRepo.fetchClientInfos();

      emit(ClientInfoLoaded(clientInfos: clientInfos));
    } catch (e) {
      emit(ClientInfoError(message: "Error fetching client infos"));
    }
  }

  Future<void> addClientInfo(
    ClientInfo clientInfo,
    Uint8List bytesImage,
  ) async {
    try {
      emit(ClientInfoLoading());

      // uploading image and get urlImage
      final logoUrl = await imageStorageRepo.uploadLogoClientImage(
        fileName: DateTime.now().microsecondsSinceEpoch.toString(),
        folderName: 'client_logos',
        bytesImage: bytesImage,
      );

      // Upload new clientInfo
      if (logoUrl != null) {
        clientInfo = clientInfo.copyWith(logoUrl: logoUrl);
        await clientInfoRepo.addClientInfo(clientInfo);
        fetchClientInfos();
      } else {
        emit(ClientInfoError(message: "Error uploading image"));
      }
    } catch (e) {
      emit(ClientInfoError(message: "Error adding client info"));
    }
  }
}
