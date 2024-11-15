import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final String correctPassword = '12345';
  String username = '';

  void _login() {
    String enteredUsername = _usernameController.text;
    String enteredPassword = _passwordController.text;

    if (enteredPassword != correctPassword) {
      _showError("Wrong password, please try again.");
    } else {
      setState(() {
        username = enteredUsername; 
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => WithdrawCashScreen(username: username)),
      );
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("ERROR"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("InfoSuper Bank"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/banklogox.png',
                width: 100,
                height: 100,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text("LOGIN"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WithdrawCashScreen extends StatefulWidget {
  final String username; 

  WithdrawCashScreen({required this.username});

  @override
  _WithdrawCashScreenState createState() => _WithdrawCashScreenState();
}

class _WithdrawCashScreenState extends State<WithdrawCashScreen> {
  final _amountController = TextEditingController();
  double availableBalance = 10000.0;

  void _attemptWithdrawal() async {
    double? withdrawalAmount = double.tryParse(_amountController.text);
    if (withdrawalAmount == null || withdrawalAmount <= 0) {
      _showError("Please enter a valid amount.");
      return;
    }

    if (withdrawalAmount > availableBalance) {
      _showError("Insufficient funds.");
    } else {
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        availableBalance -= withdrawalAmount;
      });
      _showConfirmation("Withdrawal Successful!");
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("ERROR"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showConfirmation(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("SUCCESSFUL"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WITHDRAWAL"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/banklogox.png',
                width: 100,
                height: 100,
              ),
              SizedBox(height: 20),
              Text(
                "Welcome, ${widget.username}!", 
                style: TextStyle(fontSize: 20, color: Colors.blue),
              ),
              SizedBox(height: 20),
              Text(
                "BALANCE: ₺${availableBalance.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "WITHDRAW AMOUNT",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _attemptWithdrawal,
                child: Text("WITHDRAW MONEY"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
