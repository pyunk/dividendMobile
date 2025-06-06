// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // For number formatting (currency)

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>(); // Key for accessing Form state

  // Controllers for TextFormFields to manage their text content
  final TextEditingController _investedAmountController = TextEditingController();
  final TextEditingController _annualRateController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();

  // State variables to hold the calculation results
  String _monthlyDividendResult = '';
  String _totalDividendResult = '';

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the tree to free up resources
    _investedAmountController.dispose();
    _annualRateController.dispose();
    _monthsController.dispose();
    super.dispose();
  }

  // Performs the dividend calculation based on the input fields
  void _calculateDividend() {
    FocusScope.of(context).unfocus(); // Dismiss keyboard

    if (_formKey.currentState!.validate()) { // Proceed only if form inputs are valid
      // Parse input values, providing defaults if parsing fails (though validation should prevent this)
      final double investedAmount = double.tryParse(_investedAmountController.text) ?? 0.0;
      final double annualRate = (double.tryParse(_annualRateController.text) ?? 0.0) / 100; // Convert percentage
      final int months = int.tryParse(_monthsController.text) ?? 0;

      // Perform calculation only if inputs are within logical bounds
      if (investedAmount > 0 && annualRate > 0 && months > 0 && months <= 12) {
        final double monthlyDividend = (annualRate / 12) * investedAmount;
        final double totalDividend = monthlyDividend * months;
        // Format numbers as currency
        final currencyFormatter = NumberFormat.currency(locale: 'ms_MY', symbol: 'RM ', decimalDigits: 2);

        setState(() { // Update UI with formatted results
          _monthlyDividendResult = currencyFormatter.format(monthlyDividend);
          _totalDividendResult = currencyFormatter.format(totalDividend);
        });
      } else {
        setState(() { // Handle invalid calculation parameters
          _monthlyDividendResult = 'Invalid input';
          _totalDividendResult = 'Invalid input';
        });
      }
    } else {
      // If form validation fails, clear any previous results
      setState(() {
        _monthlyDividendResult = '';
        _totalDividendResult = '';
      });
    }
  }

  // Clears all input fields and the displayed results
  void _clearFields() {
    FocusScope.of(context).unfocus(); // Dismiss keyboard
    _formKey.currentState?.reset();   // Reset form validation messages
    _investedAmountController.clear();
    _annualRateController.clear();
    _monthsController.clear();
    setState(() { // Clear result strings to update UI
      _monthlyDividendResult = '';
      _totalDividendResult = '';
    });
  }

  // Reusable widget for creating a styled input field with a label
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    String? hintText,
    String? prefixText,
    String? suffixText,
    required TextInputType keyboardType,
    required List<TextInputFormatter> inputFormatters,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Align label to the left
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500, color: Colors.blueGrey[700]),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            prefixText: prefixText,
            suffixText: suffixText,
            // Note: TextFormField decoration (borders, fill color, etc.) comes from ThemeData
          ),
          keyboardType: keyboardType,
          inputFormatters: inputFormatters, // Apply input formatting rules
          validator: validator,             // Input validation logic
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the app's theme for consistent styling

    return SingleChildScrollView( // Makes the content scrollable if it overflows
      child: Padding(
        padding: const EdgeInsets.all(20.0), // Overall padding for the page
        child: Form(
          key: _formKey, // Connects the GlobalKey to this Form
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Centers the App Icon
            children: <Widget>[
              // Section for displaying the App Icon
              SizedBox(
                width: 100,
                height: 100,
                child: Card(
                  elevation: 6,
                  color: Colors.white, // Explicit card color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.antiAlias, // Ensures child (Image) respects rounded corners
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      'assets/img/gold.png', // Path to your app icon
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback widget if the image fails to load
                        return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Page Title
              Text(
                'Dividend Calculator',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.primaryColorDark, // Uses a darker shade of the theme's primary color
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Card grouping all input fields
              Card(
                elevation: 4,
                color: Colors.white, // Explicit card color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Aligns input field labels to the start
                    children: [
                      // Title for the input section within the card
                      Text(
                        'Enter Details',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.primaryColorDark,
                        ),
                        textAlign: TextAlign.center, // Centers this title within its space
                      ),
                      const SizedBox(height:16),
                      _buildInputField(
                        controller: _investedAmountController,
                        label: 'Invested Fund Amount',
                        prefixText: 'RM ',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter invested amount';
                          if (double.tryParse(value) == null || double.parse(value) <= 0) return 'Enter a valid positive amount';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildInputField(
                        controller: _annualRateController,
                        label: 'Annual Dividend Rate',
                        suffixText: '%',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter annual rate';
                          final rate = double.tryParse(value);
                          if (rate == null || rate <= 0 || rate > 100) return 'Enter a valid rate (0-100)';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildInputField(
                        controller: _monthsController,
                        label: 'Number of Months Invested',
                        hintText: 'Max 12 months',
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter number of months';
                          final months = int.tryParse(value);
                          if (months == null || months <= 0 || months > 12) return 'Enter months between 1 and 12';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Row containing Calculate and Clear buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distributes space between buttons
                children: [
                  Expanded( // Allows the ElevatedButton to take up available horizontal space
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.calculate_outlined, size: 20),
                      label: const Text('Calculate'),
                      onPressed: _calculateDividend,
                      // Styling for ElevatedButton is inherited from ElevatedButtonThemeData in main.dart
                    ),
                  ),
                  const SizedBox(width: 16), // Spacing between buttons
                  IconButton(
                    icon: Icon(Icons.clear_all_rounded, color: theme.colorScheme.error), // Icon for clear button
                    tooltip: 'Clear fields', // Text shown on long press (for accessibility)
                    onPressed: _clearFields,
                    padding: const EdgeInsets.all(12.0), // Increases tappable area
                    iconSize: 28, // Size of the icon
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Card for displaying calculation results; only visible if there are results
              if (_monthlyDividendResult.isNotEmpty || _totalDividendResult.isNotEmpty)
                Card(
                  color: Colors.blue[50], // Light blue background for this card
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Calculation Results:',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.blue[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(height: 20, thickness: 1), // A thin line to separate title from results
                        _buildResultRow('Monthly Dividend:', _monthlyDividendResult),
                        const SizedBox(height: 10),
                        _buildResultRow('Total Dividend:', _totalDividendResult, isEmphasized: true), // Emphasized style
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable widget for creating a styled row to display a label and its value
  Widget _buildResultRow(String label, String value, {bool isEmphasized = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Pushes label and value to opposite ends
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.blueGrey[800],
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: isEmphasized ? FontWeight.bold : FontWeight.normal, // Apply bold if emphasized
            fontSize: isEmphasized ? 18 : 16, // Slightly larger font if emphasized
            color: isEmphasized ? Colors.blue[900] : Colors.black87,
          ),
        ),
      ],
    );
  }
}