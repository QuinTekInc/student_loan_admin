import 'package:flutter/material.dart';
import 'package:loan_admin/components/text.dart';

class StudentUserProfilePage extends StatelessWidget {
  const StudentUserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          HeaderText("Student Profile"),

          const SizedBox(height: 24),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Expanded(
                flex: 2,
                child: _studentInfoCard(),
              ),

              const SizedBox(width: 20),

              Expanded(
                child: _loanSummaryCard(),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _currentLoanCard(),

          const SizedBox(height: 20),

          _applicationsCard(),

          const SizedBox(height: 20),

          _loanHistoryCard(),

          const SizedBox(height: 20),

          _documentsCard(),
        ],
      ),
    );
  }

  Widget _studentInfoCard() {
    return _sectionCard(
      "Student Information",
      Column(
        children: [

          Row(
            children: [

              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.green.shade100,
                child: const Icon(
                  Icons.person,
                  size: 40,
                ),
              ),

              const SizedBox(width: 16),

              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  CustomText(
                    "Quin Sefalloyd",
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),

                  SizedBox(height: 4),

                  CustomText(
                    "STU-2026-001",
                    textColor: Colors.grey,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [

              _infoTile(
                "Institution",
                "University of Energy and Natural Resources",
              ),

              _infoTile(
                "Programme",
                "Computer Science",
              ),

              _infoTile(
                "Level",
                "300",
              ),

              _infoTile(
                "Phone",
                "+233 24 000 0000",
              ),

              _infoTile(
                "Email",
                "quin@email.com",
              ),

              _infoTile(
                "Status",
                "Active",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _loanSummaryCard() {
    return _sectionCard(
      "Loan Summary",
      Column(
        children: [

          _summaryTile(
            "Current Balance",
            "GHS 12,500",
            Colors.orange,
          ),

          const SizedBox(height: 12),

          _summaryTile(
            "Approved Loans",
            "3",
            Colors.green,
          ),

          const SizedBox(height: 12),

          _summaryTile(
            "Applications",
            "5",
            Colors.blue,
          ),

          const SizedBox(height: 12),

          _summaryTile(
            "Repayments",
            "18",
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _currentLoanCard() {
    return _sectionCard(
      "Current Active Loan",
      Column(
        children: [

          Row(
            children: [

              Expanded(
                child: _infoTile(
                  "Loan ID",
                  "LN-2026-001",
                ),
              ),

              Expanded(
                child: _infoTile(
                  "Amount",
                  "GHS 18,000",
                ),
              ),

              Expanded(
                child: _infoTile(
                  "Outstanding",
                  "GHS 12,500",
                ),
              ),

              Expanded(
                child: _infoTile(
                  "Status",
                  "Active",
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          LinearProgressIndicator(
            value: 0.35,
            minHeight: 10,
            borderRadius: BorderRadius.circular(30),
          ),
        ],
      ),
    );
  }

  Widget _applicationsCard() {
    return _sectionCard(
      "Applications",
      Column(
        children: [

          _tableHeader(
            [
              "Application ID",
              "Date",
              "Amount",
              "Status",
            ],
          ),

          const Divider(),

          ...List.generate(
            3,
                (index) => _tableRow(
              [
                "APP-00$index",
                "15 Mar 2026",
                "GHS 18,000",
                "Approved",
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _loanHistoryCard() {
    return _sectionCard(
      "Loan History",
      Column(
        children: [

          _tableHeader(
            [
              "Loan ID",
              "Amount",
              "Issued",
              "Status",
            ],
          ),

          const Divider(),

          ...List.generate(
            5,
                (index) => _tableRow(
              [
                "LN-00$index",
                "GHS 10,000",
                "2024",
                "Completed",
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _documentsCard() {
    return _sectionCard(
      "Documents",
      Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [

          _documentCard("Passport Photo"),
          _documentCard("Transcript"),
          _documentCard("Admission Letter"),
          _documentCard("National ID"),
        ],
      ),
    );
  }

  Widget _sectionCard(
      String title,
      Widget child,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          HeaderText(title),

          const SizedBox(height: 18),

          child,
        ],
      ),
    );
  }

  Widget _infoTile(
      String title,
      String value,
      ) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          CustomText(
            title,
            textColor: Colors.grey,
          ),

          const SizedBox(height: 6),

          CustomText(
            value,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget _summaryTile(
      String title,
      String value,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [

          Expanded(
            child: CustomText(title),
          ),

          CustomText(
            value,
            textColor: color,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _tableHeader(List<String> headers) {
    return Row(
      children: headers
          .map(
            (e) => Expanded(
          child: CustomText(
            e,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
          .toList(),
    );
  }

  Widget _tableRow(List<String> values) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: values
            .map(
              (e) => Expanded(
            child: CustomText(e),
          ),
        )
            .toList(),
      ),
    );
  }

  Widget _documentCard(String title) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [

          const Icon(
            Icons.description_outlined,
            size: 36,
          ),

          const SizedBox(height: 10),

          CustomText(title),

          const SizedBox(height: 12),

          OutlinedButton(
            onPressed: () {},
            child: const Text("View"),
          ),
        ],
      ),
    );
  }
}