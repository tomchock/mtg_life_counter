import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Life Counter for MTG',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Arial', // Imposta un font semplice e stiloso
      ),
      home: PlayerSelectionScreen(),
    );
  }
}

class PlayerSelectionScreen extends StatefulWidget {
  @override
  _PlayerSelectionScreenState createState() => _PlayerSelectionScreenState();
}

class _PlayerSelectionScreenState extends State<PlayerSelectionScreen> {
  int _numPlayers = 2;
  int _startingLife = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Game Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Select Number of Players',
              style: TextStyle(fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _numPlayers = 2;
                    });
                  },
                  child: Text('2 Players'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _numPlayers == 2 ? Colors.blue : Colors.grey,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _numPlayers = 4;
                    });
                  },
                  child: Text('4 Players'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _numPlayers == 4 ? Colors.blue : Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Select Starting Life Points',
              style: TextStyle(fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _startingLife = 20;
                    });
                  },
                  child: Text('20'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _startingLife == 20 ? Colors.green : Colors.grey,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _startingLife = 40;
                    });
                  },
                  child: Text('40'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _startingLife == 40 ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LifeCounterScreen(
                      numPlayers: _numPlayers,
                      startingLife: _startingLife,
                    ),
                  ),
                );
              },
              child: Text('Start Game'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LifeCounterScreen extends StatefulWidget {
  final int numPlayers;
  final int startingLife;

  LifeCounterScreen({required this.numPlayers, required this.startingLife});

  @override
  _LifeCounterScreenState createState() => _LifeCounterScreenState();
}

class _LifeCounterScreenState extends State<LifeCounterScreen> {
  late List<int> lifePoints;
  late List<int> poisonCounters;
  late List<int> commanderCosts;

  @override
  void initState() {
    super.initState();
    lifePoints =
        List.generate(widget.numPlayers, (index) => widget.startingLife);
    poisonCounters = List.generate(widget.numPlayers, (index) => 0);
    commanderCosts = List.generate(widget.numPlayers, (index) => 0);
  }

  @override
  Widget build(BuildContext context) {
    List<Color> playerColors = [
      Colors.pink[200]!,
      Colors.green[200]!,
      Colors.blue[200]!,
      Colors.yellow[200]!
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Life Counter for MTG'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.numPlayers == 2 ? 1 : 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: widget.numPlayers,
          itemBuilder: (context, index) {
            bool shouldRotate = index < 2; // Ruota solo le prime due carte
            return Transform.rotate(
              angle: shouldRotate ? 3.14159 : 0, // 180 gradi in radianti
              child: PlayerCard(
                playerIndex: index,
                lifePoints: lifePoints[index],
                poisonCounters: poisonCounters[index],
                commanderCost: commanderCosts[index],
                playerColor: playerColors[index],
                onLifeIncrement: () => _incrementLife(index),
                onLifeDecrement: () => _decrementLife(index),
                onPoisonIncrement: () => _incrementPoison(index),
                onPoisonDecrement: () => _decrementPoison(index),
                onCommanderCostIncrement: () => _incrementCommanderCost(index),
                onCommanderCostDecrement: () => _decrementCommanderCost(index),
              ),
            );
          },
        ),
      ),
    );
  }

  void _incrementLife(int index) {
    setState(() {
      lifePoints[index]++;
    });
  }

  void _decrementLife(int index) {
    setState(() {
      lifePoints[index]--;
    });
  }

  void _incrementPoison(int index) {
    setState(() {
      poisonCounters[index]++;
    });
  }

  void _decrementPoison(int index) {
    setState(() {
      poisonCounters[index]--;
    });
  }

  void _incrementCommanderCost(int index) {
    setState(() {
      commanderCosts[index]++;
    });
  }

  void _decrementCommanderCost(int index) {
    setState(() {
      commanderCosts[index]--;
    });
  }
}

class PlayerCard extends StatelessWidget {
  final int playerIndex;
  final int lifePoints;
  final int poisonCounters;
  final int commanderCost;
  final Color playerColor;
  final VoidCallback onLifeIncrement;
  final VoidCallback onLifeDecrement;
  final VoidCallback onPoisonIncrement;
  final VoidCallback onPoisonDecrement;
  final VoidCallback onCommanderCostIncrement;
  final VoidCallback onCommanderCostDecrement;

  PlayerCard({
    required this.playerIndex,
    required this.lifePoints,
    required this.poisonCounters,
    required this.commanderCost,
    required this.playerColor,
    required this.onLifeIncrement,
    required this.onLifeDecrement,
    required this.onPoisonIncrement,
    required this.onPoisonDecrement,
    required this.onCommanderCostIncrement,
    required this.onCommanderCostDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: playerColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Sezione per i punti vita
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove, size: 32),
                    onPressed: onLifeDecrement,
                  ),
                  Text(
                    '$lifePoints',
                    style: TextStyle(
                      fontSize: 280,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, size: 32),
                    onPressed: onLifeIncrement,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Sezione per i segnalini veleno e commander
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Icon(Icons.add_moderator_sharp,
                        size: 32), // Icona costo commander
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove, size: 24),
                          onPressed: onPoisonDecrement,
                        ),
                        Text('$poisonCounters'),
                        IconButton(
                          icon: Icon(Icons.add, size: 24),
                          onPressed: onPoisonIncrement,
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      Icons.warning,
                      size: 24,
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove, size: 24),
                          onPressed: onCommanderCostDecrement,
                        ),
                        Text('$commanderCost'),
                        IconButton(
                          icon: Icon(Icons.add, size: 24),
                          onPressed: onCommanderCostIncrement,
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.add_moderator_sharp,
                        size: 32), // Icona costo commander
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove, size: 24),
                          onPressed: onCommanderCostDecrement,
                        ),
                        Text('$commanderCost'),
                        IconButton(
                          icon: Icon(Icons.add, size: 24),
                          onPressed: onCommanderCostIncrement,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
