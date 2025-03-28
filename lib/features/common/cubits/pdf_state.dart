abstract class PdfState {}

// Initial state
class PdfInitial extends PdfState {}

// Loading state
class PdfLoading extends PdfState {}

// Error state
class PdfError extends PdfState {
  final String message;
  PdfError({required this.message});
}

// Success state
class PdfLoaded extends PdfState {}
