class LeaveBalance {
  final String id;
  final String employeeName;
  double openingBalance;
  double monthlyCredit;
  double leavesUsed;

  LeaveBalance({
    required this.id,
    required this.employeeName,
    required this.openingBalance,
    required this.monthlyCredit,
    required this.leavesUsed,
  });

  // Calculated property for Closing Balance
  // Based on the script context: Closing = Opening (which might already include credit) - Used
  // However, the script updates 'Opening' by adding 'Credit'.
  // So if we follow the script:
  // Before Run: Opening = X.
  // After Run: Opening = X + Credit.
  // Closing Balance is typically (Current Opening - Used).
  double get closingBalance => openingBalance - leavesUsed;
}
