import 'package:animation/ui/contact_card.dart';
import 'package:animation/ui/perspective_list_view.dart';
import 'package:flutter/material.dart';

import '../model/contact.dart';

class ContactListPage extends StatelessWidget {
  const ContactListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('템플릿 겔러리'),
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
      ),
      body: PerspectiveListView(
        visualizedItems: 10,
        itemExtent: MediaQuery.of(context).size.height * 0.33,
        initialIndex: 7,
        backItemsShadowColor: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.all(10),
        children: List.generate(Contact.contacts.length, (index) {
          final contact = Contact.contacts[index];
          final borderColor = Colors.accents[index % Colors.accents.length];
          return ContactCard(borderColor: borderColor, contact: contact);
        }),
      ),
    );
  }
}
