import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Calculator',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF176D58)),
        scaffoldBackgroundColor: const Color(0xFFF2F4EF),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF6F7F3),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E5DC)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF176D58), width: 2),
          ),
        ),
      ),
      home: const _StartupScreen(),
    );
  }
}

class _StartupScreen extends StatefulWidget {
  const _StartupScreen();

  @override
  State<_StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<_StartupScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _startupController;
  late final Animation<double> _logoScale;
  late final Animation<double> _contentOpacity;
  bool _startupComplete = false;

  @override
  void initState() {
    super.initState();
    _startupController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          setState(() => _startupComplete = true);
        }
      });
    _logoScale = CurvedAnimation(
      parent: _startupController,
      curve: const Interval(0, 0.38, curve: Curves.easeOutBack),
    );
    _contentOpacity = CurvedAnimation(
      parent: _startupController,
      curve: const Interval(0.16, 0.48, curve: Curves.easeOut),
    );
    _startupController.forward();
  }

  @override
  void dispose() {
    _startupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.985, end: 1).animate(animation),
          child: child,
        ),
      ),
      child: _startupComplete
          ? const CalculatorScreen(key: ValueKey('calculator-screen'))
          : _buildStartupView(),
    );
  }

  Widget _buildStartupView() {
    return Scaffold(
      key: const Key('startup-screen'),
      backgroundColor: const Color(0xFF0C1210),
      body: Stack(
        children: [
          Positioned(
            top: -170,
            right: -140,
            child: _glow(size: 360, color: const Color(0xFF176D58)),
          ),
          Positioned(
            bottom: -210,
            left: -170,
            child: _glow(size: 420, color: const Color(0xFF63751F)),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScaleTransition(
                    scale: _logoScale,
                    child: Container(
                      width: 116,
                      height: 116,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF34443D), Color(0xFF17211D)],
                        ),
                        borderRadius: BorderRadius.circular(34),
                        border: Border.all(
                          color: const Color(0xFFD5E86C).withValues(alpha: 0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFD5E86C,
                            ).withValues(alpha: 0.16),
                            blurRadius: 38,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.calculate_rounded,
                        size: 64,
                        color: Color(0xFFD5E86C),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  FadeTransition(
                    opacity: _contentOpacity,
                    child: Column(
                      children: [
                        const Text(
                          'CALCULATOR',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 3.2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'A little clarity in every calculation.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFB8C2BD),
                            fontSize: 15,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 38),
                        SizedBox(
                          width: 180,
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: SizedBox(
                                  height: 4,
                                  child: AnimatedBuilder(
                                    animation: _startupController,
                                    builder: (context, child) =>
                                        LinearProgressIndicator(
                                          value: _startupController.value,
                                          backgroundColor: const Color(
                                            0xFF28322E,
                                          ),
                                          color: const Color(0xFFD5E86C),
                                        ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'GETTING THINGS READY',
                                style: TextStyle(
                                  color: Color(0xFF87948D),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glow({required double size, required Color color}) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withValues(alpha: 0.22), color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String display = '0';
  String expression = '';
  String? feedback;
  double? storedValue;
  String? pendingOperation;
  bool startNewEntry = true;
  double? memoryValue;
  final List<String> history = [];

  String formatResult(double value) {
    if (!value.isFinite) {
      return 'Error';
    }
    if (value % 1 == 0) {
      return value.toInt().toString();
    }
    if (value.abs() >= 1000000) {
      return value.toStringAsExponential(2);
    }
    return value.toString();
  }

  void calculate(String operation) {
    final currentValue = double.tryParse(display);
    if (currentValue == null) return;

    setState(() {
      feedback = null;
      if (pendingOperation == null || startNewEntry) {
        storedValue = currentValue;
      } else {
        final value = performCalculation(
          storedValue!,
          currentValue,
          pendingOperation!,
        );
        if (value == null) return;
        display = formatResult(value);
        storedValue = value;
      }
      pendingOperation = operation;
      expression = '$display $operation';
      startNewEntry = true;
    });
  }

  double? performCalculation(double first, double second, String operation) {
    if (operation == '÷' && second == 0) {
      feedback = 'Cannot divide by zero';
      return null;
    }
    final value = switch (operation) {
      '+' => first + second,
      '-' => first - second,
      '×' => first * second,
      '÷' => first / second,
      _ => first,
    };
    if (!value.isFinite) {
      feedback = 'Result is too large';
      return null;
    }
    return value;
  }

  void showAnswer() {
    final first = storedValue;
    final operation = pendingOperation;
    final second = double.tryParse(display);
    if (first == null || operation == null || second == null) return;

    setState(() {
      feedback = null;
      final value = performCalculation(first, second, operation);
      if (value == null) return;
      final calculation =
          '${formatResult(first)} $operation ${formatResult(second)} = ${formatResult(value)}';
      display = formatResult(value);
      expression = calculation;
      history.insert(0, calculation);
      if (history.length > 5) {
        history.removeLast();
      }
      storedValue = null;
      pendingOperation = null;
      startNewEntry = true;
    });
  }

  void enterDigit(String digit) {
    setState(() {
      feedback = null;
      if (startNewEntry) {
        if (pendingOperation == null) expression = '';
        display = digit;
        startNewEntry = false;
      } else if (display.length < 16) {
        display = display == '0' ? digit : '$display$digit';
      }
    });
  }

  void enterDecimal() {
    setState(() {
      feedback = null;
      if (startNewEntry) {
        display = '0.';
        startNewEntry = false;
      } else if (!display.contains('.')) {
        display = '$display.';
      }
    });
  }

  void toggleSign() {
    final value = double.tryParse(display);
    if (value == null || value == 0) return;
    setState(() {
      display = display.startsWith('-') ? display.substring(1) : '-$display';
      startNewEntry = false;
      feedback = null;
    });
  }

  void backspace() {
    setState(() {
      feedback = null;
      if (startNewEntry || display.length <= 1) {
        display = '0';
        startNewEntry = false;
      } else {
        final shortened = display.substring(0, display.length - 1);
        display = shortened == '-' ? '0' : shortened;
      }
    });
  }

  void applyToCurrentField(String operation) {
    final value = double.tryParse(display);
    if (value == null) {
      setState(() => feedback = 'Enter a valid number');
      return;
    }

    if (operation == '%' && value < 0) {
      setState(() => feedback = 'Percentage cannot use negatives');
      return;
    }

    double updatedValue;
    switch (operation) {
      case '%':
        updatedValue = value / 100;
        break;
      case '√':
        if (value < 0) {
          setState(() => feedback = 'Cannot square root a negative');
          return;
        }
        updatedValue = math.sqrt(value);
        break;
      case 'x²':
        updatedValue = value * value;
        break;
      case '1/x':
        if (value == 0) {
          setState(() => feedback = 'Cannot divide by zero');
          return;
        }
        updatedValue = 1 / value;
        break;
      default:
        updatedValue = value;
    }

    if (!updatedValue.isFinite) {
      setState(() => feedback = 'Result is too large');
      return;
    }
    setState(() {
      expression = '$operation($display)';
      display = formatResult(updatedValue);
      startNewEntry = true;
      feedback = null;
    });
  }

  void memoryAction(String action) {
    final currentValue = double.tryParse(display);

    switch (action) {
      case 'MC':
        memoryValue = null;
        setState(() => feedback = 'Memory cleared');
        return;
      case 'MR':
        if (memoryValue == null) {
          setState(() => feedback = 'No saved memory');
          return;
        }
        setState(() {
          display = formatResult(memoryValue!);
          startNewEntry = true;
          feedback = null;
        });
        return;
      case 'M+':
        if (currentValue == null) {
          setState(() => feedback = 'Enter a valid number');
          return;
        }
        memoryValue = (memoryValue ?? 0) + currentValue;
        setState(() => feedback = 'Memory + ${formatResult(memoryValue!)}');
        return;
      case 'M-':
        if (currentValue == null) {
          setState(() => feedback = 'Enter a valid number');
          return;
        }
        memoryValue = (memoryValue ?? 0) - currentValue;
        setState(() => feedback = 'Memory - ${formatResult(memoryValue!)}');
        return;
    }
  }

  void clearFields() {
    setState(() {
      display = '0';
      expression = '';
      feedback = null;
      storedValue = null;
      pendingOperation = null;
      startNewEntry = true;
    });
  }

  void showHistory() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Previous calculations'),
        content: history.isEmpty
            ? const Text('No calculations yet.')
            : SizedBox(
                width: double.maxFinite,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: history.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) => Text(history[index]),
                ),
              ),
        actions: [
          if (history.isNotEmpty)
            TextButton(
              onPressed: () {
                setState(history.clear);
                Navigator.of(context).pop();
              },
              child: const Text('Clear history'),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Widget calculatorKey(
    String label,
    VoidCallback onPressed, {
    bool utility = false,
    bool operation = false,
    int flex = 1,
  }) {
    final background = operation
        ? const Color(0xFFD5E86C)
        : utility
        ? const Color(0xFF343C39)
        : const Color(0xFF202724);
    final foreground = operation
        ? const Color(0xFF17200C)
        : utility
        ? const Color(0xFFE6EBE8)
        : Colors.white;
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox.expand(
          child: FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: background,
              foregroundColor: foreground,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget keyRow(List<Widget> keys) => Expanded(child: Row(children: keys));

  Widget scientificKey(String label, VoidCallback onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFB8C2BD),
            side: BorderSide.none,
            backgroundColor: const Color(0xFF18201D),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  Widget scientificKeys() {
    return SizedBox(
      height: 92,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                scientificKey('%', () => applyToCurrentField('%')),
                scientificKey('√', () => applyToCurrentField('√')),
                scientificKey('x²', () => applyToCurrentField('x²')),
                scientificKey('1/x', () => applyToCurrentField('1/x')),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                scientificKey('MC', () => memoryAction('MC')),
                scientificKey('MR', () => memoryAction('MR')),
                scientificKey('M+', () => memoryAction('M+')),
                scientificKey('M−', () => memoryAction('M-')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget keypad() {
    return Expanded(
      flex: 5,
      child: Column(
        children: [
          keyRow([
            calculatorKey('AC', clearFields, utility: true),
            calculatorKey('±', toggleSign, utility: true),
            calculatorKey('%', () => applyToCurrentField('%'), utility: true),
            calculatorKey('÷', () => calculate('÷'), operation: true),
          ]),
          keyRow([
            calculatorKey('7', () => enterDigit('7')),
            calculatorKey('8', () => enterDigit('8')),
            calculatorKey('9', () => enterDigit('9')),
            calculatorKey('×', () => calculate('×'), operation: true),
          ]),
          keyRow([
            calculatorKey('4', () => enterDigit('4')),
            calculatorKey('5', () => enterDigit('5')),
            calculatorKey('6', () => enterDigit('6')),
            calculatorKey('−', () => calculate('-'), operation: true),
          ]),
          keyRow([
            calculatorKey('1', () => enterDigit('1')),
            calculatorKey('2', () => enterDigit('2')),
            calculatorKey('3', () => enterDigit('3')),
            calculatorKey('+', () => calculate('+'), operation: true),
          ]),
          keyRow([
            calculatorKey('⌫', backspace, utility: true),
            calculatorKey('0', () => enterDigit('0')),
            calculatorKey('.', enterDecimal),
            calculatorKey('=', showAnswer, operation: true),
          ]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1210),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
              child: Column(
                key: const Key('mobile-calculator-layout'),
                children: [
                  SizedBox(
                    height: 48,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calculate_rounded,
                          color: Color(0xFFD5E86C),
                        ),
                        const SizedBox(width: 9),
                        const Text(
                          'CALCULATOR',
                          style: TextStyle(
                            color: Color(0xFFB8C2BD),
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.4,
                          ),
                        ),
                        const Spacer(),
                        if (memoryValue != null)
                          const Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: Text(
                              'M',
                              style: TextStyle(
                                color: Color(0xFFD5E86C),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        IconButton(
                          key: const Key('show-history'),
                          tooltip: 'Calculation history',
                          onPressed: showHistory,
                          color: const Color(0xFFB8C2BD),
                          icon: const Icon(Icons.history_rounded),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 20, 8, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              expression,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: Color(0xFF7F8A85),
                                fontSize: 20,
                              ),
                            ),
                          ),
                          if (feedback != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                feedback!,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  color: Color(0xFFE98768),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerRight,
                              child: Text(
                                display,
                                key: const Key('result'),
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 68,
                                  fontWeight: FontWeight.w300,
                                  height: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  scientificKeys(),
                  const SizedBox(height: 5),
                  keypad(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
