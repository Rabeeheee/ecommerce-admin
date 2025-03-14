
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.isLoading,
    required this.onPressedButton,
    this.buttonText = 'Save',
  });

  final bool isLoading;
  final void Function()? onPressedButton;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff374ABE), Color(0xff64B6FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressedButton,
        style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll(
            Colors.transparent,
          ),
          foregroundColor: const MaterialStatePropertyAll(
            Colors.transparent,
          ),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                5,
              ),
            ),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator()
            : Text(
                buttonText,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
      ),
    );
  }
}
