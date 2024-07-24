import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final Color color;
  final bool isCenter;
  final bool isTappable;

  const CustomSearchBar(
      {super.key,
      required this.isTappable,
      required this.controller,
      required this.hintText,
      required this.onChanged,
      required this.color,
      required this.isCenter});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      decoration: BoxDecoration(color: color),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isCenter ? 0 : 20),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    enabled: isTappable,
                    textAlign: isCenter ? TextAlign.center : TextAlign.left,
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: hintText,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                      border: InputBorder.none,
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: onChanged,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: IconButton(
                  icon: const Icon(
                    Icons.search,
                    size: 26,
                    color: Colors.grey,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
