import 'package:diamond_test/screens/result_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/diamond_bloc/diamond_bloc.dart';
import '../blocs/diamond_bloc/diamond_event.dart';
import '../data/diamond_data.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final _formKey = GlobalKey<FormState>();

  // Filter values
  double? _caratFrom;
  double? _caratTo;
  String? _selectedLab;
  String? _selectedShape;
  String? _selectedColor;
  String? _selectedClarity;

  final double _minCarat = DiamondFilters.minCarat;
  final double _maxCarat = DiamondFilters.maxCarat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diamond Filter')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Filter Diamonds',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // Carat Range
              Text(
                'Carat Range (${_minCarat.toStringAsFixed(2)} - ${_maxCarat.toStringAsFixed(2)})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'From',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            _caratFrom = double.tryParse(value);
                          });
                        } else {
                          setState(() {
                            _caratFrom = null;
                          });
                        }
                      },
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final number = double.tryParse(value);
                          if (number == null) {
                            return 'Enter a valid number';
                          }
                          if (number < _minCarat) {
                            return 'Min is ${_minCarat.toStringAsFixed(2)}';
                          }
                          if (_caratTo != null && number > _caratTo!) {
                            return 'Must be less than To';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'To',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            _caratTo = double.tryParse(value);
                          });
                        } else {
                          setState(() {
                            _caratTo = null;
                          });
                        }
                      },
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final number = double.tryParse(value);
                          if (number == null) {
                            return 'Enter a valid number';
                          }
                          if (number > _maxCarat) {
                            return 'Max is ${_maxCarat.toStringAsFixed(2)}';
                          }
                          if (_caratFrom != null && number < _caratFrom!) {
                            return 'Must be greater than From';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Lab Dropdown
              Text(
                'Lab',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Select Lab',
                ),
                value: _selectedLab,
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('Any'),
                  ),
                  ...DiamondFilters.labs.map((lab) {
                    return DropdownMenuItem<String>(
                      value: lab,
                      child: Text(lab),
                    );
                  }).toList(),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedLab = value;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Shape Dropdown
              Text(
                'Shape',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Select Shape',
                ),
                value: _selectedShape,
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('Any'),
                  ),
                  ...DiamondFilters.shapes.map((shape) {
                    return DropdownMenuItem<String>(
                      value: shape,
                      child: Text(shape),
                    );
                  }).toList(),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedShape = value;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Color Dropdown
              Text(
                'Color',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Select Color',
                ),
                value: _selectedColor,
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('Any'),
                  ),
                  ...DiamondFilters.colors.map((color) {
                    return DropdownMenuItem<String>(
                      value: color,
                      child: Text(color),
                    );
                  }).toList(),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedColor = value;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Clarity Dropdown
              Text(
                'Clarity',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Select Clarity',
                ),
                value: _selectedClarity,
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('Any'),
                  ),
                  ...DiamondFilters.clarities.map((clarity) {
                    return DropdownMenuItem<String>(
                      value: clarity,
                      child: Text(clarity),
                    );
                  }).toList(),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedClarity = value;
                  });
                },
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Apply filters using BLoC
                    context.read<DiamondBloc>().add(
                      FilterDiamonds(
                        caratFrom: _caratFrom,
                        caratTo: _caratTo,
                        lab: _selectedLab,
                        shape: _selectedShape,
                        color: _selectedColor,
                        clarity: _selectedClarity,
                      ),
                    );

                    // Navigate to results page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResultPage(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Search', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
