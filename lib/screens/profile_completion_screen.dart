import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/enums.dart';
import '../providers/app_state.dart';

class ProfileCompletionScreen extends StatefulWidget {
  const ProfileCompletionScreen({super.key});

  @override
  State<ProfileCompletionScreen> createState() => _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState extends State<ProfileCompletionScreen> {
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  ProgramType _program = ProgramType.mbs;
  PartyAffiliation _party = PartyAffiliation.nationalist;
  String? _imagePath;

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (file == null) return;
    setState(() => _imagePath = file.path);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Full Name')),
          const SizedBox(height: 12),
          TextField(controller: _cityController, decoration: const InputDecoration(labelText: 'City')),
          const SizedBox(height: 12),
          DropdownButtonFormField<ProgramType>(
            value: _program,
            items: const [
              DropdownMenuItem(value: ProgramType.mbs, child: Text('Missouri Boys State')),
              DropdownMenuItem(value: ProgramType.mgs, child: Text('Missouri Girls State')),
            ],
            onChanged: (v) => setState(() => _program = v ?? ProgramType.mbs),
            decoration: const InputDecoration(labelText: 'Program'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<PartyAffiliation>(
            value: _party,
            items: const [
              DropdownMenuItem(value: PartyAffiliation.nationalist, child: Text('Nationalist')),
              DropdownMenuItem(value: PartyAffiliation.federalist, child: Text('Federalist')),
            ],
            onChanged: (v) => setState(() => _party = v ?? PartyAffiliation.nationalist),
            decoration: const InputDecoration(labelText: 'Party'),
          ),
          const SizedBox(height: 12),
          if (_imagePath != null)
            Image.file(File(_imagePath!), height: 100, width: 100, fit: BoxFit.cover),
          TextButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.photo),
            label: const Text('Upload Profile Photo'),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              if (_nameController.text.trim().isEmpty || _cityController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Name and city are required.')),
                );
                return;
              }
              state.completeProfile(
                name: _nameController.text,
                city: _cityController.text,
                programType: _program,
                partyAffiliation: _party,
                profilePicture: _imagePath,
              );
            },
            child: const Text('Save Profile'),
          ),
        ],
      ),
    );
  }
}
