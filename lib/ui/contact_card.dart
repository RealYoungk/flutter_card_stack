import 'package:animation/model/contact.dart';
import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({Key? key, required this.borderColor, required this.contact}) : super(key: key);

  final Color borderColor;
  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card tab
        Align(
          heightFactor: .9,
          alignment: Alignment.centerLeft,
          child: Container(
            height: 30,
            width: 70,
            decoration:
                BoxDecoration(color: borderColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(10))),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
        // Card Body
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: borderColor,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20), topRight: Radius.circular(20))),
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Role
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 40),
                      const SizedBox(width: 10),
                      Flexible(child: Text.rich(TextSpan(text: '\n${contact.role}', style: const TextStyle())))
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
