import 'package:flutter/material.dart';
import 'doctor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'doctor.dart';
import 'admin.dart';

class DoctorsAddedPage extends StatefulWidget {
  @override
  _DoctorsAddedPageState createState() => _DoctorsAddedPageState();
}

class _DoctorsAddedPageState extends State<DoctorsAddedPage> {
  List<Doctor> doctorsList = [];

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  void _loadDoctors() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      doctorsList = (prefs.getStringList('doctors') ?? [])
          .map((doctorString) => Doctor.fromString(doctorString))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctores Agregados'),
      ),
      body: ListView.builder(
        itemCount: doctorsList.length,
        itemBuilder: (context, index) {
          return DoctorListItem(doctor: doctorsList[index]);
        },
      ),
    );
  }
}

class DoctorListItem extends StatelessWidget {
  final Doctor doctor;

  DoctorListItem({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorDetailScreen(doctor: doctor),
            ),
          );
        },
        title: Text(
          'Dr. ${doctor.name} ${doctor.lastName}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Especialidad: ${doctor.specialties}'),
            Text('Horario: ${doctor.schedule}'), 
          ],
        ),
      ),
    );
  }
}


class DoctorDetailScreen extends StatelessWidget {
  final Doctor doctor;

  DoctorDetailScreen({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles'),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
                color: Color(0xFF700F1C),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Nombre:', '${doctor.name} ${doctor.lastName} ${doctor.motherLastName}'),
                  _buildDetailRow('Especialidades:', '${doctor.specialties.join(", ")}'),
                  _buildDetailRow('Horario:', _formatSchedule(doctor.schedule)),
                  _buildDetailRow('Descripción:', '${doctor.description}'),
                  _buildDetailRow('Educación:', '${doctor.education}'),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AddDoctorPage(editingDoctor: doctor),
            ),
          ).then((value) {
            if (value != null && value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Doctor editado exitosamente'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          });
        },
        child: Icon(Icons.edit),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatSchedule(String schedule) {
    List<String> parts = schedule.split(' - ');
    if (parts.length == 2) {
      return '${parts[0]} - ${parts[1]}';
    } else {
      return 'Formato de horario incorrecto';
    }
  }
}
