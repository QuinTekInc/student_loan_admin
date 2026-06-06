
import 'package:flutter/material.dart';
import 'package:loan_admin/components/text.dart';

class PaymentHistoryPage extends StatelessWidget {
  final String loanId;

  const PaymentHistoryPage({
    super.key,
    required this.loanId,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [

          HeaderText("Payment History"),

          const SizedBox(height: 6),

          CustomText(
            "Loan ID: $loanId",
            textColor: Colors.grey,
          ),

          const SizedBox(height: 20),

          _filters(),

          const SizedBox(height: 20),

          _summaryCards(),

          const SizedBox(height: 20),

          _paymentTable(),
        ],
      ),
    );
  }

  // ================= FILTERS =================
  Widget _filters() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [

          Expanded(
            flex: 3,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search by reference, student, or loan ID...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xffF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          SizedBox(
            width: 180,
            child: DropdownButtonFormField<String>(
              value: "All Methods",
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xffF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: const [
                DropdownMenuItem(value: "All Methods", child: Text("All Methods")),
                DropdownMenuItem(value: "Cash", child: Text("Cash")),
                DropdownMenuItem(value: "Mobile Money", child: Text("Mobile Money")),
                DropdownMenuItem(value: "Bank Transfer", child: Text("Bank Transfer")),
              ],
              onChanged: (_) {},
            ),
          ),

          const SizedBox(width: 16),

          SizedBox(
            width: 160,
            child: DropdownButtonFormField<String>(
              value: "All Status",
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xffF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: const [
                DropdownMenuItem(value: "All Status", child: Text("All Status")),
                DropdownMenuItem(value: "Successful", child: Text("Successful")),
                DropdownMenuItem(value: "Pending", child: Text("Pending")),
                DropdownMenuItem(value: "Failed", child: Text("Failed")),
              ],
              onChanged: (_) {},
            ),
          ),
        ],
      ),
    );
  }

  // ================= SUMMARY =================
  Widget _summaryCards() {
    return Row(
      children: [

        Expanded(child: _stat("Total Paid", "GHS 7,600", Colors.green)),
        const SizedBox(width: 12),

        Expanded(child: _stat("Pending", "GHS 1,200", Colors.orange)),
        const SizedBox(width: 12),

        Expanded(child: _stat("Failed", "GHS 300", Colors.red)),
        const SizedBox(width: 12),

        Expanded(child: _stat("Transactions", "18", Colors.blue)),
      ],
    );
  }

  Widget _stat(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [

          CustomText(
            value,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            textColor: color,
          ),

          const SizedBox(height: 6),

          CustomText(
            title,
            textColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  // ================= TABLE =================
  Widget _paymentTable() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const CustomText(
            "Transactions",
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),

          const SizedBox(height: 16),

          Table(
            border: TableBorder.all(color: Colors.grey.shade200),
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(2),
              4: FlexColumnWidth(2),
              5: FlexColumnWidth(2),
            },
            children: [

              _rowHeader(),

              _row("TXN-001", "GHS 800", "Cash", "Jan 2026", "Successful", Colors.green),
              _row("TXN-002", "GHS 800", "Mobile Money", "Feb 2026", "Successful", Colors.green),
              _row("TXN-003", "GHS 800", "Bank Transfer", "Mar 2026", "Pending", Colors.orange),
              _row("TXN-004", "GHS 800", "Cash", "Apr 2026", "Failed", Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _rowHeader() {
    return TableRow(
      decoration: BoxDecoration(color: Colors.grey.shade100),
      children: const [

        Padding(
          padding: EdgeInsets.all(10),
          child: CustomText("Ref ID", fontWeight: FontWeight.bold),
        ),

        Padding(
          padding: EdgeInsets.all(10),
          child: CustomText("Amount", fontWeight: FontWeight.bold),
        ),

        Padding(
          padding: EdgeInsets.all(10),
          child: CustomText("Method", fontWeight: FontWeight.bold),
        ),

        Padding(
          padding: EdgeInsets.all(10),
          child: CustomText("Date", fontWeight: FontWeight.bold),
        ),

        Padding(
          padding: EdgeInsets.all(10),
          child: CustomText("Status", fontWeight: FontWeight.bold),
        ),

        Padding(
          padding: EdgeInsets.all(10),
          child: CustomText("Action", fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  TableRow _row(
      String ref,
      String amount,
      String method,
      String date,
      String status,
      Color color,
      ) {
    return TableRow(
      children: [

        Padding(
          padding: const EdgeInsets.all(10),
          child: CustomText(ref),
        ),

        Padding(
          padding: const EdgeInsets.all(10),
          child: CustomText(amount),
        ),

        Padding(
          padding: const EdgeInsets.all(10),
          child: CustomText(method),
        ),

        Padding(
          padding: const EdgeInsets.all(10),
          child: CustomText(date),
        ),

        Padding(
          padding: const EdgeInsets.all(10),
          child: CustomText(
            status,
            textColor: color,
            fontWeight: FontWeight.w600,
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(10),
          child: IconButton(
            icon: const Icon(Icons.visibility_outlined),
            onPressed: () {
              // open payment detail dialog
            },
          ),
        ),
      ],
    );
  }
}