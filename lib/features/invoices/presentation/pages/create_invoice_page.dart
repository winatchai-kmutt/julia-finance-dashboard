import 'package:financial_dashboard/features/common/cubits/pdf_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:financial_dashboard/features/common/components/custom_circular_progress_indicator.dart';
import 'package:financial_dashboard/features/common/components/light_button.dart';
import 'package:financial_dashboard/features/invoices/domain/entities/client_info.dart';
import 'package:financial_dashboard/features/invoices/presentation/components/invoice_detail.dart';
import 'package:financial_dashboard/features/invoices/presentation/components/preview.dart';
import 'package:financial_dashboard/features/invoices/presentation/cubits/client_info_cubit.dart';
import 'package:financial_dashboard/features/invoices/presentation/cubits/client_info_state.dart';
import 'package:financial_dashboard/features/theme/light_mode.dart';
import 'package:url_launcher/url_launcher.dart';

class CreateInvoicePage extends StatefulWidget {
  const CreateInvoicePage({super.key});

  @override
  State<CreateInvoicePage> createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends State<CreateInvoicePage> {
  late CreateInvoiceController createInvoiceController;

  @override
  void initState() {
    super.initState();
    createInvoiceController = CreateInvoiceController();

    // BLOC get client infos
    context.read<ClientInfoCubit>().fetchClientInfos();

    // Initilize textFieldController
    createInvoiceController.textFieldControllersInitialize(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientInfoCubit, ClientInfoState>(
      builder: (context, state) {
        if (state is ClientInfoLoaded) {
          createInvoiceController.updateClientInfos(state.clientInfos);
          return Column(
            spacing: 8,
            children: [
              // header
              _Header(controller: createInvoiceController),

              // Invoice Detail, Preview
              Expanded(
                child: Row(
                  spacing: 8,
                  children: [
                    // Invoice
                    Expanded(
                      flex: 10,
                      child: InvoiceDetail(
                        createInvoiceController: createInvoiceController,
                      ),
                    ),

                    // Preview
                    Expanded(
                      flex: 10,
                      child: Preview(
                        createInvoiceController: createInvoiceController,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
          // If ClientInfoLoading or ClientInfoInitial
        } else if (state is ClientInfoLoading || state is ClientInfoInitial) {
          return Center(child: CustomCircularProgressIndicator());
        } else {
          // If ClientInfoError
          // TODO context.go to Error page
          return Center(
            child: Text(
              "Has something wrong...",
              style: TextStyle(color: AppColors.tealDark, fontSize: 24),
            ),
          );
        }
      },
    );
  }
}

class InvoiceItem {
  final String item;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  InvoiceItem({
    required this.item,
    required this.quantity,
    required this.unitPrice,
  }) : totalPrice = quantity * unitPrice;

  @override
  bool operator ==(covariant InvoiceItem other) {
    if (identical(this, other)) return true;

    return other.item == item &&
        other.quantity == quantity &&
        other.unitPrice == unitPrice &&
        other.totalPrice == totalPrice;
  }

  @override
  int get hashCode {
    return item.hashCode ^
        quantity.hashCode ^
        unitPrice.hashCode ^
        totalPrice.hashCode;
  }
}

class CreateInvoiceValues {
  final String dateIssued;
  final String dueDate;
  final String invoiceNumber;
  final double taxPercentage;
  final double discount;
  final String? currency;
  final List<ClientInfo> clientInfos;
  final ClientInfo? currentClientInfo;
  final List<InvoiceItem> invoiceItems;
  final bool isPDF;
  final String emailBody;

  CreateInvoiceValues({
    required this.dateIssued,
    required this.dueDate,
    required this.invoiceNumber,
    required this.taxPercentage,
    required this.discount,
    this.currency,
    required this.clientInfos,
    this.currentClientInfo,
    required this.invoiceItems,
    required this.isPDF,
    required this.emailBody,
  });

  CreateInvoiceValues copyWith({
    String? dateIssued,
    String? dueDate,
    String? invoiceNumber,
    double? taxPercentage,
    double? discount,
    String? currency,
    List<ClientInfo>? clientInfos,
    ClientInfo? currentClientInfo,
    List<InvoiceItem>? invoiceItems,
    bool? isPDF,
    String? emailBody,
  }) {
    return CreateInvoiceValues(
      dateIssued: dateIssued ?? this.dateIssued,
      dueDate: dueDate ?? this.dueDate,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      taxPercentage: taxPercentage ?? this.taxPercentage,
      discount: discount ?? this.discount,
      currency: currency ?? this.currency,
      clientInfos: clientInfos ?? this.clientInfos,
      currentClientInfo: currentClientInfo ?? this.currentClientInfo,
      invoiceItems: invoiceItems ?? this.invoiceItems,
      isPDF: isPDF ?? this.isPDF,
      emailBody: emailBody ?? this.emailBody,
    );
  }
}

class CreateInvoiceController extends ValueNotifier<CreateInvoiceValues> {
  CreateInvoiceController()
    : super(
        CreateInvoiceValues(
          dateIssued: DateFormat('MMMM d, yyyy').format(DateTime.now()),
          dueDate: DateFormat(
            'MMMM d, yyyy',
          ).format(DateTime.now().add(Duration(days: 30))),
          invoiceNumber: '',
          clientInfos: [],
          invoiceItems: [
            InvoiceItem(
              item: "Cloud Hosting Subscription",
              quantity: 1,
              unitPrice: 3500,
            ),
            InvoiceItem(
              item: "Data analytics Report",
              quantity: 2,
              unitPrice: 750,
            ),
            InvoiceItem(
              item: "On-Site Technical support",
              quantity: 1,
              unitPrice: 400,
            ),
          ],
          taxPercentage: 7,
          discount: 0,
          isPDF: true,
          emailBody: '',
        ),
      );

  late BuildContext _context;

  final dateIssuedTextField = TextEditingController();
  final dueDateTextField = TextEditingController();
  final invoiceNumberTextField = TextEditingController();
  final tagPercentageTextField = TextEditingController();
  final discountTextField = TextEditingController();

  final GlobalKey previewWidgetKey = GlobalKey();

  // ต้อง Initial แค่ครั้งเดียว เพราะ ต้องบันทึก state ข้อความเดิมไว้ตอลด
  void textFieldControllersInitialize({required BuildContext context}) {
    // Initial context for bloc
    _context = context;

    // Initial Default date
    dateIssuedTextField.text = value.dateIssued;
    dueDateTextField.text = value.dueDate;
    tagPercentageTextField.text = value.taxPercentage.toString();

    // Initial body email
    updateEmailBody();

    // Initial TextField controller Listenable for realtime reflex to Preview PDF
    dateIssuedTextField.addListener(() {
      value = value.copyWith(dateIssued: dateIssuedTextField.text);
      updateEmailBody();
    });

    dueDateTextField.addListener(() {
      value = value.copyWith(dueDate: dueDateTextField.text);
      updateEmailBody();
    });

    invoiceNumberTextField.addListener(() {
      value = value.copyWith(invoiceNumber: invoiceNumberTextField.text);
      updateEmailBody();
    });

    tagPercentageTextField.addListener(() {
      value = value.copyWith(
        taxPercentage: double.tryParse(tagPercentageTextField.text),
      );
      updateEmailBody();
    });
    discountTextField.addListener(() {
      value = value.copyWith(discount: double.tryParse(discountTextField.text));
      updateEmailBody();
    });
  }

  // update ทุกครั้งที่ fetch มาใหม่
  void updateClientInfos(List<ClientInfo> clientInfos) {
    // Update list of client info
    value = value.copyWith(clientInfos: clientInfos);

    // Update current ClientInfo from update clinent info
    if (value.clientInfos.isNotEmpty) {
      value = value.copyWith(currentClientInfo: clientInfos.last);
    }
  }

  void updateClientInfoSelected(ClientInfo clientInfo) {
    value = value.copyWith(currentClientInfo: clientInfo);
    updateEmailBody();
  }

  void addInvoiceItem(InvoiceItem invoiceItem) {
    value = value.copyWith(invoiceItems: [...value.invoiceItems, invoiceItem]);
    updateEmailBody();
  }

  void deleteInvoiceItem(InvoiceItem invoiceItem) {
    value = value.copyWith(
      invoiceItems:
          value.invoiceItems.where((item) => item != invoiceItem).toList(),
    );
    updateEmailBody();
  }

  void toggleIsPDF() {
    value = value.copyWith(isPDF: !value.isPDF);
  }

  // When User Add New Client UI
  // addClientInfo: add + fetch -> trigger  rebuild and update
  void addClientInfo({
    required ClientInfo clientInfo,
    required Uint8List bytesLogo,
  }) {
    _context.read<ClientInfoCubit>().addClientInfo(clientInfo, bytesLogo);
  }

  double getSubtotalInvoices() {
    double subtotal = 0;
    value.invoiceItems.forEach(
      ((invoiceItems) => subtotal += invoiceItems.totalPrice),
    );
    return subtotal;
  }

  double getTaxSubtotalInvoices() {
    return (getSubtotalInvoices() / 100) * value.taxPercentage;
  }

  double getGrandTotalInvoices() {
    return getSubtotalInvoices() + getTaxSubtotalInvoices() + value.discount;
  }

  void generatePdfAndDownload() {
    _context.read<PdfCubit>().generatePdfAndDownload(previewWidgetKey);
  }

  void updateEmailBody() {
    final String emailBody = '''
Dear Finance Team,

Please find the details of the invoice below:

Invoice Number: INV ${value.invoiceNumber}
Billed By: Julia Corporation
Address: 789, Quantum Road, Floor 7, Futureville, Kingdom

Billed To: ${value.currentClientInfo?.name ?? '*****'}
Address: ${value.currentClientInfo?.address ?? '*****'}

Date Issued: ${value.dateIssued}

Invoice Details:
${value.invoiceItems.map((invoiceItem) => "- ${invoiceItem.item}: ${invoiceItem.quantity} x \$${invoiceItem.unitPrice.toStringAsFixed(2)} = \$${invoiceItem.totalPrice.toStringAsFixed(1)}").join('\n')}

Subtotal:  \$${getSubtotalInvoices()}
Tax (${value.taxPercentage}%):  \$${getTaxSubtotalInvoices()}
Discount:  \$${value.discount}
Grand Total:  \$${getGrandTotalInvoices()}

Payment is due by ${value.dueDate}.
Please include the invoice number in the payment reference.

Best regards,
Julia Corporation Finance Team
+66 945083304
''';
    value = value.copyWith(emailBody: emailBody);
  }

  void sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'finance@apple.com', // เปลี่ยนเป็นอีเมลปลายทาง
      // queryParameters: {
      //   'subject': 'Invoice INV ${value.invoiceNumber}',
      //   'body': value.emailBody,
      // },
      query: encodeQueryParameters({
        'subject': 'Invoice INV ${value.invoiceNumber}',
        'body': value.emailBody,
      }),
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch email client.");
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  // Gatters
  GlobalKey get getPreviewWidgetKey => previewWidgetKey;
  bool get isClientInfosEmpty => value.clientInfos.isEmpty;
  TextEditingController get dateIssuedTextFieldController =>
      dateIssuedTextField;
  TextEditingController get dueDateTextFieldController => dueDateTextField;
  TextEditingController get invoiceNumberTextFieldController =>
      invoiceNumberTextField;
  TextEditingController get tagPercentageTextFieldController =>
      tagPercentageTextField;
  TextEditingController get discountTextFieldController => discountTextField;
}

class _Header extends StatelessWidget {
  final CreateInvoiceController controller;
  const _Header({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 2,
          children: [
            Row(
              spacing: 2,
              children: [
                Text(
                  "Invoices",
                  style: TextStyle(color: AppColors.black, fontSize: 12),
                ),
                ImageIcon(
                  AssetImage('assets/icons/expand_right.png'),
                  size: 16,
                  color: AppColors.black,
                ),
                Text(
                  "Create",
                  style: TextStyle(color: AppColors.greyDark, fontSize: 12),
                ),
              ],
            ),
            Text(
              "Create New Invoice",
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Spacer(),
        LightButton(
          title: "Save as Draft",
          imageIconPath: 'assets/icons/arhive_alt_export.png',
        ),
        SizedBox(width: 8),

        ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, value, _) {
            return LightButton(
              onTap: () async {
                if (value.isPDF) {
                  controller.generatePdfAndDownload();
                } else {
                  controller.sendEmail();
                }
              },
              color: AppColors.tealDark,
              contentColor: AppColors.white,
              title: value.isPDF ? "Save as PDF" : "Send Invoices",
              imageIconPath: 'assets/icons/line_out.png',
            );
          },
        ),
      ],
    );
  }
}
