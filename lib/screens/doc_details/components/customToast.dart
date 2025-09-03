import 'package:flutter/material.dart';

class CustomToast extends StatefulWidget {
  final String message;
  final bool isSuccess;
  final VoidCallback onClose;

  const CustomToast({
    Key? key,
    required this.message,
    required this.isSuccess,
    required this.onClose,
  }) : super(key: key);

  @override
  State<CustomToast> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<CustomToast>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    // Fade in
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacity = 1.0;
      });
    });

    // Fade out after 4.5s (before 5s removal)
    Future.delayed(const Duration(milliseconds: 4500), () {
      if (mounted) {
        setState(() {
          _opacity = 0.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: _opacity,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 419,
          height: 69,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color:
              widget.isSuccess ? const Color(0xFF00811A) : Colors.red,
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.message,
                  style: TextStyle(
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    height: 1,
                    color: widget.isSuccess
                        ? const Color(0xFF00811A)
                        : Colors.red,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                color: widget.isSuccess
                    ? const Color(0xFF00811A)
                    : Colors.red,
                onPressed: widget.onClose,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
