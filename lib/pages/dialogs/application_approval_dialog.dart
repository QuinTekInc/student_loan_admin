
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_admin/bloc/applications_bloc.dart';
import 'package:loan_admin/components/placeholders.dart';
import 'package:loan_admin/components/text.dart';

class LoanApprovalDialog extends StatefulWidget {

  const LoanApprovalDialog({
    super.key,
  });

  @override
  State<LoanApprovalDialog> createState() => _LoanApprovalDialogState();
}

class _LoanApprovalDialogState extends State<LoanApprovalDialog> {
  final amountController = TextEditingController();
  final interestController = TextEditingController();
  final durationController = TextEditingController();

  double totalRepayment = 0;
  double monthlyPayment = 0;

  void calculateLoan() {
    final principal = double.tryParse(amountController.text) ?? 0;

    final interest = double.tryParse(interestController.text) ?? 0;

    final duration = int.tryParse(durationController.text) ?? 0;

    final total = principal + (principal * interest / 100);

    final double monthly = duration == 0 ? 0 : total / duration;

    setState(() {
      totalRepayment = total;
      monthlyPayment = monthly;
    });
  }

  @override
  void initState() {
    super.initState();

    amountController.text = context.read<ReviewCubit>()
        .loanApplication.amountRequested.toString();

    amountController.addListener(calculateLoan);
    interestController.addListener(calculateLoan);
    durationController.addListener(calculateLoan);
  }

  @override
  void dispose() {
    amountController.dispose();
    interestController.dispose();
    durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 650,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            HeaderText(
              "Approve Loan Application",
            ),

            const SizedBox(height: 8),

            const CustomText(
              "Enter loan details to convert this application into an approved loan.",
              textColor: Colors.grey,
            ),

            const SizedBox(height: 24),

            Row(
              children: [

                Expanded(
                  child: _inputField(
                    controller: amountController,
                    label: "Approved Amount (GHS)",
                    icon: Icons.payments_outlined,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: _inputField(
                    controller: interestController,
                    label: "Interest Rate (%)",
                    icon: Icons.percent,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            _inputField(
              controller: durationController,
              label: "Loan Duration (Months)",
              icon: Icons.calendar_month_outlined,
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [

                  Row(
                    children: [

                      const Expanded(
                        child: CustomText(
                          "Total Repayment",
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      CustomText(
                        "GHS ${totalRepayment.toStringAsFixed(2)}",
                        textColor: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [

                      const Expanded(
                        child: CustomText(
                          "Monthly Payment",
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      CustomText(
                        "GHS ${monthlyPayment.toStringAsFixed(2)}",
                        textColor: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),


            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    shape: StadiumBorder(
                      side: BorderSide(color: Colors.red.shade600, width: 1.5)
                    )
                  ),
                  child: CustomText(
                    'Cancel',
                    textColor: Colors.red.shade600,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(width: 12),

                ElevatedButton.icon(
                  onPressed: handleApproveLoan,
                  icon: const Icon(Icons.check, color: Colors.white,),
                  label: CustomText(
                    'Approve Loan',
                    textColor: Colors.white,
                    fontSize: 14,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                    )
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: const Color(0xffF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }



  void handleApproveLoan() async {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => LoadingPlaceholder()
    );

    try{
      await context.read<ReviewCubit>().acceptApplication(
        amount: double.parse(amountController.text),
        percentage: double.parse(interestController.text),
        duration: int.parse(durationController.text)
      );

      Navigator.pop(context);//close the loading dialog


      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: CustomText(
            'Loan Approval Success',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          icon: Icon(
            Icons.check_circle,
            color: Colors.green.shade700, size: 60,
          ),
          content: CustomText(
            'You have successfully approved loan,'
            '${context.read<ReviewCubit>().loanApplication.applicationId}'
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), //close the success dialog
              child: CustomText(
                "Okay",
                textColor: Colors.green.shade700,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        )
      );

      Navigator.pop(context);//close the acceptance dialog

    }catch(ex){

      Navigator.pop(context); //close the loading dialog

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: CustomText('Error', fontSize: 16, fontWeight: FontWeight.w600,),
          icon: Icon(Icons.error, color: Colors.red.shade700, size: 60,),
          content: CustomText(
            'There was an error in approving his loan: \n ${ex.toString()}'
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: CustomText(
                "Close",
                textColor: Colors.red.shade700,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        )
      );
    }

  }
}