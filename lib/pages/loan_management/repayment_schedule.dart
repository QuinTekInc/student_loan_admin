import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:loan_admin/components/text.dart';
import 'package:loan_admin/models/models.dart';

class RepaymentSchedulePage extends StatelessWidget {
  
  final Loan loan;

  const RepaymentSchedulePage({super.key, required this.loan});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FragementHeader(title: 'Loan Repayment Schedule'),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _summaryHeader(),

                  const SizedBox(height: 20),

                  _repaymentStats(),

                  const SizedBox(height: 20),

                  _scheduleTable(),

                  const SizedBox(height: 20),

                  _quickActions(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _summaryHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText("Loan ID", textColor: Colors.grey),

                SizedBox(height: 6),

                CustomText(
                  loan.loanId,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const CustomText(
              "ACTIVE",
              textColor: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ================= STATS =================
  Widget _repaymentStats() {
    return Row(
      children: [
        Expanded(child: _statCard("Total Installments", "24", Colors.blue)),
        const SizedBox(width: 12),

        Expanded(child: _statCard("Paid", "8", Colors.green)),
        const SizedBox(width: 12),

        Expanded(child: _statCard("Pending", "14", Colors.orange)),
        const SizedBox(width: 12),

        Expanded(child: _statCard("Overdue", "2", Colors.red)),
      ],
    );
  }

  Widget _statCard(String title, String value, Color color) {
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
            fontSize: 22,
            fontWeight: FontWeight.bold,
            textColor: color,
          ),

          const SizedBox(height: 6),

          CustomText(title, textColor: Colors.grey),
        ],
      ),
    );
  }

  // ================= TABLE =================
  Widget _scheduleTable() {
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
            "Installment Breakdown",
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
            },
            children: [
              _rowHeader(),

              _row("1", "Jan 2026", "GHS 800", "Paid", Colors.green),
              _row("2", "Feb 2026", "GHS 800", "Paid", Colors.green),
              _row("3", "Mar 2026", "GHS 800", "Pending", Colors.orange),
              _row("4", "Apr 2026", "GHS 800", "Pending", Colors.orange),
              _row("5", "May 2026", "GHS 800", "Overdue", Colors.red),
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
          child: CustomText("Month #", fontWeight: FontWeight.bold),
        ),

        Padding(
          padding: EdgeInsets.all(10),
          child: CustomText("Due Date", fontWeight: FontWeight.bold),
        ),

        Padding(
          padding: EdgeInsets.all(10),
          child: CustomText("Amount", fontWeight: FontWeight.bold),
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
    String month,
    String date,
    String amount,
    String status,
    Color color,
  ) {
    return TableRow(
      children: [
        Padding(padding: const EdgeInsets.all(10), child: CustomText(month)),

        Padding(padding: const EdgeInsets.all(10), child: CustomText(date)),

        Padding(padding: const EdgeInsets.all(10), child: CustomText(amount)),

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
          child: _actionButton(status),
        ),
      ],
    );
  }

  Widget _actionButton(String status) {
    if (status == "Paid") {
      return const Icon(Icons.check_circle, color: Colors.green);
    }

    if (status == "Overdue") {
      return ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.withOpacity(0.1),
          foregroundColor: Colors.red,
          elevation: 0,
        ),
        child: const Text("Follow Up"),
      );
    }

    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange.withOpacity(0.1),
        foregroundColor: Colors.orange,
        elevation: 0,
      ),
      child: const Text("Record"),
    );
  }

  // ================= QUICK ACTIONS =================
  Widget _quickActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _btn(Icons.payment, "Record Payment"),
          _btn(Icons.notifications_active, "Send Reminder"),
          _btn(Icons.edit, "Adjust Schedule"),
          _btn(Icons.warning, "Flag Account"),
          _btn(Icons.download, "Export Schedule"),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, String text) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.withOpacity(0.1),
        foregroundColor: Colors.green,
        elevation: 0,
      ),
    );
  }
}
