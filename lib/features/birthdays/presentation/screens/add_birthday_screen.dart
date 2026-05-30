import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/birthday_model.dart';
import '../providers/birthday_providers.dart';

class AddBirthdayScreen extends ConsumerStatefulWidget {
  /// When non-null, the screen operates in edit mode.
  final int? birthdayId;

  const AddBirthdayScreen({super.key, this.birthdayId});

  @override
  ConsumerState<AddBirthdayScreen> createState() => _AddBirthdayScreenState();
}

class _AddBirthdayScreenState extends ConsumerState<AddBirthdayScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _relationController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _selectedDate;
  BirthdayModel? _existing;
  bool _loading = true;
  bool _saving = false;
  bool _notFound = false;

  bool get _isEdit => widget.birthdayId != null;

  @override
  void initState() {
    super.initState();
    _loadExisting();
  }

  Future<void> _loadExisting() async {
    if (_isEdit) {
      final repo = ref.read(birthdayRepositoryProvider);
      final found = await repo.getBirthdayById(widget.birthdayId!);
      if (found != null) {
        _existing = found;
        _nameController.text = found.name;
        _relationController.text = found.relation ?? '';
        _notesController.text = found.notes ?? '';
        _selectedDate = found.dateOfBirth;
      } else {
        // Record deleted or ID is stale — treat as not found.
        if (mounted) setState(() { _loading = false; _notFound = true; });
        return;
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _relationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date of birth.')),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final repo = ref.read(birthdayRepositoryProvider);
      final birthday = (_existing ?? BirthdayModel())
        ..name = _nameController.text.trim()
        ..dateOfBirth = _selectedDate!
        ..relation = _relationController.text.trim().isEmpty
            ? null
            : _relationController.text.trim()
        ..notes = _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim();

      if (_isEdit) {
        await repo.updateBirthday(birthday);
      } else {
        await repo.addBirthday(birthday);
      }

      if (mounted) context.pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Birthday' : 'Add Birthday'),
      ),
      body: _notFound
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Birthday not found.'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () =>
                        context.canPop() ? context.pop() : context.go('/'),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            )
          : _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name *',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 16),
                    // Date picker wrapped in InkWell for tap affordance
                    InkWell(
                      onTap: _pickDate,
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Date of Birth *',
                          prefixIcon: Icon(Icons.cake_outlined),
                        ),
                        child: Text(
                          _selectedDate == null
                              ? 'Select date'
                              : DateFormat('MMMM d, yyyy').format(_selectedDate!),
                          style: TextStyle(
                            color: _selectedDate == null
                                ? Theme.of(context).colorScheme.outline
                                : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _relationController,
                      decoration: const InputDecoration(
                        labelText: 'Relation',
                        hintText: 'e.g. Sister, Friend, Colleague',
                        prefixIcon: Icon(Icons.people_outline),
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notes',
                        prefixIcon: Icon(Icons.note_outlined),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 28),
                    ElevatedButton(
                      onPressed: _saving ? null : _save,
                      child: _saving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(_isEdit ? 'Update Birthday' : 'Save Birthday'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
