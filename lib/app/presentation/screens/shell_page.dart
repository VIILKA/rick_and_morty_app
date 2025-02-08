// lib/app/presentation/shell_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShellPage extends StatefulWidget {
  final Widget child;
  const ShellPage({super.key, required this.child});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _currentIndex = 0;

  final _tabs = ['/characters', '/episodes', '/locations'];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/characters')) {
      _currentIndex = 0;
    } else if (location.startsWith('/episodes')) {
      _currentIndex = 1;
    } else if (location.startsWith('/locations')) {
      _currentIndex = 2;
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 0, 7, 78),
        currentIndex: _currentIndex,
        onTap: (index) => context.go(_tabs[index]),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Герои'),
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Эпизоды'),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on), label: 'Локации'),
        ],
      ),
    );
  }
}
