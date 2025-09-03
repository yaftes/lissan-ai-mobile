// Your main file (e.g., record_free_speech_audio.dart)

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math'; // Import for Random
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

// --- Import your new blob widget file ---
import 'animated_audio.dart';

// Enum to represent the different states of the conversation UI
enum ConversationState { idle, connected, listening, processing, speaking }

class RecordFreeSpeechAudio extends StatefulWidget {
  final String websocketUrl;

  const RecordFreeSpeechAudio({Key? key, required this.websocketUrl})
    : super(key: key);

  @override
  State<RecordFreeSpeechAudio> createState() => _RecordFreeSpeechAudioState();
}

class _RecordFreeSpeechAudioState extends State<RecordFreeSpeechAudio> {
  WebSocketChannel? _channel;
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription? _audioSubscription;
  StreamSubscription? _amplitudeSubscription; // NEW: For volume animation
  final AudioRecorder _audioRecorder = AudioRecorder();

  ConversationState _currentState = ConversationState.idle;
  String _statusText = "Tap to Speak";
  bool _isRecording = false;
  Timer? _silenceTimer;

  double _currentVolume = 0.0;
  Timer? _aiAnimationTimer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _log("--- Widget Initializing ---"); // NEW LOG
    _initializeWebSocket();
  }

  @override
  void dispose() {
    _log("--- Widget Disposing ---"); // NEW LOG
    _silenceTimer?.cancel();
    _aiAnimationTimer?.cancel();
    _audioSubscription?.cancel();
    _channel?.sink.close();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _log(String message) {
    // This will print to your Flutter debug console.
    print("[LOG] ${DateTime.now().toIso8601String()}: $message");
  }

  void _setStatus(String text, ConversationState state) {
    if (!mounted) return;
    _log("Setting status: '$text', State: $state"); // NEW LOG
    setState(() {
      _statusText = text;
      _currentState = state;
      if (state != ConversationState.listening &&
          state != ConversationState.speaking) {
        _currentVolume = 0.0;
      }
    });
  }

  Future<void> _initializeWebSocket() async {
    _log(
      "Attempting to connect to WebSocket: ${widget.websocketUrl}",
    ); // NEW LOG
    try {
      _channel = WebSocketChannel.connect(Uri.parse(widget.websocketUrl));
      _log(
        "WebSocket connection object created. Listening to stream...",
      ); // NEW LOG

      _channel!.stream.listen(
        (message) {
          if (message is String) {
            _log("✅ [WebSocket Received TEXT]: $message"); // NEW LOG
            _setStatus("Processing...", ConversationState.processing);
          } else if (message is Uint8List) {
            _log(
              "✅ [WebSocket Received AUDIO]: ${message.lengthInBytes} bytes",
            ); // NEW LOG
            _playAudio(message);
          } else {
            _log(
              "✅ [WebSocket Received UNKNOWN TYPE]: ${message.runtimeType}",
            ); // NEW LOG
          }
        },
        onDone: () {
          _log(
            "❌ [WebSocket onDone]: Connection closed by server. Code: ${_channel?.closeCode}, Reason: ${_channel?.closeReason}",
          ); // NEW LOG
          _setStatus("Disconnected. Tap to reconnect.", ConversationState.idle);
          _stopRecording();
          _channel = null; // Set channel to null to allow reconnection
        },
        onError: (error) {
          _log("❌ [WebSocket onError]: $error"); // NEW LOG
          _setStatus("Error. Tap to reconnect.", ConversationState.idle);
          _stopRecording();
          _channel = null;
        },
      );
      _setStatus("Tap to Speak", ConversationState.connected);
      _log("✅ WebSocket stream listener is active."); // NEW LOG
    } catch (e) {
      _log("❌ [WebSocket EXCEPTION]: Failed to connect: $e"); // NEW LOG
      _setStatus("Connection Error", ConversationState.idle);
    }
  }

  Future<void> _playAudio(Uint8List audioBytes) async {
    _setStatus("AI Speaking...", ConversationState.speaking);

    // Start fake animation for AI speaking
    _aiAnimationTimer?.cancel();
    _aiAnimationTimer = Timer.periodic(const Duration(milliseconds: 100), (
      timer,
    ) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _currentVolume = 0.2 + _random.nextDouble() * 0.3;
      });
    });

    try {
      // --- THIS IS THE FIX ---
      // Instead of writing to a file, we set the audio source directly from the byte array.
      // This avoids the Android Cleartext HTTP error.
      await _audioPlayer.setAudioSource(BytesAudioSource(audioBytes));
      _audioPlayer.play();
      _log("Playing AI audio from memory...");

      _audioPlayer.playerStateStream.listen((playerState) {
        if (playerState.processingState == ProcessingState.completed) {
          _log("AI finished speaking. Ready for next turn.");
          _aiAnimationTimer?.cancel();
          // Reset the player so it doesn't replay the old audio on the next run
          _audioPlayer.stop();
          _setStatus("Tap to Speak", ConversationState.connected);
        }
      });
    } catch (e) {
      _log("Error playing audio: $e");
      _aiAnimationTimer?.cancel();
      _setStatus("Audio Error", ConversationState.connected);
    }
  }

  Future<void> _startRecording() async {
    _log("Attempting to start recording...");
    if (_isRecording) {
      _log("...already recording. Aborting.");
      return;
    }
    if (_channel == null || _channel!.sink == null) {
      _log("...channel is null. Attempting to reconnect before recording.");
      await _initializeWebSocket();
      if (_channel == null) {
        _log("...reconnection failed. Aborting recording.");
        return;
      }
    }

    _log("...checking microphone permission.");
    if (await Permission.microphone.request().isDenied) {
      _log("...permission denied. Aborting.");
      return;
    }

    try {
      if (await _audioRecorder.hasPermission()) {
        _log("...permission granted. Starting stream from recorder.");
        _isRecording = true;
        _setStatus("Listening...", ConversationState.listening);

        // --- THE MAIN FIX IS HERE ---
        // Change the encoder from pcm16bits to a standard format like aacLc.
        final audioStream = await _audioRecorder.startStream(
          const RecordConfig(
            encoder: AudioEncoder.aacLc, // CHANGED FROM pcm16bits
            sampleRate: 16000,
            numChannels: 1,
            bitRate: 48000, // A reasonable bitrate for AAC
          ),
        );

        // --- NEW: Use the built-in amplitude stream for visualization ---
        _amplitudeSubscription = _audioRecorder
            .onAmplitudeChanged(const Duration(milliseconds: 100))
            .listen((amp) {
              // The amplitude is in dBFS (decibels relative to full scale).
              // It's typically negative, from -160 (silence) to 0 (max).
              // We'll convert it to a 0.0 to 1.0 scale for the blob.
              final minDb = -60.0; // A reasonable silence threshold
              final maxDb = 0.0;
              // Clamp the value and normalize it
              final normalized =
                  (amp.current.clamp(minDb, maxDb) - minDb) / (maxDb - minDb);
              if (mounted) {
                setState(() {
                  _currentVolume = normalized;
                });
              }
            });

        _audioSubscription = audioStream.listen(
          (audioChunk) {
            if (_channel?.sink != null && _isRecording) {
              _log(
                "🎤 -> 🚀 Sending audio chunk: ${audioChunk.lengthInBytes} bytes (AAC)",
              );
              _channel!.sink.add(audioChunk);

              // We no longer calculate RMS here.
              _resetSilenceTimer();
            }
          },
          onError: (err) {
            _log("❌ Audio stream error: $err");
            _stopRecording();
          },
          onDone: () {
            _log("Audio stream finished.");
          },
        );
        _startSilenceTimer();
      }
    } catch (e) {
      _log("❌ Error starting recording: $e");
      _setStatus("Recording Error", ConversationState.connected);
      _isRecording = false;
    }
  }

  void _stopRecording() {
    _log("Attempting to stop recording...");
    if (!_isRecording) {
      _log("...not recording. Aborting.");
      return;
    }
    _isRecording = false;
    _audioRecorder.stop();
    _audioSubscription?.cancel();
    _silenceTimer?.cancel();
    _amplitudeSubscription?.cancel(); // NEW: Cancel the amplitude listener
    _silenceTimer = null;
    _setStatus("Tap to Speak", ConversationState.connected);
    _log("✅ Stopped listening.");
  }

  void _sendEndOfSpeechSignal() {
    _log(
      "🤫 Silence/Manual stop detected. Sending 'end_of_speech'.",
    ); // NEW LOG
    if (_channel?.sink != null) {
      _channel!.sink.add(jsonEncode({'type': 'end_of_speech'}));
      _log("...signal sent."); // NEW LOG
    } else {
      _log("...could not send signal, channel is null."); // NEW LOG
    }
    _stopRecording();
  }

  void _startSilenceTimer() {
    _silenceTimer?.cancel();
    _log("🤫 Starting 1.5s silence timer..."); // NEW LOG
    _silenceTimer = Timer(const Duration(milliseconds: 1500), () {
      if (_isRecording) {
        _sendEndOfSpeechSignal();
      }
    });
  }

  void _resetSilenceTimer() {
    if (_isRecording) {
      _silenceTimer?.cancel();
      _startSilenceTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 32),
        Text(
          _statusText,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 64),

        // --- REPLACEMENT WIDGET ---
        AnimatedAudioBlob(
          state: _currentState,
          volume: _currentVolume,
          onTap: () {
            if (_currentState == ConversationState.connected ||
                _currentState == ConversationState.idle) {
              if (_channel == null) {
                _initializeWebSocket(); // Attempt to reconnect if disconnected
              }
              _startRecording();
            } else if (_currentState == ConversationState.listening) {
              _sendEndOfSpeechSignal(); // Manual stop
            }
          },
        ),

        // --- END REPLACEMENT ---
        const SizedBox(height: 20),
        // This button is now redundant as tapping the blob stops the recording.
        // You can keep it if you want an explicit stop button.
        // if (_isRecording)
        //   ElevatedButton(
        //     onPressed: _sendEndOfSpeechSignal,
        //     style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
        //     child: const Text('Stop', style: TextStyle(color: Colors.white)),
        //   ),
      ],
    );
  }
}

// A simple AudioSource to play bytes with just_audio
class BytesAudioSource extends StreamAudioSource {
  final Uint8List _buffer;

  BytesAudioSource(this._buffer) : super(tag: 'BytesAudioSource');

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    final startVal = start ?? 0;
    final endVal = end ?? _buffer.length;
    return StreamAudioResponse(
      sourceLength: _buffer.length,
      contentLength: endVal - startVal,
      offset: startVal,
      stream: Stream.value(_buffer.sublist(startVal, endVal)),
      // The content type your server sends. 'audio/mpeg' for MP3, 'audio/aac' for AAC, etc.
      contentType: 'audio/mpeg',
    );
  }
}
