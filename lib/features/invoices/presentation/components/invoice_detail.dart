import 'dart:typed_data';

import 'package:financial_dashboard/features/common/components/custom_button.dart';
import 'package:financial_dashboard/features/common/components/custom_container.dart';
import 'package:financial_dashboard/features/common/components/light_button.dart';
import 'package:financial_dashboard/features/common/components/sub_content_header.dart';
import 'package:financial_dashboard/features/invoices/domain/entities/client_info.dart';
import 'package:financial_dashboard/features/invoices/presentation/components/custom_divider.dart';
import 'package:financial_dashboard/features/invoices/presentation/pages/create_invoice_page.dart';
import 'package:financial_dashboard/features/theme/light_mode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class InvoiceDetail extends StatelessWidget {
  final CreateInvoiceController createInvoiceController;
  const InvoiceDetail({super.key, required this.createInvoiceController});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubContentHeaderBox(
            imagePath: 'assets/icons/print.png',
            title: "Invoice Detail",
          ),
          SizedBox(height: 8),
          _InvoiceDetailTabBar(onTap: (value) {}),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 16),

                  _InvoiceInfo(
                    createInvoiceController: createInvoiceController,
                  ),

                  SizedBox(height: 8),

                  CustomDivider(),

                  SizedBox(height: 12),

                  _BilledTo(controller: createInvoiceController),

                  SizedBox(height: 12),

                  CustomDivider(),

                  SizedBox(height: 12),

                  InvoiceItems(controller: createInvoiceController),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showAddNewClientPopup(
  BuildContext context,
  void Function(String name, String email, String address, Uint8List logo)
  onSubmit,
) {
  showDialog(
    context: context,
    builder: (context) => AddNewClientFormPopup(onSubmit: onSubmit),
  );
}

void showAddNewItemPopup(
  BuildContext context,
  void Function(String item, int quantity, double unitPrice) onSubmit,
) {
  showDialog(
    context: context,
    builder: (context) => AddNewItemPopup(onSubmit: onSubmit),
  );
}

class _InvoiceDetailTabBar extends StatefulWidget {
  final ValueChanged<bool> onTap;
  const _InvoiceDetailTabBar({required this.onTap});

  @override
  State<_InvoiceDetailTabBar> createState() => _InvoiceDetailTabBarState();
}

class _InvoiceDetailTabBarState extends State<_InvoiceDetailTabBar> {
  final taps = ['Layout', 'General', 'Payment'];

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
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          ...List.generate(taps.length, (index) {
            return Expanded(
              child: CustomButton(
                onTap: () {
                  onTap(index);
                },
                enableTap: selectedIndex != index,
                color:
                    selectedIndex != index ? AppColors.gray : AppColors.white,
                splashColor: Colors.transparent,
                enableColorHover: false,
                enableBorder: false,
                child: Row(
                  spacing: 4,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      taps[index],
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _InvoiceInfo extends StatelessWidget {
  final CreateInvoiceController createInvoiceController;

  const _InvoiceInfo({required this.createInvoiceController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Invoice information",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Invoice Number",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        _InvoiceTextField(
          controller: createInvoiceController.invoiceNumberTextField,
        ),
        SizedBox(height: 8),
        Row(
          spacing: 8,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Date Issued",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  _InvoiceDateField(
                    controller: createInvoiceController.dateIssuedTextField,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Due Date",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  _InvoiceDateField(
                    controller: createInvoiceController.dueDateTextField,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InvoiceDateField extends StatefulWidget {
  final TextEditingController controller;

  const _InvoiceDateField({required this.controller});

  @override
  _InvoiceDateFieldState createState() => _InvoiceDateFieldState();
}

class _InvoiceDateFieldState extends State<_InvoiceDateField> {
  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Default is today
      firstDate: DateTime(2000), // Minimum selectable date
      lastDate: DateTime(2050), // Maximum selectable date
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color(0xFF015862), // สีหลักของ DatePicker
            hintColor: Color(0xFF015862), // สีของ hint text
            colorScheme: ColorScheme.light(
              primary: Color(0xFF015862), // สีของไฮไลต์
              onPrimary: Colors.white, // สีของตัวอักษรบนไฮไลต์
              surface: Colors.white, // สีพื้นหลังของ DatePicker
              onSurface: Colors.black, // สีตัวอักษรปกติ
            ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        widget.controller.text = DateFormat(
          'MMMM d, yyyy',
        ).format(pickedDate); // Format date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      readOnly: true, // Prevent manual text input
      onTap: () => _selectDate(context), // Open date picker when tapped
      cursorColor: AppColors.greyDark,
      style: TextStyle(color: AppColors.black, fontSize: 14),
      decoration: InputDecoration(
        suffixIcon: Padding(
          padding: EdgeInsets.all(8),
          child: GestureDetector(
            onTap:
                () => _selectDate(
                  context,
                ), // Also open picker when icon is tapped
            child: ImageIcon(
              AssetImage('assets/icons/calendar_add_duotone_line.png'),
              color: AppColors.greyDark,
            ),
          ),
        ),
        constraints: BoxConstraints(maxHeight: 36),
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
        hintText: DateFormat('MMMM d, yyyy').format(DateTime.now()),
        hintStyle: TextStyle(color: AppColors.black, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.gray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.gray, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.greyDark),
        ),
      ),
    );
  }
}

class _InvoiceTextField extends StatelessWidget {
  final TextEditingController controller;

  const _InvoiceTextField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: AppColors.greyDark,
      decoration: InputDecoration(
        suffixIcon: Padding(
          padding: EdgeInsets.all(8),
          child: ImageIcon(
            AssetImage('assets/icons/edit_duotone_line.png'),
            color: AppColors.greyDark,
          ),
        ),
        constraints: BoxConstraints(maxHeight: 36),
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
        hintText: "# INV-38323485-853",
        hintStyle: TextStyle(color: AppColors.greyDark, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.gray), // Default border color
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.gray,
            width: 1,
          ), // Border color when not focused
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.greyDark,
          ), // Border color when focused
        ),
      ),
    );
  }
}

void showClientListSelector({
  required BuildContext context,
  required ValueChanged<ClientInfo> onSelected,
  required List<ClientInfo> clientList,
}) {
  showDialog(
    context: context,
    builder:
        (context) =>
            ClientListSelector(onSelected: onSelected, clientList: clientList),
  );
}

class _BilledTo extends StatelessWidget {
  final CreateInvoiceController controller;
  const _BilledTo({required this.controller});

  @override
  Widget build(BuildContext context) {
    void onAddNewClientTap() {
      showAddNewClientPopup(context, (
        String name,
        String email,
        String address,
        Uint8List bytesLogo,
      ) {
        controller.addClientInfo(
          clientInfo: ClientInfo(
            uid: DateTime.now().microsecondsSinceEpoch.toString(),
            name: name,
            email: email,
            address: address,
            // Add url in bloc process
            logoUrl: '',
          ),
          bytesLogo: bytesLogo,
        );
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Billed To",
              style: TextStyle(
                color: AppColors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            InkWell(
              onTap: onAddNewClientTap,
              child: Text(
                "Add New Client",
                style: TextStyle(
                  color: AppColors.tealDark,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          "Client Infomation",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, value, _) {
            return _ClientInfoBox(
              isSeleted: true,
              onSelected: () {
                //If no has currentClientInfo ->
                if (controller.isClientInfosEmpty) {
                  onAddNewClientTap();
                  return;
                }
                showClientListSelector(
                  onSelected: (clientInfo) {
                    controller.updateClientInfoSelected(clientInfo);
                  },
                  context: context,
                  clientList: value.clientInfos,
                );
              },
              clientInfo: value.currentClientInfo,
            );
          },
        ),
      ],
    );
  }
}

class _ClientInfoBox extends StatelessWidget {
  final ClientInfo? clientInfo;
  final bool isSeleted;
  final VoidCallback onSelected;
  const _ClientInfoBox({
    required this.clientInfo,
    required this.onSelected,
    this.isSeleted = false,
  });

  @override
  Widget build(BuildContext context) {
    final enable = clientInfo != null;
    if (enable) {
      return CustomButton(
        padding: EdgeInsets.all(8),
        onTap: onSelected,
        child: Row(
          spacing: 12,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                clientInfo!.logoUrl,
                width: 36,
                height: 36,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  clientInfo!.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                    fontSize: 12,
                  ),
                ),
                Text(
                  clientInfo!.email,
                  style: TextStyle(color: AppColors.greyDark, fontSize: 12),
                ),
              ],
            ),
            if (isSeleted) Spacer(),
            if (isSeleted) ImageIcon(AssetImage('assets/icons/change.png')),
          ],
        ),
      );
    } else {
      return CustomButton(
        padding: EdgeInsets.all(8),
        onTap: onSelected,
        child: Row(
          spacing: 8,
          children: [
            Text(
              'Add New Client...',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.black,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }
  }
}

class ClientListSelector extends StatelessWidget {
  final ValueChanged<ClientInfo> onSelected;
  final List<ClientInfo> clientList;

  const ClientListSelector({
    super.key,
    required this.onSelected,
    required this.clientList,
  });

  @override
  Widget build(BuildContext context) {
    void onClientInfoBoxSeleted(ClientInfo clientInfo) {
      onSelected(clientInfo);
      context.pop();
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.gray, width: 2),
      ),
      clipBehavior: Clip.hardEdge,
      backgroundColor: AppColors.white,
      elevation: 2,
      title: Text('Select Client', style: TextStyle(color: AppColors.black)),
      content: SizedBox(
        // TODO: ไม่มี Responsive design เลยไม่รู้ว่าแสดงผลตามขนาดจอจอยังไง
        width: 500,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: clientList.length,
          itemBuilder: (context, index) {
            return _ClientInfoBox(
              clientInfo: clientList[index],
              onSelected: () {
                onClientInfoBoxSeleted(clientList[index]);
              },
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 8);
          },
        ),
      ),
    );
  }
}

class AddNewClientFormPopup extends StatefulWidget {
  final void Function(String name, String email, String address, Uint8List logo)
  onSubmit;

  const AddNewClientFormPopup({super.key, required this.onSubmit});

  @override
  State<AddNewClientFormPopup> createState() => _AddNewClientFormPopupState();
}

class _AddNewClientFormPopupState extends State<AddNewClientFormPopup> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  Uint8List? _bytesLogo;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      preferredCameraDevice: CameraDevice.front,
    );
    if (image != null) {
      final Uint8List imageData = await image.readAsBytes();
      setState(() {
        _bytesLogo = imageData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.gray, width: 2),
      ),
      clipBehavior: Clip.hardEdge,
      backgroundColor: AppColors.white,
      elevation: 2,
      title: Text(
        'Enter Client Information',
        style: TextStyle(color: AppColors.black),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CustomTextField(controller: _nameController, lebelText: 'Name'),
            SizedBox(height: 16),
            _CustomTextField(controller: _emailController, lebelText: 'Email'),
            SizedBox(height: 16),
            _CustomTextField(
              controller: _addressController,
              lebelText: 'Address',
            ),
            SizedBox(height: 16),
            _bytesLogo != null
                ? Image.memory(_bytesLogo!, height: 100)
                : SizedBox.shrink(),
            SizedBox(height: 12),

            CustomButton(
              onTap: _pickImage,
              child: Text(
                'Pick Company Logo',
                style: TextStyle(color: AppColors.black),
              ),
            ),
          ],
        ),
      ),
      actions: [
        CustomButton(
          enableBorder: false,
          onTap: () => context.pop(),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: AppColors.greyDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        CustomButton(
          enableBorder: false,
          onTap: () {
            if (_nameController.text.isEmpty &&
                _emailController.text.isEmpty &&
                _addressController.text.isEmpty &&
                _bytesLogo == null) {
              return;
            }
            widget.onSubmit(
              _nameController.text,
              _emailController.text,
              _addressController.text,
              _bytesLogo!,
            );
            context.pop();
          },
          child: Text(
            'Submit',
            style: TextStyle(
              color: AppColors.tealDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class AddNewItemPopup extends StatelessWidget {
  final void Function(String item, int quantity, double unitPrice) onSubmit;

  AddNewItemPopup({super.key, required this.onSubmit});

  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.gray, width: 2),
      ),
      clipBehavior: Clip.hardEdge,
      backgroundColor: AppColors.white,
      elevation: 2,
      title: Text(
        'Invoice items/Service',
        style: TextStyle(color: AppColors.black),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // TODO: Validation TextField
            _CustomTextField(
              controller: _itemController,
              lebelText: 'Item/Service',
            ),
            SizedBox(height: 16),
            _CustomTextField(
              controller: _quantityController,
              lebelText: 'Quantity',
              // int only
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            SizedBox(height: 16),
            _CustomTextField(
              controller: _unitPriceController,
              lebelText: 'Unit price',
              //TODO int, double
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
      actions: [
        CustomButton(
          enableBorder: false,
          onTap: () => context.pop(),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: AppColors.greyDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        CustomButton(
          enableBorder: false,
          onTap: () {
            if (_itemController.text.isEmpty &&
                _quantityController.text.isEmpty &&
                _unitPriceController.text.isEmpty) {
              return;
            }
            onSubmit(
              _itemController.text,
              int.parse(_quantityController.text),
              double.parse(_unitPriceController.text),
            );
            context.pop();
          },
          child: Text(
            'Submit',
            style: TextStyle(
              color: AppColors.tealDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String lebelText;
  final List<TextInputFormatter>? inputFormatters;

  const _CustomTextField({
    required this.controller,
    required this.lebelText,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: AppColors.greyDark,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: lebelText,
        labelStyle: TextStyle(color: AppColors.greyDark, fontSize: 12),
        constraints: BoxConstraints(maxHeight: 36),
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.gray), // Default border color
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.gray,
            width: 1,
          ), // Border color when not focused
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.greyDark,
          ), // Border color when focused
        ),
      ),
    );
  }
}

class InvoiceItems extends StatelessWidget {
  final CreateInvoiceController controller;
  const InvoiceItems({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Invoice Items/Service",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Currency",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        CustomButton(
          padding: EdgeInsets.all(8),
          onTap: () {},
          child: Row(
            spacing: 8,
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/usa.jpg',
                  width: 24,
                  height: 24,
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                'USD (\$)',
                style: TextStyle(color: AppColors.black, fontSize: 14),
              ),
              Spacer(),
              ImageIcon(AssetImage('assets/icons/expand_down_light.png')),
            ],
          ),
        ),
        SizedBox(height: 8),
        _HeadTable(),
        SizedBox(height: 4),
        ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, value, _) {
            return ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 4),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: value.invoiceItems.length,
              itemBuilder: (context, index) {
                return _RowTable(
                  invoiceItem: value.invoiceItems[index],
                  onDeletedTap:
                      (invoiceItem) =>
                          controller.deleteInvoiceItem(invoiceItem),
                );
              },
            );
          },
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: CustomDivider()),
            LightButton(
              onTap: () {
                showAddNewItemPopup(
                  context,
                  (String item, int quantity, double unitPrice) =>
                      controller.addInvoiceItem(
                        InvoiceItem(
                          item: item,
                          quantity: quantity,
                          unitPrice: unitPrice,
                        ),
                      ),
                );
              },
              title: 'Add New Items',
              imageIconPath: 'assets/icons/add_round.png',
              textStyle: TextStyle(
                color: AppColors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(child: CustomDivider()),
          ],
        ),
        SizedBox(height: 16),
        Row(
          spacing: 8,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tax Percentage",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  _TaxTextField(controller: controller.tagPercentageTextField),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "Discount",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: ' (Optional)',
                          style: TextStyle(
                            color: AppColors.greyDark,
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  _DiscountTextField(controller: controller.discountTextField),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RowTable extends StatelessWidget {
  final InvoiceItem invoiceItem;
  final ValueChanged<InvoiceItem> onDeletedTap;

  const _RowTable({required this.invoiceItem, required this.onDeletedTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Expanded(
          flex: 10,
          child: CustomContainer(
            child: Text(
              invoiceItem.item,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: AppColors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 9,
          child: Row(
            spacing: 8,
            children: [
              Expanded(
                flex: 3,
                child: CustomContainer(
                  child: Text(
                    invoiceItem.quantity.toString(),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: CustomContainer(
                  child: Text(
                    '\$${NumberFormat('#,###').format(invoiceItem.unitPrice)}',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: IconButton(
                  onPressed: () {
                    onDeletedTap(invoiceItem);
                  },
                  icon: ImageIcon(AssetImage("assets/icons/trash_light.png")),
                  color: AppColors.greyDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeadTable extends StatelessWidget {
  const _HeadTable();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 10,
          child: Text(
            "Items",
            style: TextStyle(
              color: AppColors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          flex: 9,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  "Quantity",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  "Unit Price",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacer(flex: 2),
            ],
          ),
        ),
      ],
    );
  }
}

class _TaxTextField extends StatelessWidget {
  final TextEditingController controller;
  const _TaxTextField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: AppColors.greyDark,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.percent, color: AppColors.greyDark, size: 16),
        constraints: BoxConstraints(maxHeight: 36),
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
        hintText: "Enter Tax Percentage",
        hintStyle: TextStyle(color: AppColors.greyDark, fontSize: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.gray), // Default border color
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.gray,
            width: 1,
          ), // Border color when not focused
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.greyDark,
          ), // Border color when focused
        ),
      ),
    );
  }
}

class _DiscountTextField extends StatelessWidget {
  final TextEditingController controller;

  const _DiscountTextField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: AppColors.greyDark,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.paid_outlined,
          color: AppColors.greyDark,
          size: 16,
        ),
        constraints: BoxConstraints(maxHeight: 36),
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
        hintText: "Enter discount amount",
        hintStyle: TextStyle(color: AppColors.greyDark, fontSize: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.gray), // Default border color
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.gray,
            width: 1,
          ), // Border color when not focused
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.greyDark,
          ), // Border color when focused
        ),
      ),
    );
  }
}
