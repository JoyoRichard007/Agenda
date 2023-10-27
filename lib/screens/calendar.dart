import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarEvent extends StatefulWidget {
  const CalendarEvent({Key? key}) : super(key: key);

  @override
  State<CalendarEvent> createState() => _CalendarEventState();
}

class _CalendarEventState extends State<CalendarEvent> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;
  Map<String, List> mySelectedEvents = {};

  final titleController = TextEditingController();
  final descpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = _focusedDay;
    loadPreviousEvents();
  }

  loadPreviousEvents() {
    mySelectedEvents = {
      "2023-12-25": [
        {"eventDescp": "Noël 2023", "eventTitle": "Noël"},
      ],
      "2023-31-25": [
        {"eventDescp": "Fin d'années", "eventTitle": "Reveillon"},
      ],
      "2024-01-01": [
        {"eventDescp": "Bonne année", "eventTitle": "Jour de l'an"},
      ],
      "2023-11-01": [
        {"eventDescp": "Halloween 2023", "eventTitle": "Halloween"},
        {"eventDescp": "Toussaint 2023", "eventTitle": "Toussaint"}
      ],
    };
  }

  List _listOfDayEvents(DateTime dateTime) {
    if (mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)] != null) {
      return mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)]!;
    } else {
      return [];
    }
  }

  void _showAddEventDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ajouter un nouvel événement'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Titre',
                ),
              ),
              TextField(
                controller: descpController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          TextButton(
            child: Text('Ajouter'),
            onPressed: () {
              if (titleController.text.isEmpty &&
                  descpController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Veuillez remplir tous les champs'),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Evénement ajouté avec succès'),
                    duration: Duration(seconds: 2),
                  ),
                );

                setState(() {
                  if (mySelectedEvents[
                          DateFormat('yyyy-MM-dd').format(_selectedDate!)] !=
                      null) {
                    mySelectedEvents[
                            DateFormat('yyyy-MM-dd').format(_selectedDate!)]
                        ?.add({
                      "eventTitle": titleController.text,
                      "eventDescp": descpController.text,
                    });
                  } else {
                    mySelectedEvents[
                        DateFormat('yyyy-MM-dd').format(_selectedDate!)] = [
                      {
                        "eventTitle": titleController.text,
                        "eventDescp": descpController.text,
                      }
                    ];
                  }
                });

                titleController.clear();
                descpController.clear();
                Navigator.pop(context);
                return;
              }
            },
          ),
        ],
      ),
    );
  }

  void _showEventDetailsDialog(BuildContext context, myEvent) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Détails de l\'événement'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Titre: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: myEvent['eventTitle']),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Description: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: myEvent['eventDescp']),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Date de l\'événement: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: DateFormat('yyyy-MM-dd').format(_selectedDate!),
                    ),
                  ],
                ),
              ),
              // Vous pouvez ajouter d'autres détails de l'événement ici
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fermer le dialogue
              },
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Agenda'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100.0),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime(2023),
              lastDay: DateTime(2025),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDate, selectedDay))
                  setState(() {
                    _focusedDay = focusedDay;
                    _selectedDate = selectedDay;
                  });
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDate, day);
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              eventLoader: _listOfDayEvents,
            ),
            ..._listOfDayEvents(_selectedDate!).map((myEvent) => ListTile(
                  leading: const Icon(
                    Icons.done,
                    color: Colors.green,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 0.8),
                    child: Text('Titre: ${myEvent['eventTitle']}'),
                  ),
                  subtitle: Text('Description: ${myEvent['eventDescp']}'),
                  onTap: () {
                    _showEventDetailsDialog(context, myEvent);
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Modifier l'événement"),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: titleController,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      decoration: InputDecoration(
                                        labelText: 'Nouveau Titre',
                                      ),
                                    ),
                                    TextField(
                                      controller: descpController,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      decoration: InputDecoration(
                                        labelText: 'Nouvelle Description',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Annuler'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    myEvent['eventTitle'] =
                                        titleController.text;
                                    myEvent['eventDescp'] =
                                        descpController.text;
                                    setState(() {});
                                    titleController.clear();
                                    descpController.clear();
                                    Navigator.pop(context);
                                  },
                                  child: Text('Enregistrer'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Confirmer la suppression"),
                              content: Text(
                                "Voulez-vous vraiment supprimer cet événement ?",
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text("Annuler"),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                TextButton(
                                  child: Text("Supprimer"),
                                  onPressed: () {
                                    setState(() {
                                      mySelectedEvents[DateFormat('yyyy-MM-dd')
                                              .format(_selectedDate!)]
                                          ?.remove(myEvent);
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEventDialog(),
        label: const Text('Ajouter un événement'),
      ),
    );
  }
}
