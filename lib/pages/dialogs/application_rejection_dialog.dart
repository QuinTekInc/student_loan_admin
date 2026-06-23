
import 'package:flutter/material.dart';
import 'package:loan_admin/components/text.dart';

class RejectLoanApplicationDialog extends StatefulWidget {
  const RejectLoanApplicationDialog({
    super.key,
    required this.applicationId,
  });

  final String applicationId;

  @override
  State<RejectLoanApplicationDialog> createState() =>
      _RejectLoanApplicationDialogState();
}

class _RejectLoanApplicationDialogState extends State<RejectLoanApplicationDialog> {
  final reasonController = TextEditingController();
  final commentController = TextEditingController();

  bool notifyStudent = true;
  bool allowResubmission = true;

  String selectedReason = "Incomplete Documents";

  final reasons = [
    "Incomplete Documents",
    "Invalid Student Information",
    "Institution Verification Failed",
    "Document Fraud Suspected",
    "Loan Eligibility Not Met",
    "Duplicate Application",
    "Academic Requirements Not Met",
    "Other",
  ];

  @override
  void dispose() {
    reasonController.dispose();
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,

      child: Container(
        width: 700,
        padding: const EdgeInsets.all(24),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Row(
              children: [

                Container(
                  height: 56,
                  width: 56,

                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),

                  child: Icon(
                    Icons.close_rounded,
                    color: Colors.red.shade700,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      HeaderText(
                        "Reject Loan Application",
                      ),

                      const SizedBox(height: 4),

                      CustomText(
                        "Application ID: ${widget.applicationId}",
                        textColor: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius:
                BorderRadius.circular(18),
              ),

              child: const Row(
                children: [

                  Icon(
                    Icons.warning_amber,
                    color: Colors.red,
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: CustomText(
                      "Rejecting an application may prevent loan approval unless resubmission is allowed.",
                      textColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const CustomText(
              "Rejection Category",
              fontWeight: FontWeight.bold,
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: selectedReason,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(14),
                ),
              ),

              items: reasons.map(
                    (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ),
              ).toList(),

              onChanged: (value) {
                setState(() {
                  selectedReason = value!;
                });
              },
            ),

            const SizedBox(height: 18),

            TextField(
              controller: reasonController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText:
                "Detailed Rejection Reason",

                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: commentController,

              maxLines: 3,

              decoration: InputDecoration(
                labelText:
                "Internal Admin Notes (Optional)",

                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 22),

            Container(
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: const Color(0xffF8FAFC),
                borderRadius:
                BorderRadius.circular(18),
              ),

              child: Column(
                children: [

                  SwitchListTile(
                    value: notifyStudent,

                    activeColor:
                    Colors.green,

                    title:
                    const Text(
                      "Notify Student",
                    ),

                    subtitle:
                    const Text(
                      "Send notification and email",
                    ),

                    onChanged: (v) {
                      setState(() {
                        notifyStudent = v;
                      });
                    },
                  ),

                  SwitchListTile(
                    value:
                    allowResubmission,

                    activeColor:
                    Colors.green,

                    title:
                    const Text(
                      "Allow Resubmission",
                    ),

                    subtitle:
                    const Text(
                      "Student may submit another application",
                    ),

                    onChanged: (v) {
                      setState(() {
                        allowResubmission =
                            v;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            Row(
              mainAxisAlignment:
              MainAxisAlignment.end,

              children: [

                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },

                  child:
                  const Text(
                    "Cancel",
                  ),
                ),

                const SizedBox(width: 12),

                ElevatedButton.icon(
                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    Colors.red,
                  ),

                  onPressed: () {
                    // TODO:
                    // Submit rejection
                  },

                  icon: const Icon(
                    Icons.close,
                  ),

                  label: const Text(
                    "Reject Application",
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