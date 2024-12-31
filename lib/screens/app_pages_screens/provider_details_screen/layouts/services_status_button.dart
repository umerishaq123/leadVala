import 'package:flutter/material.dart';

class ServicesStatusButton extends StatefulWidget {
  const ServicesStatusButton({super.key});

  @override
  _ServicesStatusButtonState createState() => _ServicesStatusButtonState();
}

class _ServicesStatusButtonState extends State<ServicesStatusButton> {
  String? selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: [
        _buildStatusButton(context, 'Interested'),
        _buildStatusButton(context, 'Not Connected'),
        _buildStatusButton(context, 'In Progress'),
        _buildStatusButton(context, 'Not Answer'),
        _buildStatusButton(context, 'Converted'),
        _buildStatusButton(context, 'Visited'),
        _buildStatusButton(context, 'Deal'),
      ],
    );
  }

  Widget _buildStatusButton(BuildContext context, String status) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          selectedStatus = status;
        });
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: selectedStatus == status ? Colors.green : Colors.grey,
        ),
      ),
      child: Text(status, style: TextStyle(color: selectedStatus == status ? Colors.green : Colors.black)),
    );
  }
}
