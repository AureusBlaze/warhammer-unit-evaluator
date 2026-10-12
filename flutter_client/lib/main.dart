import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(
  MaterialApp(
    theme: ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Color(0xFF1A1A1A),
      primaryColor: Colors.red[900],
    ),
    home: BattleScreen(),
  ),
);

class BattleScreen extends StatefulWidget {
  const BattleScreen({super.key});

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  //on Emulator: //http://10.0.2.2:5000'
  //on Phone: 'http://YOUR_LAPTOP_IP:5000'
  final String baseUrl = 'http://192.168.0.133:5000';

  String? unitA;
  String? unitB;
  List<String> units = [];
  String result = "Select two units to simulate battle...";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUnits();
  }

  Future<void> fetchUnits() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_units'));
      if (response.statusCode == 200) {
        setState(() {
          units = List<String>.from(jsonDecode(response.body));
        });
      } else {
        debugPrint("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Connection Error: $e");
      setState(
        () => result = "Error connecting to Python server.\nCheck IP address!",
      );
    }
  }

  Future<void> simulateBattle() async {
    if (unitA == null || unitB == null) return;

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/simulate_battle'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'unitA': unitA, 'unitB': unitB}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          result =
              "🏆 WINNER: ${data['winner']} 🏆\n\n"
              "Analysis:\n${data['analysis']}\n\n"
              "Score A: ${data['score_a']}\n"
              "Score B: ${data['score_b']}";
        });
      }
    } catch (e) {
      setState(() => result = "Error simulating battle.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Warhammer 40k Tacticus"),
        backgroundColor: Colors.red[900],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDropdown(
              "Select Unit A (Attacker)",
              unitA,
              (val) => setState(() => unitA = val),
            ),
            SizedBox(height: 20),
            _buildDropdown(
              "Select Unit B (Defender)",
              unitB,
              (val) => setState(() => unitB = val),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[900],
                foregroundColor: Colors.white,
              ),
              onPressed: isLoading ? null : simulateBattle,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  isLoading ? "CALCULATING..." : "SIMULATE BATTLE",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                result,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String hint,
    String? value,
    Function(String?) onChanged,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: TextStyle(color: Colors.grey[400])),
          isExpanded: true,
          dropdownColor: Colors.grey[800],
          items: units.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
