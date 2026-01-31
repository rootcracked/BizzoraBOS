import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  final String? labelText;
  final String placeholder;
  final TextEditingController controller;
  final TextInputType type;
  final bool? hideCharacters;
  final IconData icon;
  final String? Function(String?)? validator;
  final Function(String?)? onChanged;

  const TextInput({
    Key? key,
    this.labelText,
    required this.placeholder,
    required this.controller,
    this.type = TextInputType.text,
    this.hideCharacters,
    required this.icon,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  bool _hideCharacters = false;

  @override
  void initState() {
    super.initState();
    _hideCharacters = widget.hideCharacters ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) // Show label only if provided
          Padding(
            padding: const EdgeInsets.only(
              bottom: 6,
            ), // Small space above input
            child: Text(
              widget.labelText!,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),

        TextFormField(
          controller: widget.controller,
          keyboardType: widget.type,
          obscureText: _hideCharacters,
          validator: widget.validator,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            prefixIcon: Icon(widget.icon),
            suffixIcon: widget.hideCharacters == true
                ? IconButton(
                    icon: Icon(
                      _hideCharacters ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _hideCharacters = !_hideCharacters;
                      });
                    },
                  )
                : null,
            filled: true,
            fillColor: Colors.grey[100],
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
