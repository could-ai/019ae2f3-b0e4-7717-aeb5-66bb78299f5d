import 'package:flutter/foundation.dart';
import '../models/leave_balance.dart';

class LeaveService extends ChangeNotifier {
  // Singleton pattern for easy access
  static final LeaveService _instance = LeaveService._internal();
  factory LeaveService() => _instance;
  LeaveService._internal();

  // Mock Data
  final List<LeaveBalance> _leaves = [
    LeaveBalance(id: '1', employeeName: 'Alice Johnson', openingBalance: 10.0, monthlyCredit: 1.5, leavesUsed: 2.0),
    LeaveBalance(id: '2', employeeName: 'Bob Smith', openingBalance: 5.0, monthlyCredit: 1.5, leavesUsed: 0.0),
    LeaveBalance(id: '3', employeeName: 'Charlie Brown', openingBalance: 12.0, monthlyCredit: 2.0, leavesUsed: 1.0),
    LeaveBalance(id: '4', employeeName: 'Diana Prince', openingBalance: 8.5, monthlyCredit: 1.5, leavesUsed: 0.5),
  ];

  String _lastCreditedMonth = ""; // Stores "YYYY-MM"

  List<LeaveBalance> get leaves => _leaves;
  String get lastCreditedMonth => _lastCreditedMonth;

  // The logic translated from the provided Google Apps Script
  String creditMonthlyLeaves() {
    final now = DateTime.now();
    final y = now.year;
    final m = now.month.toString().padLeft(2, '0');
    final thisMonthKey = "$y-$m";

    if (_lastCreditedMonth == thisMonthKey) {
      return "Already credited for this month ($thisMonthKey).";
    }

    // Iterate and update balances
    for (var employee in _leaves) {
      // Logic: opening = opening + credit
      // In the script, it updates the cell value for Opening Balance.
      employee.openingBalance += employee.monthlyCredit;
      
      // Note: In a real app, we might want to reset 'leavesUsed' for the new month 
      // or archive the previous month's data, but we will stick strictly to the provided script's logic
      // which only updates the opening balance.
    }

    _lastCreditedMonth = thisMonthKey;
    notifyListeners(); // Update UI
    return "Successfully credited leaves for $thisMonthKey.";
  }
  
  // Helper to reset for demo purposes
  void resetDemo() {
    _lastCreditedMonth = "";
    // Reset balances to initial mock values
    _leaves[0].openingBalance = 10.0;
    _leaves[1].openingBalance = 5.0;
    _leaves[2].openingBalance = 12.0;
    _leaves[3].openingBalance = 8.5;
    notifyListeners();
  }
}
