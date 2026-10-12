import 'package:flutter/material.dart';

// --- 1. THE "DATABASE" (No CSV needed for now) ---
class Unit {
  final String name;
  final int points;
  final int attacks;
  final int strength;
  final int damage;

  Unit(this.name, this.points, this.attacks, this.strength, this.damage);
}

// Units
final List<Unit> unitDatabase = [
  Unit("Space Marine Intercessor", 20, 2, 4, 1),
  Unit("Ork Boy", 8, 2, 4, 1),
  Unit("Necron Warrior", 13, 1, 4, 1),
  Unit("Custodes Guard", 45, 3, 5, 2),
  Unit("Tyranid Hormagaunt", 6, 2, 3, 1),
  Unit("Tau Fire Warrior", 9, 1, 3, 1),
  Unit("Grey Knight Terminator", 40, 3, 6, 2),
  Unit("Eldar Banshee", 18, 2, 4, 1),
  Unit("Cyber-Titan Prototype", 100, 10, 8, 5),
];

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Color(0xFF1A1A1A),
      primaryColor: Colors.red[900],
      colorScheme: ColorScheme.dark(primary: Colors.red[900]!),
    ),
    home: BattleScreen(),
  ),
);

// class BattleScreen extends StatefulWidget {
//   @override
//   _BattleScreenState createState() => _BattleScreenState();
// }
class BattleScreen extends StatefulWidget {
  // Fix 1: Add the 'key'
  const BattleScreen({super.key});

  @override
  // Fix 2: Use 'State<BattleScreen>' instead of the private name
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  Unit? unitA;
  Unit? unitB;
  String result = "Select two units to simulate battle...";

  // --- 2. THE "AI" LOGIC (Moved from Python to Dart) ---
  void simulateBattle() {
    if (unitA == null || unitB == null) return;

    // The Efficiency Algorithm
    double scoreA =
        (unitA!.attacks * unitA!.strength * unitA!.damage) / unitA!.points;
    double scoreB =
        (unitB!.attacks * unitB!.strength * unitB!.damage) / unitB!.points;

    // Determine Winner
    bool aWins = scoreA > scoreB;
    Unit winner = aWins ? unitA! : unitB!;
    double ratio = aWins ? scoreA / scoreB : scoreB / scoreA;

    setState(() {
      result =
          "🏆 WINNER: ${winner.name} 🏆\n\n"
          "Analysis (Edge Computing):\n"
          "${winner.name} is ${ratio.toStringAsFixed(1)}x more cost-effective based on DPS-to-Points ratio.\n\n"
          "Efficiency Scores:\n"
          "${unitA!.name}: ${scoreA.toStringAsFixed(2)}\n"
          "${unitB!.name}: ${scoreB.toStringAsFixed(2)}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Warhammer 40k Tacticus"),
        backgroundColor: Colors.red[900],
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Unit A Dropdown
            _buildDropdown(
              "Select Unit A (Attacker)",
              unitA,
              (val) => setState(() => unitA = val),
            ),

            SizedBox(height: 20),

            // Unit B Dropdown
            _buildDropdown(
              "Select Unit B (Defender)",
              unitB,
              (val) => setState(() => unitB = val),
            ),

            SizedBox(height: 40),

            // Simulate Button
            ElevatedButton(
              onPressed: simulateBattle,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[900],
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "SIMULATE BATTLE",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            SizedBox(height: 30),

            // Results Box
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[800]!),
              ),
              child: Text(
                result,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String hint,
    Unit? selectedValue,
    Function(Unit?) onChanged,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Unit>(
          value: selectedValue,
          hint: Text(hint, style: TextStyle(color: Colors.grey[400])),
          isExpanded: true,
          dropdownColor: Colors.grey[800],
          items: unitDatabase.map((Unit u) {
            return DropdownMenuItem<Unit>(
              value: u,
              child: Text(u.name, style: TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
