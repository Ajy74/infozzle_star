import 'package:flutter/material.dart';

class AuthenticationTextField extends StatefulWidget {
  const AuthenticationTextField(
      {super.key,
      required this.obscure,
      required this.hint,
      required this.controller,
      this.isEmail = false,
      this.isCountry = false,
      this.isDouble = false,
      this.isPhone = false,
      this.onTap,
      this.focusNode,
      this.nextFocusNode,
      this.textInputAction = TextInputAction.next});

  final bool obscure;
  final bool isEmail;
  final bool isDouble;
  final bool isCountry;
  final bool isPhone;
  final String hint;
  final TextEditingController controller;
  final Function()? onTap;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction textInputAction;

  @override
  _AuthenticationTextFieldState createState() => _AuthenticationTextFieldState();
}

class _AuthenticationTextFieldState extends State<AuthenticationTextField> {
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        controller: widget.controller,
        readOnly: widget.isCountry ? true : false,
        obscureText: _isObscure,
        keyboardType: widget.isEmail
            ? TextInputType.emailAddress
            : widget.isPhone
                ? TextInputType.phone
                : TextInputType.text,
        maxLines: widget.isDouble ? null : 1,
        minLines: widget.isDouble ? 4 : null,
        onTap: widget.onTap,
        focusNode: widget.focusNode,
        textInputAction: widget.textInputAction,
        onFieldSubmitted: (_) {
          if (widget.nextFocusNode != null) {
            FocusScope.of(context).requestFocus(widget.nextFocusNode);
          }
        },
        decoration: InputDecoration(
          hintText: widget.hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          suffixIcon: widget.obscure
              ? IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
