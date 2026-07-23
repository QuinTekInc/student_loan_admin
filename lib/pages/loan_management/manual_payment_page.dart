import 'package:flutter/material.dart';
import 'package:loan_admin/bloc/repo.dart';
import 'package:loan_admin/components/alert.dart';
import 'package:loan_admin/components/text.dart';
import 'package:loan_admin/models/models.dart';
import 'package:loan_admin/pages/notifications_page.dart';

class ManualPaymentDialog extends StatefulWidget {
  final Loan loan;

  const ManualPaymentDialog({super.key, required this.loan});

  @override
  State<ManualPaymentDialog> createState() => _ManualPaymentDialogState();
}

class _ManualPaymentDialogState extends State<ManualPaymentDialog> {
  final amountController = TextEditingController();
  final notesController = TextEditingController();
  String selectedMethod = "Cash";

  double remainingBalance = 0;

  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    remainingBalance = widget.loan.amountRemaing;

    amountController.addListener(_calculateRemaining);
  }

  void _calculateRemaining() {
    final paid = double.tryParse(amountController.text) ?? 0;

    setState(() {
      remainingBalance = widget.loan.amountRemaing - paid;
    });
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderText("Record Manual Payment"),

            const SizedBox(height: 3),

            CustomText(
              "Outstanding: GHS ${widget.loan.amountRemaing.toStringAsFixed(2)}",
              textColor: Colors.grey,
            ),

            const SizedBox(height: 20),

            // ================= AMOUNT =================
            CustomTextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              hintText: 'Amount Paid',
              leadingIcon: Icons.payments,
            ),

            const SizedBox(height: 16),

            // ================= PAYMENT METHOD =================
            DropdownButtonFormField<String>(
              value: selectedMethod,
              decoration: InputDecoration(
                labelText: "Payment Method",
                filled: true,
                fillColor: const Color(0xffF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              items: const [
                DropdownMenuItem(value: "Cash", child: Text("Cash")),
                DropdownMenuItem(
                  value: "Bank Transfer",
                  child: Text("Bank Transfer"),
                ),
                DropdownMenuItem(
                  value: "Mobile Money",
                  child: Text("Mobile Money"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedMethod = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            // ================= DATE =================
            CustomTextField(
              controller: TextEditingController(
                text: selectedDate != null ? formatDate(selectedDate!) : '',
              ),
              readOnly: true,
              leadingIcon: Icons.calendar_today,
              hintText: 'Payment Date',
              onPressed: () async {
                selectedDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                  initialDate: DateTime.now(),
                );

                setState(() {});
              },
            ),

            const SizedBox(height: 20),

            // ================= BALANCE PREVIEW =================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: CustomText(
                      "Remaining Balance",
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  CustomText(
                    "GHS ${remainingBalance.toStringAsFixed(2)}",
                    fontWeight: FontWeight.bold,
                    textColor: remainingBalance < 0 ? Colors.red : Colors.green,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ================= NOTE =================
            TextField(
              maxLines: 3,
              controller: notesController,
              decoration: InputDecoration(
                labelText: "Note (Optional)",
                hintText: "Add payment reference or comments...",
                filled: true,
                fillColor: const Color(0xffF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ================= ACTIONS =================
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),

                const SizedBox(width: 12),

                ElevatedButton.icon(
                  onPressed: handleConfirmPayment,
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: CustomText("Confirm Payment", textColor: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void handleConfirmPayment() async {
    final amountPaid = double.parse(amountController.text);
    final notes = notesController.text;

    showLoadingDialog(context: context);

    try {
      await Repository.recordManualPayment({
        'loan_id': widget.loan.loanId,
        'amount_paid': amountPaid,
        'notes': notes,
      });

      //update the loan object with the amount.
      widget.loan.amountPaid += amountPaid;

      Navigator.pop(context); //close the loading dialog.
    } catch (ex) {
      Navigator.pop(context); //close the loading dialog.

      showAlertDialog(
        context: context,
        alertType: AlertType.error,
        icon: Icons.error,
        title: 'Manual Payment Error',
        contentText: ex.toString(),
      );
    }
  }
}
