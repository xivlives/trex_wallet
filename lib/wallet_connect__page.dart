import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart'; // For MetaMask
import 'package:solana/solana.dart'; // For Solana Wallet

class WalletConnectPage extends StatefulWidget {
  const WalletConnectPage({Key? key}) : super(key: key);

  @override
  _WalletConnectPageState createState() => _WalletConnectPageState();
}

class _WalletConnectPageState extends State<WalletConnectPage> {
  // For MetaMask connection
  bool get isMetaMaskAvailable => ethereum != null;
  String? userAddress;
  final TextEditingController addressController = TextEditingController();

  // For Solana connection
  late SolanaClient solanaClient;

  @override
  void initState() {
    super.initState();
    solanaClient = SolanaClient(
      rpcUrl: Uri.parse('https://api.mainnet-beta.solana.com'),
      websocketUrl: Uri.parse('wss://api.mainnet-beta.solana.com'),
    );
  }

  Future<void> connectMetaMask() async {
    if (!isMetaMaskAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("MetaMask is not available")),
      );
      return;
    }

    try {
      final accounts = await ethereum!.requestAccount();
      setState(() {
        userAddress = accounts.first;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connected to MetaMask: $userAddress")),
      );
    } catch (e) {
      print("Error connecting to MetaMask: $e");
    }
  }

  Future<void> connectSolanaWallet() async {
    try {
      final address = addressController.text.trim();

      if (address.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter a valid Solana address")),
        );
        return;
      }

      // You can validate the Solana address or proceed with the connection.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connected to Solana: $address")),
      );
    } catch (e) {
      print("Error connecting to Solana Wallet: $e");
    }
  }

  Future<void> connectTrustWallet() async {
    if (!isMetaMaskAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Trust Wallet is not available")),
      );
      return;
    }

    try {
      final address = addressController.text.trim();

      if (address.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter a valid Trust Wallet address")),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connected to Trust Wallet: $address")),
      );
    } catch (e) {
      print("Error connecting to Trust Wallet: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Connect Your Wallet",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: "Enter your wallet address",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: connectSolanaWallet,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.purple,
                ),
                child: const Text("Connect Solana Wallet"),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: connectTrustWallet,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.blue,
                ),
                child: const Text("Connect Trust Wallet"),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: connectMetaMask,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.orange,
                ),
                child: const Text("Connect MetaMask Wallet"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
