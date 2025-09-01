import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/services.dart';
import 'package:lissan_ai/core/network/bloc/connectivity_bloc.dart';
import 'package:lissan_ai/features/writting_assistant/presentation/bloc/writting_bloc.dart';
import 'package:lissan_ai/features/writting_assistant/presentation/bloc/writting_event.dart';
import 'package:lissan_ai/features/writting_assistant/presentation/bloc/writting_state.dart'; // For Clipboard

class EmailDraftPage extends StatefulWidget {
  const EmailDraftPage({super.key});

  @override
  State<EmailDraftPage> createState() => _EmailDraftPageState();
}

class _EmailDraftPageState extends State<EmailDraftPage> {
  final TextEditingController _textController = TextEditingController();
  String selectedTone = 'Formal';
  final tones = const ['Formal', 'Polite', 'Friendly'];
  String selectedType = 'Job Application';
  final types = const [
    'Job Application',
    'Application Follow-up',
    'Meeting Request',
    'Thank You Email',
    'General Inquiry',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (context, state) {
        if (state is ConnectivityConnected) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F9FF), // light blue background
                    borderRadius: BorderRadius.circular(12), // rounded edges
                    border: Border.all(
                      color: const Color(0xFFB2EBF2), // subtle border
                    ),
                  ),
                  child: const Text(
                    'Great work! Your email looks professional and polite. Ready to send?',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Input Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Describe your email in Amharic',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff112d4f), // Indigo
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _textController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Type your request in Amharic here...',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF3F51B5),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Type selector (Dropdown)
                      const Text(
                        'Email Type',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff112d4f),
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: selectedType,
                        items: types.map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedType = value;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF009688),
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Tone Chips
                      const Text(
                        'Tone',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff112d4f),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: tones.map((tone) {
                          final isSelected = selectedTone == tone;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: ChoiceChip(
                              label: Text(tone),
                              selected: isSelected,
                              selectedColor: Colors.blue, // teal
                              backgroundColor: Colors.grey[200],
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              onSelected: (_) {
                                setState(() {
                                  selectedTone = tone;
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20),

                      // Generate button
                      SizedBox(
                        width: double.infinity,
                        child: BlocBuilder<WrittingBloc, WrittingState>(
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: state is EmailDraftLoading
                                  ? null
                                  : () {
                                      if (_textController.text.isNotEmpty) {
                                        context.read<WrittingBloc>().add(
                                          GenerateEmailDraft(
                                            _textController.text,
                                            selectedTone,
                                            selectedType,
                                          ),
                                        );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                  0xff112d4f,
                                ), // Indigo
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child: state is EmailDraftLoading
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      '✨ Generate Email',
                                      style: TextStyle(fontSize: 16),
                                    ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Output section
                BlocBuilder<WrittingBloc, WrittingState>(
                  builder: (context, state) {
                    if (state is WrittingInitial) {
                      return const SizedBox();
                    } else if (state is EmailDraftError) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (state is EmailDraftLoaded) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Generated Email',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Subject
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                state.emailDraft.subject,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Body
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                state.emailDraft.body,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Copy button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(text: state.emailDraft.body),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        '✅ Email copied to clipboard!',
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.copy),
                                label: const Text('Copy Email'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(
                                    0xFF009688,
                                  ), // teal
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          );
        } else {
          return Image.asset('assets/images/no_internet.png');
        }
      },
    );
  }
}
