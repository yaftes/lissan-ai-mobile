import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:lissan_ai/core/network/bloc/connectivity_bloc.dart';
import 'package:lissan_ai/features/writting_assistant/presentation/bloc/writting_bloc.dart';
import 'package:lissan_ai/features/writting_assistant/presentation/bloc/writting_event.dart';
import 'package:lissan_ai/features/writting_assistant/presentation/bloc/writting_state.dart';
import 'package:lissan_ai/features/writting_assistant/presentation/widgets/emphasis_boc.dart';

class EmailImprovePage extends StatefulWidget {
  const EmailImprovePage({super.key});

  @override
  State<EmailImprovePage> createState() => _EmailImprovePageState();
}

class _EmailImprovePageState extends State<EmailImprovePage> {
  final TextEditingController _emailController = TextEditingController();
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
            padding: const EdgeInsets.all(2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    left: 16, // horizontal (left)
                    right: 16, // horizontal (right)
                    bottom: 12,
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

                const Text(
                  'Your Email:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff112d4f),
                  ),
                ),
                const SizedBox(height: 8),

                const Text(
                  'Paste your Email here and we\'ll help improve it',
                  style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
                ),
                const SizedBox(height: 16),

                // text field
                TextField(
                  controller: _emailController,
                  maxLines: 5,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Paste your email here...',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    filled: true, // 👈 Enable background color
                    fillColor: Colors.grey[200], // 👈 Background color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.blueAccent,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xff112d4f),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // // Type selector
                // const Text(
                //   'Email Type:',
                //   style: TextStyle(
                //     fontWeight: FontWeight.bold,
                //     fontSize: 16,
                //     color: Color(0xff112d4f),
                //   ),
                // ),
                // const SizedBox(height: 6),
                // DropdownButtonFormField<String>(
                //   value: selectedType,
                //   items: types.map((type) {
                //     return DropdownMenuItem<String>(
                //       value: type,
                //       child: Text(type),
                //     );
                //   }).toList(),
                //   onChanged: (value) {
                //     if (value != null) {
                //       setState(() {
                //         selectedType = value;
                //       });
                //     }
                //   },
                //   decoration: InputDecoration(
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //     contentPadding: const EdgeInsets.symmetric(
                //       horizontal: 12,
                //       vertical: 14,
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 16),

                // Tone selector
                const Text(
                  'Tone:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xff112d4f),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: tones.map((tone) {
                    final isSelected = selectedTone == tone;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: ChoiceChip(
                          label: Center(
                            child: Text(tone),
                          ), // 👈 Center text inside
                          selected: isSelected,
                          selectedColor: const Color(0xFF6366F1),
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
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Improve button
                SizedBox(
                  width: double.infinity,
                  child: BlocBuilder<WrittingBloc, WrittingState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state is ImproveEmailLoading
                            ? null
                            : () {
                                if (_emailController.text.isNotEmpty) {
                                  context.read<WrittingBloc>().add(
                                    ImproveEmailEvent(
                                      _emailController.text,
                                      selectedTone,
                                      selectedType,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please enter your email first',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff112d4f),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: state is ImproveEmailLoading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Improve Email',
                                style: TextStyle(fontSize: 16),
                              ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Corrections section
                BlocBuilder<WrittingBloc, WrittingState>(
                  builder: (context, state) {
                    if (state is ImproveEmailLoaded &&
                        state.improvedEmail.corrections.isNotEmpty) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFE5E7EB),
                          ), // neutral-200
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 24,
                              spreadRadius: -4,
                              offset: Offset(0, 12),
                              color: Color(0x1A000000),
                            ),
                            BoxShadow(
                              blurRadius: 6,
                              spreadRadius: -2,
                              offset: Offset(0, 2),
                              color: Color(0x14000000),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Text(
                                'Suggested Improvements',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Here are some ways to make your Email better',
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(color: const Color(0xFF6B7280)),
                              ),
                              const SizedBox(height: 16),

                              // Loop corrections
                              ...state.improvedEmail.corrections.map((c) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // ORIGINAL
                                      EmphasisBlock(
                                        title: 'Original:',
                                        body: c.original,
                                        titleColor: const Color(0xFFEF4444),
                                        bgColor: const Color(0xFFFFF1F2),
                                        borderColor: const Color(0xFFFECACA),
                                      ),
                                      const SizedBox(height: 12),

                                      // IMPROVED
                                      EmphasisBlock(
                                        title: 'Improved:',
                                        body: c.corrected,
                                        titleColor: const Color(0xFF22C55E),
                                        bgColor: const Color(0xFFF0FDF4),
                                        borderColor: const Color(0xFFBBF7D0),
                                      ),
                                      const SizedBox(height: 12),

                                      // WHY
                                      EmphasisBlock(
                                        title: 'Why:',
                                        body: c.explanation,
                                        titleColor: const Color(0xFF2563EB),
                                        bgColor: const Color(0xFFEFF6FF),
                                        borderColor: const Color(0xFFBFDBFE),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),

                const SizedBox(height: 24),

                // Output section
                BlocBuilder<WrittingBloc, WrittingState>(
                  builder: (context, state) {
                    if (state is ImproveEmailLoading) {
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
                    } else if (state is ImproveEmailLoaded) {
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
                              'Improved Email',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Subject (if you want to show it)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                state
                                    .improvedEmail
                                    .subject, // or state.improvedEmail.subject if you add it
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Improved Body
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                state.improvedEmail.improvedBody,
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
                                    ClipboardData(
                                      text: state.improvedEmail.improvedBody,
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        '✅ Improved email copied to clipboard!',
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.copy),
                                label: const Text('Copy Improved Email'),
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
                const SizedBox(height: 16),
              ],
            ),
          );
        } else {
          return Image.asset('assets/images/no_internet.png');
        }
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
