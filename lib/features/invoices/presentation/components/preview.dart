import 'package:financial_dashboard/features/common/components/custom_button.dart';
import 'package:financial_dashboard/features/common/components/custom_circular_progress_indicator.dart';
import 'package:financial_dashboard/features/common/components/custom_container.dart';
import 'package:financial_dashboard/features/common/components/sub_content_header.dart';
import 'package:financial_dashboard/features/common/cubits/pdf_cubit.dart';
import 'package:financial_dashboard/features/common/cubits/pdf_state.dart';
import 'package:financial_dashboard/features/invoices/presentation/components/custom_divider.dart';
import 'package:financial_dashboard/features/invoices/presentation/pages/create_invoice_page.dart';
import 'package:financial_dashboard/features/theme/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class Preview extends StatelessWidget {
  final CreateInvoiceController createInvoiceController;

  const Preview({super.key, required this.createInvoiceController});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Header preview
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _PreviewHeader(controller: createInvoiceController),
          ),
          Expanded(
            child: Container(
              color: AppColors.gray,
              width: double.infinity,
              child: BlocBuilder<PdfCubit, PdfState>(
                builder: (context, state) {
                  if (state is! PdfError) {
                    return Stack(
                      children: [
                        ValueListenableBuilder(
                          valueListenable: createInvoiceController,
                          builder: (context, value, _) {
                            if (value.isPDF) {
                              return _PdfMode(
                                createInvoiceController:
                                    createInvoiceController,
                              );
                            } else {
                              return _EmailMode(
                                controller: createInvoiceController,
                              );
                            }
                          },
                        ),
                        // TODO: หน้าแยก Build แทนการใช้ Stack
                        // จะทำให้ เมื่อ CustomCircularProgressIndicator
                        // ตัว Invoice preview หลักก็จะหายไป
                        // key ที่ set ไว้ก็หายเช่นกัน
                        if (state is PdfLoading)
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: AppColors.gray.withValues(alpha: 0.5),
                            child: Center(
                              child: SizedBox(
                                width: 48,
                                height: 48,
                                child: CustomCircularProgressIndicator(),
                              ),
                            ),
                          ),
                      ],
                    );
                  } else {
                    return Center(
                      child: Text(
                        "Has something wrong...",
                        style: TextStyle(
                          color: AppColors.tealDark,
                          fontSize: 24,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PdfMode extends StatelessWidget {
  const _PdfMode({required this.createInvoiceController});

  final CreateInvoiceController createInvoiceController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: RepaintBoundary(
          key: createInvoiceController.getPreviewWidgetKey,
          child: CustomContainer(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SizedBox(height: 8),
                // Invoice preview header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _InvoicePreviewHeader(
                    controller: createInvoiceController,
                  ),
                ),
                SizedBox(height: 8),
                CustomDivider(),
                SizedBox(height: 8),
                // Invoice address
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _InvoiceAddress(controller: createInvoiceController),
                ),
                SizedBox(height: 8),
                CustomDivider(),
                SizedBox(height: 8),
                // Invoice detail
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _PreviewInvoiceDetails(
                    controller: createInvoiceController,
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _PreviewFooter(),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailMode extends StatelessWidget {
  final CreateInvoiceController controller;

  const _EmailMode({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: CustomContainer(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: _InvoicePreviewHeader(controller: controller),
              ),
              CustomDivider(),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ValueListenableBuilder(
                  valueListenable: controller,
                  builder: (context, value, _) {
                    return Text(
                      value.emailBody,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: AppColors.black,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewFooter extends StatelessWidget {
  const _PreviewFooter();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Julia Corporation Finance Company, IND",
          style: TextStyle(color: AppColors.greyDark, fontSize: 12),
        ),
        Text(
          "+66 945083304",
          style: TextStyle(color: AppColors.greyDark, fontSize: 12),
        ),
      ],
    );
  }
}

class _PreviewInvoiceDetails extends StatelessWidget {
  final CreateInvoiceController controller;
  const _PreviewInvoiceDetails({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Invoice Details",
          style: TextStyle(color: AppColors.greyDark, fontSize: 14),
        ),
        SizedBox(height: 12),
        // Invoice detail table
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _InvoiceDetailTable(controller: controller),
        ),
        SizedBox(height: 8),
        _InvoicDetailsNote(),
      ],
    );
  }
}

class _InvoicDetailsNote extends StatelessWidget {
  const _InvoicDetailsNote();

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      enableBorder: false,
      color: AppColors.gray,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Notes",
            style: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          Text(
            "   • Payment is due by January 31, 2025",
            style: TextStyle(color: AppColors.greyDark, fontSize: 10),
          ),
          Text(
            "   • Include the invoice number in the payment reference to ensure accurate processing",
            style: TextStyle(color: AppColors.greyDark, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _InvoiceDetailTable extends StatelessWidget {
  final CreateInvoiceController controller;
  const _InvoiceDetailTable({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, _) {
        return Column(
          children: [
            _InvoiceDetailsHeader(),
            SizedBox(height: 24),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => SizedBox(height: 8),
              itemCount: value.invoiceItems.length,
              itemBuilder:
                  (context, index) => _InvoiceDetailsRow(
                    serviceName: value.invoiceItems[index].item,
                    quantity: value.invoiceItems[index].quantity,
                    unitPrice: value.invoiceItems[index].unitPrice,
                    total: value.invoiceItems[index].totalPrice,
                  ),
            ),
            SizedBox(height: 8),
            CustomDivider(),
            SizedBox(height: 8),
            _InvoiceDetailSumText(
              title: 'Subtotal',
              value: controller.getSubtotalInvoices(),
            ),
            SizedBox(height: 8),
            _InvoiceDetailSumText(
              title: 'Tax (${value.taxPercentage}%)',
              value: controller.getTaxSubtotalInvoices(),
            ),
            SizedBox(height: 8),
            _InvoiceDetailSumText(title: 'Discount', value: value.discount),
            SizedBox(height: 8),
            _InvoiceDetailSumText(
              title: 'Grand Total',
              value: controller.getGrandTotalInvoices(),
            ),
          ],
        );
      },
    );
  }
}

class _InvoiceDetailSumText extends StatelessWidget {
  final String title;
  final double value;
  const _InvoiceDetailSumText({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '\$${NumberFormat('#,###').format(value)}',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _InvoiceDetailsRow extends StatelessWidget {
  final String serviceName;
  final int quantity;
  final double unitPrice;
  final double total;
  const _InvoiceDetailsRow({
    required this.serviceName,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            serviceName,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Spacer(),
        Expanded(
          child: Text(
            quantity.toString(),
            style: TextStyle(
              color: AppColors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            '\$${NumberFormat('#,###').format(unitPrice)}',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            '\$${NumberFormat('#,###').format(total)}',
            textAlign: TextAlign.end,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _InvoiceDetailsHeader extends StatelessWidget {
  const _InvoiceDetailsHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            "Items/Service",
            style: TextStyle(
              color: AppColors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Spacer(),
        Expanded(
          child: Text(
            "Quantity",
            style: TextStyle(
              color: AppColors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            "Unit Price",
            style: TextStyle(
              color: AppColors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            "Total",
            textAlign: TextAlign.end,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _InvoiceAddress extends StatelessWidget {
  final CreateInvoiceController controller;
  const _InvoiceAddress({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Billed By:",
                style: TextStyle(color: AppColors.greyDark, fontSize: 14),
              ),
              Text(
                "Julia Corporation",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "789, Quantum Road, Floor 7,\nFutureville, Kingdom",
                style: TextStyle(color: AppColors.greyDark, fontSize: 14),
              ),
              SizedBox(height: 16),
              Text(
                "Date Issued:",
                style: TextStyle(color: AppColors.greyDark, fontSize: 14),
              ),
              ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, value, _) {
                  return Text(
                    value.dateIssued.toString(),
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Billed To:",
                style: TextStyle(color: AppColors.greyDark, fontSize: 14),
              ),
              ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, value, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value.currentClientInfo != null
                            ? value.currentClientInfo!.name
                            : "*********************",
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        value.currentClientInfo != null
                            ? value.currentClientInfo!.address
                            : "*********************",
                        style: TextStyle(
                          color: AppColors.greyDark,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 16),
              Text(
                "Date Issued:",
                style: TextStyle(color: AppColors.greyDark, fontSize: 14),
              ),
              ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, value, _) {
                  return Text(
                    value.dueDate.toString(),
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InvoicePreviewHeader extends StatelessWidget {
  final CreateInvoiceController controller;
  const _InvoicePreviewHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Invoice",
              style: TextStyle(
                color: AppColors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, value, chld) {
                return Text(
                  value.invoiceNumber.length > 1
                      ? "Invoice Number # INV ${value.invoiceNumber}"
                      : "Invoice Number # INV ********-***",
                  style: TextStyle(color: AppColors.greyDark, fontSize: 14),
                );
              },
            ),
          ],
        ),
        Image.asset('assets/images/logo.png', width: 48),
      ],
    );
  }
}

class _PreviewHeader extends StatelessWidget {
  final CreateInvoiceController controller;
  const _PreviewHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        SubContentHeaderBox(
          imagePath: 'assets/icons/view.png',
          title: "Preview",
        ),
        Spacer(),

        ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, value, _) {
            return Visibility(
              visible: value.isPDF,
              child: _LightDarkModePreview(onTap: (bool value) {}),
            );
          },
        ),
        _EmailPDFPreview(
          onTap: (bool value) {
            controller.toggleIsPDF();
          },
        ),
      ],
    );
  }
}

class _EmailPDFPreviewData {
  final String iconPath;
  final String title;

  _EmailPDFPreviewData({required this.iconPath, required this.title});
}

class _EmailPDFPreview extends StatefulWidget {
  final ValueChanged<bool> onTap;
  const _EmailPDFPreview({required this.onTap});

  @override
  State<_EmailPDFPreview> createState() => _EmailPDFPreviewState();
}

class _EmailPDFPreviewState extends State<_EmailPDFPreview> {
  final List<_EmailPDFPreviewData> taps = [
    _EmailPDFPreviewData(iconPath: 'assets/icons/message.png', title: 'Email'),
    _EmailPDFPreviewData(iconPath: 'assets/icons/file_dock.png', title: 'PDF'),
  ];

  int selectedIndex = 1;
  void onTap(int index) {
    widget.onTap(index == 1);
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.gray,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          ...List.generate(taps.length, (index) {
            return CustomButton(
              onTap: () {
                onTap(index);
              },
              borderRadius: BorderRadius.circular(6),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              enableTap: selectedIndex != index,
              color: selectedIndex != index ? AppColors.gray : AppColors.white,

              splashColor: Colors.transparent,
              enableColorHover: false,
              enableBorder: false,
              child: Row(
                spacing: 4,
                children: [
                  ImageIcon(
                    AssetImage(taps[index].iconPath),
                    color: AppColors.black,
                    size: 16,
                  ),
                  Text(
                    taps[index].title,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _LightDarkModePreview extends StatefulWidget {
  final ValueChanged<bool> onTap;
  const _LightDarkModePreview({required this.onTap});

  @override
  State<_LightDarkModePreview> createState() => _LightDarkModePreviewState();
}

class _LightDarkModePreviewState extends State<_LightDarkModePreview> {
  final List<String> taps = ['assets/icons/sun.png', 'assets/icons/moon.png'];

  int selectedIndex = 1;
  void onTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.gray,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          ...List.generate(taps.length, (index) {
            return CustomButton(
              onTap: () {
                onTap(index);
              },
              borderRadius: BorderRadius.circular(6),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              enableTap: selectedIndex != index,
              color: selectedIndex != index ? AppColors.gray : AppColors.white,

              splashColor: Colors.transparent,
              enableColorHover: false,
              enableBorder: false,
              child: ImageIcon(
                AssetImage(taps[index]),
                color: AppColors.black,
                size: 16,
              ),
            );
          }),
        ],
      ),
    );
  }
}
