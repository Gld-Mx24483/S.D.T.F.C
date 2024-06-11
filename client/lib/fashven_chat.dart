// fashven_chat.dart
// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ven_proof_dets.dart';

class FashvenChat extends StatefulWidget {
  final String selectedLocationName;
  final String selectedLocationAddress = '123 Main Street, Anytown, CA 12345';
  final String phoneNumber;

  const FashvenChat({
    super.key,
    required this.selectedLocationName,
    required this.phoneNumber,
  });

  @override
  State<FashvenChat> createState() => _FashvenChatState();
}

class _FashvenChatState extends State<FashvenChat> {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = [];
  final Random _random = Random();

  final List<String> _aiResponses = [
    "That sounds great! When should we meet?",
    "I'm not sure about that. Can you provide more details?",
    "Absolutely! I'll take care of it right away.",
    "I'm sorry to hear that. Is there anything I can do to help?",
    "Thanks for letting me know. I'll keep you updated.",
    "That's an interesting idea. Let's discuss it further.",
    "I'm excited about this project! When do we start?",
    "I understand your concerns. Let's find a solution together.",
    "Great job! Your hard work is really paying off.",
    "I'll look into that and get back to you soon.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VendorProfileDetails(
                  selectedLocationName: widget.selectedLocationName,
                  address: widget.selectedLocationAddress,
                  phoneNumber: widget.phoneNumber,
                ),
              ),
            );
          },
          child: Container(
            color: Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 40.0, left: 10.0, right: 10.0),
              child: Card(
                color: Colors.white,
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                          size: 24,
                        ),
                        padding: const EdgeInsets.only(left: 4.42),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.selectedLocationName,
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF111827),
                            ),
                          ),
                          Text(
                            widget.selectedLocationAddress,
                            style: GoogleFonts.nunito(
                              fontSize: 11,
                              fontWeight: FontWeight.w300,
                              color: const Color(0xFFA6A6A6),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: IconButton(
                          onPressed: () {
                            _makePhoneCall(widget.phoneNumber);
                          },
                          icon: const Icon(
                            Icons.call_outlined,
                            color: Color(0xFF621B2B),
                            size: 21,
                          ),
                          padding: const EdgeInsets.all(1.75),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Text(
                      'No Messages',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFA6A6A6),
                      ),
                    ),
                  )
                : ListView.builder(
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[_messages.length - 1 - index];
                      if (message.isDateSeparator) {
                        return DateSeparatorBubble(date: message.timestamp);
                      } else if (message.imageFile != null) {
                        return Align(
                          alignment: message.isSender
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: ImageBubble(message: message),
                        );
                      } else {
                        return Align(
                          alignment: message.isSender
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: MessageBubble(message: message),
                        );
                      }
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 120,
                        ),
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: GoogleFonts.nunito(
                              color: Colors.grey.shade400,
                              fontSize: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 12.0,
                            ),
                          ),
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          cursorColor: const Color(0xFF621B2B),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    ImageUploader(onImageSelected: (imageFile) {
                      setState(() {
                        _messages.add(Message(
                          text: '',
                          isSender: true,
                          imageFile: imageFile,
                        ));
                      });
                    }),
                    const SizedBox(width: 8.0),
                    IconButton(
                      onPressed: _sendMessage,
                      icon: const Icon(
                        Icons.send,
                        color: Color(0xFF621B2B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      final now = DateTime.now();
      if (_messages.isEmpty || !_isSameDay(_messages.last.timestamp, now)) {
        _messages.add(Message.dateSeparator(now));
      }
      setState(() {
        _messages.add(Message(text: text, isSender: true));
        _messageController.clear();
      });

      Future.delayed(Duration(seconds: 1 + _random.nextInt(2)), () {
        final aiResponse = _aiResponses[_random.nextInt(_aiResponses.length)];
        setState(() {
          _messages.add(Message(text: aiResponse, isSender: false));
        });
      });
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      print('Could not launch $launchUri');
    }
  }
}

class Message {
  final String text;
  final bool isSender;
  final DateTime timestamp;
  final bool isDateSeparator;
  final File? imageFile;

  Message({
    required this.text,
    required this.isSender,
    DateTime? timestamp,
    this.imageFile,
  })  : timestamp = timestamp ?? DateTime.now(),
        isDateSeparator = false;

  Message.dateSeparator(this.timestamp)
      : text = '',
        isSender = false,
        isDateSeparator = true,
        imageFile = null;
}

class MessageBubble extends StatelessWidget {
  final Message message;
  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: message.isSender
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 235),
            decoration: BoxDecoration(
              color: message.isSender ? const Color(0xFFDCF7C5) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                if (!message.isSender)
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                message.text,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, right: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (message.isSender) ...[
                  const Icon(Icons.done_all,
                      size: 16, color: Color(0xFF34B7F1)),
                  const SizedBox(width: 4),
                ],
                Text(
                  DateFormat('h:mm a').format(message.timestamp),
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ImageBubble extends StatelessWidget {
  final Message message;
  const ImageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: message.isSender
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenImageView(
                    imageFile: message.imageFile!,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  if (!message.isSender)
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  message.imageFile!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, right: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (message.isSender) ...[
                  const Icon(Icons.done_all,
                      size: 16, color: Color(0xFF34B7F1)),
                  const SizedBox(width: 4),
                ],
                Text(
                  DateFormat('h:mm a').format(message.timestamp),
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenImageView extends StatelessWidget {
  final File imageFile;

  const FullScreenImageView({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          maxScale: 4,
          child: Image.file(imageFile),
        ),
      ),
    );
  }
}

class DateSeparatorBubble extends StatelessWidget {
  final DateTime date;
  const DateSeparatorBubble({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Container(
          width: 100,
          height: 21,
          decoration: BoxDecoration(
            color: const Color(0xFFDDDDE9),
            borderRadius: BorderRadius.circular(10.5),
          ),
          child: Center(
            child: Text(
              DateFormat('EEE, MMM d').format(date),
              style: GoogleFonts.nunito(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF111827),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ImageUploader extends StatefulWidget {
  final Function(File imageFile) onImageSelected;

  const ImageUploader({super.key, required this.onImageSelected});

  @override
  State<ImageUploader> createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final pickedFile =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _imageFile = File(pickedFile.path);
          });
          widget.onImageSelected(_imageFile!);
        }
      },
      icon: _imageFile == null
          ? const Icon(Icons.attach_file, color: Colors.grey)
          : const Icon(Icons.attach_file, color: Colors.grey),
    );
  }
}
