import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'doctor.dart';

class AddDoctorPage extends StatefulWidget {
  final Doctor? editingDoctor;

  AddDoctorPage({this.editingDoctor});

  @override
  _AddDoctorPageState createState() => _AddDoctorPageState();
}

class _AddDoctorPageState extends State<AddDoctorPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _motherLastNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _educationController = TextEditingController();

  List<String> specialties = [
    'Alergología',
    'Anestesiología',
    'Cardiología',
    'Cirugía',
    'Dermatología',
    'Endocrinología',
    'Gastroenterología',
    'Geriatría',
    'Ginecología',
    'Hematología',
    'Infectología',
    'Medicina de emergencia',
    'Medicina deportiva',
    'Medicina familiar',
    'Medicina interna',
    'Nefrología',
    'Neumología',
    'Neurología',
    'Obstetricia',
    'Oncología',
    'Oftalmología',
    'Ortopedia',
    'Otorrinolaringología',
    'Pediatría',
    'Psiquiatría',
    'Radiología',
    'Reumatología',
    'Traumatología',
    'Urología'
  ];

  String? _selectedSpecialty;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    if (widget.editingDoctor != null) {
      _nameController.text = widget.editingDoctor!.name;
      _lastNameController.text = widget.editingDoctor!.lastName;
      _motherLastNameController.text = widget.editingDoctor!.motherLastName;
      _selectedSpecialty =
          widget.editingDoctor!.specialties.isNotEmpty ? widget.editingDoctor!.specialties[0] : null;
      _descriptionController.text = widget.editingDoctor!.description;
      _educationController.text = widget.editingDoctor!.education;
      
      _startTime = TimeOfDay.fromDateTime(DateTime.parse(widget.editingDoctor!.schedule.split(' - ')[0]));
      _endTime = TimeOfDay.fromDateTime(DateTime.parse(widget.editingDoctor!.schedule.split(' - ')[1]));
    }
  }

 Future<void> _selectTime(BuildContext context, bool isStartTime) async {
  final picked = await showTimePicker(
    context: context,
    initialTime: isStartTime ? _startTime ?? TimeOfDay.now() : _endTime ?? TimeOfDay.now(),
  );
  if (picked != null) {
    setState(() {
      if (isStartTime) {
        _startTime = picked;
      } else {
        _endTime = picked;
      }
    });
  }
}

  void _saveDoctor() async {
    String name = _nameController.text;
    String lastName = _lastNameController.text;
    String motherLastName = _motherLastNameController.text;
    String schedule = '${_startTime!.hour}:${_startTime!.minute} - ${_endTime!.hour}:${_endTime!.minute}';
    String description = _descriptionController.text;
    String education = _educationController.text;

    Doctor doctor = Doctor(
      name: name,
      lastName: lastName,
      motherLastName: motherLastName,
      specialties: _selectedSpecialty != null ? [_selectedSpecialty!] : [],
      schedule: schedule,
      description: description,
      education: education,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> doctorsList = prefs.getStringList('doctors') ?? [];
    if (widget.editingDoctor != null) {
      int index = doctorsList.indexOf(widget.editingDoctor.toString());
      if (index != -1) {
        doctorsList[index] = doctor.toString();
      }
    } else {
      doctorsList.add(doctor.toString());
    }
    prefs.setStringList('doctors', doctorsList);

    _nameController.clear();
    _lastNameController.clear();
    _motherLastNameController.clear();
    _descriptionController.clear();
    _educationController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Doctor ${widget.editingDoctor != null ? 'editado' : 'agregado'} exitosamente'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Doctor'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nombres',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Nombre del Doctor',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Apellido Paterno',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  hintText: 'Apellido Paterno',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Apellido Materno',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),              SizedBox(height: 8),
              TextField(
                controller: _motherLastNameController,
                decoration: InputDecoration(
                  hintText: 'Apellido Materno',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Especialidad',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedSpecialty,
                items: specialties.map((String specialty) {
                  return DropdownMenuItem<String>(
                    value: specialty,
                    child: Text(specialty),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSpecialty = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Horario de Trabajo',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _selectTime(context, true),
                      child: Text(
                        'Hora de inicio: ${_startTime?.hour}:${_startTime?.minute}',
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _selectTime(context, false),
                      child: Text(
                        'Hora de fin: ${_endTime?.hour}:${_endTime?.minute}',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Descripción del Doctor',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Descripción del Doctor',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Formación del doctor',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _educationController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Formación del doctor',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: _saveDoctor,
                    child: Text('${widget.editingDoctor != null ? 'Guardar cambios' : 'Guardar'}'),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

             
