import 'package:flutter/material.dart';
import '../services/leave_service.dart';
import '../models/leave_balance.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LeaveService _leaveService = LeaveService();

  @override
  void initState() {
    super.initState();
    // Listen to changes in service
    _leaveService.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _leaveService.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    setState(() {});
  }

  void _handleCreditLeaves() {
    final message = _leaveService.creditMonthlyLeaves();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: message.contains("Already") ? Colors.orange : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Balance Manager'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Demo',
            onPressed: () {
              _leaveService.resetDemo();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Demo data reset.")),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          _buildHeaderCard(),
          Expanded(
            child: ListView.builder(
              itemCount: _leaveService.leaves.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final employee = _leaveService.leaves[index];
                return _buildEmployeeCard(employee);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleCreditLeaves,
        icon: const Icon(Icons.add_task),
        label: const Text('Run Monthly Credit'),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.calendar_today),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Last Credited Month:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  _leaveService.lastCreditedMonth.isEmpty
                      ? "Not yet run"
                      : _leaveService.lastCreditedMonth,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(LeaveBalance employee) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              employee.employeeName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStat("Opening", employee.openingBalance.toStringAsFixed(1)),
                _buildStat("Credit", "+${employee.monthlyCredit.toStringAsFixed(1)}", color: Colors.green),
                _buildStat("Used", "-${employee.leavesUsed.toStringAsFixed(1)}", color: Colors.red),
                _buildStat("Closing", employee.closingBalance.toStringAsFixed(1), isBold: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, {Color? color, bool isBold = false}) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
      ],
    );
  }
}
