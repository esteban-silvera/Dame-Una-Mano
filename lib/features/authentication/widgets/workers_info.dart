import 'package:flutter/material.dart';
import 'package:dame_una_mano/features/authentication/widgets/widgets.dart';

class WorkerForm extends StatefulWidget {
  const WorkerForm({Key? key}) : super(key: key);

  @override
  _WorkerFormState createState() => _WorkerFormState();
}

class _WorkerFormState extends State<WorkerForm> {
  final _formKey = GlobalKey<FormState>();
  String _description = '';
  String _phoneNumber = '';
  List<String> _selectedJobs = [];
  String _selectedDepartment = '';
  String _selectedCity = '';
  Set<String> _selectedNeighborhood = {};

  final List<String> _jobs = ['Carpintero', 'Plomero', 'Electricista'];
  final List<String> _departments = [
    'Departamento 1',
    'Departamento 2',
    'Departamento 3'
  ];
  final List<String> _cities = ['Ciudad 1', 'Ciudad 2', 'Ciudad 3'];
  final List<String> _neighborhoods = ['Barrio 1', 'Barrio 2', 'Barrio 3'];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Descripción *',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Color(0xFF43c7ff)),
                  ),
                ),
                maxLength: 500,
                maxLines: null,
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una descripción';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Número de Teléfono *',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Color(0xFF43c7ff)),
                  ),
                ),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  setState(() {
                    _phoneNumber = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un número de teléfono';
                  }
                  // Validar que solo sean números y hasta 15 caracteres
                  if (!RegExp(r'^[0-9]{1,15}$').hasMatch(value)) {
                    return 'Ingresa un número de teléfono válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _showJobsDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(244, 255, 255, 255),
                  side: const BorderSide(color: Color(0xFF43c7ff)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Container(
                  height: 63,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 20,
                        child: Text(
                          'Seleccionar Profesión',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Departamento *',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Color(0xFF43c7ff)),
                  ),
                ),
                value:
                    _selectedDepartment.isNotEmpty ? _selectedDepartment : null,
                onChanged: (newValue) {
                  setState(() {
                    _selectedDepartment = newValue!;
                  });
                },
                items: _departments.map((department) {
                  return DropdownMenuItem<String>(
                    value: department,
                    child: Text(department),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor selecciona un departamento';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              if (_selectedDepartment.isNotEmpty)
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Ciudad *',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Color(0xFF43c7ff)),
                    ),
                  ),
                  value: _selectedCity.isNotEmpty ? _selectedCity : null,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCity = newValue!;
                    });
                  },
                  items: _cities.map((city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor selecciona una ciudad';
                    }
                    return null;
                  },
                ),
              SizedBox(height: 20),
              if (_selectedCity.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Barrio *',
                      style: TextStyle(color: Color(0xFF43c7ff)),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: _neighborhoods.map((neighborhood) {
                        return FilterChip(
                          label: Text(neighborhood),
                          selected:
                              _selectedNeighborhood.contains(neighborhood),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedNeighborhood.add(neighborhood);
                              } else {
                                _selectedNeighborhood.remove(neighborhood);
                              }
                            });
                          },
                          selectedColor: Color(0xFF43c7ff),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 10),
                    _selectedNeighborhood.isEmpty
                        ? Text(
                            'Por favor selecciona al menos un barrio',
                            style: TextStyle(color: Colors.red),
                          )
                        : SizedBox(),
                  ],
                ),
              SizedBox(height: 20),
              CustomButton(
                text: 'Enviar',
                color: Colors.orange,
                fontSize: 16,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print('Descripción: $_description');
                    print('Número de Teléfono: $_phoneNumber');
                    print('Trabajos: $_selectedJobs');
                    print('Departamento: $_selectedDepartment');
                    print('Ciudad: $_selectedCity');
                    print('Barrio: $_selectedNeighborhood');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showJobsDialog() async {
    List<String>? selectedJobs = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecciona Profesión'),
          content: MultiSelectChip(
            options: _jobs,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(_selectedJobs);
              },
              child: const Text(
                'Aceptar',
                style: TextStyle(color: Color(0xFF43c7ff)),
              ),
            ),
          ],
        );
      },
    );

    if (selectedJobs != null) {
      setState(() {
        _selectedJobs = selectedJobs;
      });
    }
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> options;

  const MultiSelectChip({Key? key, required this.options}) : super(key: key);

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  Set<String> selectedChoices = {};

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: List<Widget>.generate(
        widget.options.length,
        (index) {
          return ChoiceChip(
            label: Text(widget.options[index]),
            selected: selectedChoices.contains(widget.options[index]),
            onSelected: (selected) {
              setState(() {
                selected
                    ? selectedChoices.add(widget.options[index])
                    : selectedChoices.remove(widget.options[index]);
              });
            },
          );
        },
      ).toList(),
    );
  }
}
