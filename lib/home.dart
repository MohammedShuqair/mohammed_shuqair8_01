import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piano/piano.dart';
import 'package:flutter_midi/flutter_midi.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  FlutterMidi flutterMidi = FlutterMidi();
  // late Future<void> _future;
  String selectedSf2 = sf2s['Flute']!;

  static const Map<String, String> sf2s = {
    'Flute': 'assets/sf2/flute.sf2',
    'Guitar': 'assets/sf2/guitars.sf2',
    'Yamaha Grand': 'assets/sf2/yamaha_grand.sf2',
    'Wurlitzer Piano': 'assets/sf2/Discarded_Wurlitzer_piano.sf2',
    'Bubsy': 'assets/sf2/Bubsy.sf2',
    'Castleween': 'assets/sf2/Castleween.sf2',
    'Drawn To Life': 'assets/sf2/DrawnToLife.sf2',
    'Drawn To Life Looped': 'assets/sf2/DrawnToLife_LOOPED.sf2',
    'Marko': 'assets/sf2/Marko.sf2',
    'Reptar': 'assets/sf2/Rugrats_Search_For_Reptar_Soundfont_1.2.4.sf2',
    'Water Piano': 'assets/sf2/WaterPianoSoundfont.sf2',
  };

  Future<void> load(String asset) async {
    flutterMidi.unmute(); // Optionally Unmute
    ByteData _byte = await rootBundle.load(asset);
    flutterMidi.prepare(
      sf2: _byte,
      name: selectedSf2.replaceAll('assets/sf2/', ''),
    );
    stop();
  }

  Future<void> change(String asset) async {
    ByteData _byte = await rootBundle.load(asset);
    flutterMidi.changeSound(sf2: _byte);
  }

  void stop() {
    for (int i = 60; i <= 84; i++) {
      flutterMidi.stopMidiNote(midi: i);
      print("$i stoped");
    }
  }

  List<int>? currentMusic = [];
  Map<String, List<int>> musics = {
    'Mine': [60, 61, 62, 63, 64, 65]
  };
  Future<void> playMusic() async {
    for (int midi in currentMusic!) {
      flutterMidi.playMidiNote(midi: midi);
      await Future.delayed(const Duration(milliseconds: 100));
      print('playMusic $midi');
    }
  }

  // Future<void> loadAll() async {
  //   for (String path in sf2s.values) {
  //     await load(path);
  //   }
  // }

  @override
  void initState() {
    currentMusic = musics['Mine'];
    load(selectedSf2);
    super.initState();
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isSave = false;
  String? name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music"),
        actions: [
          IconButton(
              onPressed: () {
                if (isSave) {
                  setState(() {
                    isSave = false;
                  });
                } else {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return SingleChildScrollView(
                          child: AlertDialog(
                            title: const Text("Insert Name"),
                            content: Form(
                              key: formKey,
                              child: TextFormField(
                                validator: (data) {
                                  if (data == null || data.isEmpty) {
                                    return "Please enter name";
                                  } else {
                                    if (musics.keys.any((key) => key == data)) {
                                      return "you have another music with same name";
                                    }
                                  }
                                },
                                onChanged: (String value) {
                                  name = value;
                                },
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    setState(() {
                                      musics.addAll({name!: []});
                                      isSave = true;
                                    });
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text("save"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("cansel"),
                              ),
                            ],
                          ),
                        );
                      });
                }
              },
              icon: !isSave
                  ? const Icon(
                      Icons.save_sharp,
                      color: Colors.green,
                    )
                  : const Icon(
                      Icons.stop,
                      color: Colors.red,
                    )),
          DropdownButton<List<int>?>(
            value: currentMusic,
            items: musics.entries
                .map((e) => DropdownMenuItem<List<int>>(
                      value: e.value,
                      child: Text(e.key),
                    ))
                .toList(),
            onChanged: (value) async {
              setState(() {
                currentMusic = value ?? [];
              });
              if (currentMusic != null && currentMusic!.isNotEmpty) {
                await playMusic();
              }
            },
          ),
          const SizedBox(
            width: 8,
          ),
          DropdownButton<String>(
            value: selectedSf2,
            items: sf2s.entries
                .map((e) => DropdownMenuItem<String>(
                      value: e.value,
                      child: Text(e.key),
                    ))
                .toList(),
            onChanged: (value) {
              if (selectedSf2 != value) {
                setState(() {
                  selectedSf2 = value ?? "assets/sf2/guitars.sf2";
                });
                load(selectedSf2);
              }
            },
          ),
          TextButton(
              onPressed: () {
                stop();
                setState(() {});
              },
              child: const Text("Stop")),
        ],
      ),
      body: Center(
        child: InteractivePiano(
          highlightedNotes: [NotePosition(note: Note.C, octave: 3)],
          naturalColor: Colors.white,
          accidentalColor: Colors.black,
          keyWidth: null,
          noteRange: NoteRange.forClefs([
            Clef.Treble,
          ]),
          onNotePositionTapped: (NotePosition position) {
            if (isSave) {
              musics[name!]?.add(position.pitch);
            }
            flutterMidi.playMidiNote(midi: position.pitch);
            print(position.pitch);
          },
        ),
      ),
    );
  }
}
