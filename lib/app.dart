import 'package:financial_dashboard/config/app_router.dart';
import 'package:financial_dashboard/features/auth/data/firebase_auth_repo.dart';
import 'package:financial_dashboard/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:financial_dashboard/features/common/cubits/pdf_cubit.dart';
import 'package:financial_dashboard/features/image_storage/data/api_image_storage_repo.dart';
import 'package:financial_dashboard/features/invoices/data/firebase_client_info_repo.dart';
import 'package:financial_dashboard/features/invoices/presentation/cubits/client_info_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initial repo
    final authRepo = FirebaseAuthRepo();
    final clientInfoRepo = FirebaseClientInfoRepo();
    final imageStorageRepo = ApiImageStorageRepo();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authRepo: authRepo)..checkAuth(),
        ),

        BlocProvider<ClientInfoCubit>(
          create:
              (context) => ClientInfoCubit(
                clientInfoRepo: clientInfoRepo,
                imageStorageRepo: imageStorageRepo,
              ),
        ),

        BlocProvider<PdfCubit>(create: (context) => PdfCubit()),
      ],

      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Julia Corporation',
        routerConfig: goRoouter,
        theme: ThemeData(textTheme: GoogleFonts.nunitoTextTheme()),
      ),
    );
  }
}
