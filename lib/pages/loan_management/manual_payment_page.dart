

import 'package:flutter/material.dart';
import 'package:loan_admin/components/text.dart';

class ManualPaymentDialog extends StatefulWidget {
  final double outstandingAmount;

  const ManualPaymentDialog({
    super.key,
    required this.outstandingAmount,
  });

  @override
  State<ManualPaymentDialog> createState() => _ManualPaymentDialogState();
}

class _ManualPaymentDialogState extends State<ManualPaymentDialog> {
  final amountController = TextEditingController();
  String selectedMethod = "Cash";

  double remainingBalance = 0;

  @override
  void initState() {
    super.initState();
    remainingBalance = widget.outstandingAmount;

    amountController.addListener(_calculateRemaining);
  }

  void _calculateRemaining() {
    final paid = double.tryParse(amountController.text) ?? 0;

    setState(() {
      remainingBalance = widget.outstandingAmount - paid;
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

            const SizedBox(height: 8),

            CustomText(
              "Outstanding: GHS ${widget.outstandingAmount.toStringAsFixed(2)}",
              textColor: Colors.grey,
            ),

            const SizedBox(height: 20),

            // ================= AMOUNT =================
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Amount Paid",
                prefixIcon: const Icon(Icons.payments),
                filled: true,
                fillColor: const Color(0xffF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
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
                DropdownMenuItem(value: "Bank Transfer", child: Text("Bank Transfer")),
                DropdownMenuItem(value: "Mobile Money", child: Text("Mobile Money")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedMethod = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            // ================= DATE =================
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Payment Date",
                prefixIcon: const Icon(Icons.calendar_today),
                filled: true,
                fillColor: const Color(0xffF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              onTap: () async {
                await showDatePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                  initialDate: DateTime.now(),
                );
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
                    textColor: remainingBalance < 0
                        ? Colors.red
                        : Colors.green,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ================= NOTE =================
            TextField(
              maxLines: 3,
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
                  onPressed: () {
                    // TODO: submit payment to backend
                  },
                  icon: const Icon(Icons.check),
                  label: const Text("Confirm Payment"),
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
}