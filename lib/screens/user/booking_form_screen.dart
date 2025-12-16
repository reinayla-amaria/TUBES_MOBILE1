// File: lib/screens/user/booking_form_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/court_model.dart';
import '../../providers/booking_provider.dart';

class BookingFormScreen extends StatefulWidget {
  final Court court;
  const BookingFormScreen({super.key, required this.court});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  String _selectedTime = "08:00";
  int _duration = 1;

  final List<String> _timeSlots = List.generate(
    15,
    (index) => "${(8 + index).toString().padLeft(2, '0')}:00",
  );

  @override
  Widget build(BuildContext context) {
    final bookingProv = Provider.of<BookingProvider>(context);
    final totalPrice = widget.court.pricePerHour * _duration;

    return Scaffold(
      appBar: AppBar(title: const Text("Form Reservasi")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Lapangan: ${widget.court.name}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Input Tanggal
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Tanggal Main",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_month),
                ),
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (picked != null) {
                    setState(
                      () => _dateController.text = DateFormat(
                        'yyyy-MM-dd',
                      ).format(picked),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),

              // Input Jam & Durasi
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        labelText: "Jam Mulai",
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedTime,
                      items: _timeSlots
                          .map(
                            (t) => DropdownMenuItem(value: t, child: Text(t)),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _selectedTime = val.toString()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        labelText: "Durasi (Jam)",
                        border: OutlineInputBorder(),
                      ),
                      value: _duration,
                      items: [1, 2, 3, 4, 5]
                          .map(
                            (d) => DropdownMenuItem(
                              value: d,
                              child: Text("$d Jam"),
                            ),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _duration = val as int),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Total Harga
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Estimasi:"),
                      Text(
                        "Rp ${NumberFormat('#,###', 'id_ID').format(totalPrice)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    foregroundColor: Colors.white,
                  ),
                  onPressed: bookingProv.isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            bool success = await bookingProv.createBooking(
                              widget.court.id,
                              DateTime.parse(_dateController.text),
                              _selectedTime,
                              _duration,
                            );
                            if (success && mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Booking Berhasil!"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.pop(context);
                            }
                          }
                        },
                  child: bookingProv.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("KONFIRMASI BOOKING"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
