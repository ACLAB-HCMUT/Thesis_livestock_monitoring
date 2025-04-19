import 'package:flutter/material.dart';

class ShowDialog {
  static void showErrorDialog(
      BuildContext context, String messagea, String messageb) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Wrap content height
              children: [
                // Icon
                const Icon(
                  Icons.error_outline, // Error icon
                  color: Colors.red, // Red color for errors
                  size: 60, // Large icon size
                ),
                const SizedBox(height: 16),
                // Title
                Text(
                  messagea,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red, // Red color for errors
                  ),
                ),
                const SizedBox(height: 8),
                // Message
                Text(
                  messageb,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700], // Grey color for message
                  ),
                ),
                const SizedBox(height: 20),
                // Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Red background for button
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded button
                    ),
                  ),
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white, // White text color
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showSuccessfulDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Wrap content height
              children: [
                // Icon
                const Icon(
                  Icons.check_circle_outline, // Error icon
                  color: Colors.green, // Red color for errors
                  size: 60, // Large icon size
                ),
                const SizedBox(height: 16),
                // Title
                const Text(
                  "Register Successfully",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green, // Red color for errors
                  ),
                ),
                const SizedBox(height: 8),
                // Message
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700], // Grey color for message
                  ),
                ),
                const SizedBox(height: 20),
                // Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Red background for button
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded button
                    ),
                  ),
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white, // White text color
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showConfirmationDialog(BuildContext context, String title,
    String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Wrap content height
              children: [
                // Icon
                const Icon(
                  Icons.help_outline, // Question icon
                  color: Colors.green, // Blue color for confirmation
                  size: 60,
                ),
                const SizedBox(height: 16),
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green, // Blue color for title
                  ),
                ),
                const SizedBox(height: 8),
                // Message
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700], // Grey color for message
                  ),
                ),
                const SizedBox(height: 20),
                // Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // No Button
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey.shade500, 
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "No",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    // OK Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); 
                        onConfirm(); 
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Blue button
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "OK",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
