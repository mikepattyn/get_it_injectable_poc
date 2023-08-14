import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_poc/models/wizard.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  // Shorten GetIt instance access
  GetIt getIt = GetIt.I;

  @override
  void dispose() {
    // Remove listener on the wizard singleton
    getIt<Wizard>().removeListener(update);
    super.dispose();
  }

  @override
  void initState() {
    // Add listener on the wizard singleton
    getIt<Wizard>().addListener(update);
    super.initState();
  }

  // Update UI
  void update() => setState(() => {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          const Spacer(),
          // Display wizard health property
          Text(getIt<Wizard>().health.toString()),
          const SizedBox(height: 10),
          ElevatedButton(
            // Update wizard health property
            onPressed: getIt<Wizard>().attack,
            child: const Text("attack"),
          ),
          const Spacer(),
        ],
      )),
    );
  }
}
