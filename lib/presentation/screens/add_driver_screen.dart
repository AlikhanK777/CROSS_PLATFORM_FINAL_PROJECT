import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/drivers/drivers_bloc.dart';
import '../../data/models/custom_driver_model.dart';
import '../../data/repositories/f1_repository.dart';
import '../../core/theme/app_theme.dart';

class AddDriverScreen extends StatefulWidget {
  final CustomDriver? driver;
  const AddDriverScreen({super.key, this.driver});

  @override
  State<AddDriverScreen> createState() => _AddDriverScreenState();
}

class _AddDriverScreenState extends State<AddDriverScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _teamCtrl;
  late final TextEditingController _nationalityCtrl;
  late final TextEditingController _numberCtrl;
  late final TextEditingController _bioCtrl;
  late final TextEditingController _winsCtrl;
  late final TextEditingController _podiumsCtrl;
  late final TextEditingController _polesCtrl;
  late final TextEditingController _pointsCtrl;

  bool get isEditing => widget.driver != null;

  @override
  void initState() {
    super.initState();
    final d = widget.driver;
    _nameCtrl = TextEditingController(text: d?.name ?? '');
    _teamCtrl = TextEditingController(text: d?.team ?? '');
    _nationalityCtrl = TextEditingController(text: d?.nationality ?? '');
    _numberCtrl = TextEditingController(text: d != null ? '${d.number}' : '');
    _bioCtrl = TextEditingController(text: d?.bio ?? '');
    _winsCtrl = TextEditingController(text: d != null ? '${d.wins}' : '0');
    _podiumsCtrl =
        TextEditingController(text: d != null ? '${d.podiums}' : '0');
    _polesCtrl = TextEditingController(text: d != null ? '${d.poles}' : '0');
    _pointsCtrl =
        TextEditingController(text: d != null ? '${d.points.toInt()}' : '0');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _teamCtrl.dispose();
    _nationalityCtrl.dispose();
    _numberCtrl.dispose();
    _bioCtrl.dispose();
    _winsCtrl.dispose();
    _podiumsCtrl.dispose();
    _polesCtrl.dispose();
    _pointsCtrl.dispose();
    super.dispose();
  }

  void _save(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final driver = CustomDriver(
      id: widget.driver?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameCtrl.text.trim(),
      team: _teamCtrl.text.trim(),
      nationality: _nationalityCtrl.text.trim(),
      number: int.tryParse(_numberCtrl.text) ?? 0,
      bio: _bioCtrl.text.trim().isEmpty ? null : _bioCtrl.text.trim(),
      wins: int.tryParse(_winsCtrl.text) ?? 0,
      podiums: int.tryParse(_podiumsCtrl.text) ?? 0,
      poles: int.tryParse(_polesCtrl.text) ?? 0,
      points: double.tryParse(_pointsCtrl.text) ?? 0,
    );

    final bloc = DriversBloc(repository: F1Repository());
    if (isEditing) {
      bloc.add(UpdateDriver(driver));
    } else {
      bloc.add(AddDriver(driver));
    }

    // Direct repository call since we're outside the BLoC scope
    final repo = F1Repository();
    if (isEditing) {
      repo.updateCustomDriver(driver);
    } else {
      repo.addCustomDriver(driver);
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Driver' : 'Add Driver'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: () => _save(context),
            child: const Text('SAVE',
                style: TextStyle(
                    color: AppTheme.f1Red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SectionHeader(label: 'BASIC INFO'),
            _Field(
                ctrl: _nameCtrl,
                label: 'Full Name',
                icon: Icons.person,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Name is required' : null),
            const SizedBox(height: 12),
            _Field(
                ctrl: _teamCtrl,
                label: 'Team',
                icon: Icons.groups,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Team is required' : null),
            const SizedBox(height: 12),
            _Field(
                ctrl: _nationalityCtrl,
                label: 'Nationality',
                icon: Icons.flag,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Nationality is required' : null),
            const SizedBox(height: 12),
            _Field(
              ctrl: _numberCtrl,
              label: 'Car Number',
              icon: Icons.pin,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) =>
                  v == null || v.isEmpty ? 'Number is required' : null,
            ),
            const SizedBox(height: 12),
            _Field(ctrl: _bioCtrl, label: 'Bio (optional)', icon: Icons.info_outline, maxLines: 3),
            const SizedBox(height: 20),
            _SectionHeader(label: 'STATISTICS'),
            Row(
              children: [
                Expanded(
                    child: _Field(
                        ctrl: _winsCtrl,
                        label: 'Wins',
                        icon: Icons.emoji_events,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly])),
                const SizedBox(width: 12),
                Expanded(
                    child: _Field(
                        ctrl: _podiumsCtrl,
                        label: 'Podiums',
                        icon: Icons.star,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly])),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: _Field(
                        ctrl: _polesCtrl,
                        label: 'Poles',
                        icon: Icons.speed,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly])),
                const SizedBox(width: 12),
                Expanded(
                    child: _Field(
                        ctrl: _pointsCtrl,
                        label: 'Points',
                        icon: Icons.score,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly])),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _save(context),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50)),
              child: Text(isEditing ? 'Update Driver' : 'Add Driver',
                  style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(label,
          style: const TextStyle(
              color: AppTheme.f1Red,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              fontSize: 12)),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;

  const _Field({
    required this.ctrl,
    required this.label,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctrl,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      style: const TextStyle(color: AppTheme.f1White),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey, size: 20),
      ),
    );
  }
}
