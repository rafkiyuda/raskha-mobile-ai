import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../widgets/raksha_card.dart';
import '../widgets/crisis_accordion_card.dart';
import '../services/gemini_service.dart';

class ChatScreen extends StatefulWidget {
  final String? initialMessage;
  final Map<String, dynamic>? stockContext;
  final VoidCallback? onMessageConsumed;
  const ChatScreen({super.key, this.initialMessage, this.stockContext, this.onMessageConsumed});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final List<Map<String, dynamic>> _messages;
  Map<String, dynamic>? _activeStockContext;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GeminiService _gemini = GeminiService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _activeStockContext = widget.stockContext;
    
    final greeting = _activeStockContext != null 
      ? 'Halo! Saya RAKSHA AI, Co-Pilot finansialmu. Mari kita amankan portofoliomu. Ada detail terkait ${_activeStockContext!['symbol']} yang ingin dibahas?'
      : 'Halo Sherine! Saya Raksha AI Co-Pilot. Ada yang bisa saya bantu terkait risiko investasi Anda hari ini?';

    _messages = [
      {'role': 'ai', 'type': 'text', 'text': greeting},
    ];

    if (widget.initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sendInitialContext(widget.initialMessage ?? '');
        widget.onMessageConsumed?.call();
      });
    }
  }

  @override
  void didUpdateWidget(ChatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.stockContext != oldWidget.stockContext) {
      setState(() {
        _activeStockContext = widget.stockContext;
        if (_activeStockContext != null) {
          _messages.add({
            'role': 'ai', 
            'type': 'text', 
            'text': 'Konteks diperbarui: ${_activeStockContext!['symbol']}. Apa yang ingin Anda ketahui lebih lanjut?'
          });
        }
      });
      _scrollToBottom();
    }
    if (widget.initialMessage != null && widget.initialMessage != oldWidget.initialMessage) {
      _sendInitialContext(widget.initialMessage ?? '');
      widget.onMessageConsumed?.call();
    }
  }

  void _sendInitialContext(String text) async {
    setState(() {
      _messages.add({'role': 'user', 'type': 'text', 'text': text});
      _isLoading = true;
    });
    _scrollToBottom();

    final response = await _gemini.sendMessage(text);

    if (mounted) {
      setState(() {
        if (text.toLowerCase().contains('crisis') || text.toLowerCase().contains('goto')) {
          _messages.add({
            'role': 'ai',
            'type': 'accordion',
            'data': {
              'symbol': 'GOTO',
              'name': 'GoTo Gojek Tokopedia',
              'priceChange': 12.5,
              'tags': ['Extreme FOMO', 'Finfluencer'],
              'alertText': 'Extreme social media hype detected. 85% of mentions are from 3 finfluencer accounts. Low correlation with fundamentals.',
              'stats': {'Mentions': '12.4K', 'Herding': '88%', 'Fundamental': '32'},
              'socialHype': 85.0,
              'sourceDistribution': {'Twitter': 65.0, 'TikTok': 25.0, 'Stockbit': 10.0},
            }
          });
        } else {
          _messages.add({'role': 'ai', 'type': 'text', 'text': response});
        }
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _sendMessage() async {
    final text = _controller.text;
    if (text.isEmpty || _isLoading) return;

    final String contextSuffix = _activeStockContext != null 
        ? ' [Context: ${_activeStockContext!['symbol']} (Score: ${_activeStockContext!['score']})]' 
        : '';

    setState(() {
      _messages.add({'role': 'user', 'type': 'text', 'text': text});
      _isLoading = true;
      _controller.clear();
    });
    _scrollToBottom();

    final response = await _gemini.sendMessage(text + contextSuffix);

    if (mounted) {
      setState(() {
        if (text.toLowerCase().contains('crisis') || text.toLowerCase().contains('goto')) {
          _messages.add({
            'role': 'ai',
            'type': 'accordion',
            'data': {
              'symbol': 'GOTO',
              'name': 'GoTo Gojek Tokopedia',
              'priceChange': 12.5,
              'tags': ['Extreme FOMO', 'Finfluencer'],
              'alertText': 'Extreme social media hype detected. 85% of mentions are from 3 finfluencer accounts. Low correlation with fundamentals.',
              'stats': {'Mentions': '12.4K', 'Herding': '88%', 'Fundamental': '32'},
              'socialHype': 85.0,
              'sourceDistribution': {'Twitter': 65.0, 'TikTok': 25.0, 'Stockbit': 10.0},
            }
          });
        } else {
          _messages.add({'role': 'ai', 'type': 'text', 'text': response});
        }
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(20),
            itemCount: _messages.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _messages.length) {
                return _buildLoadingBubble();
              }
              final msg = _messages[index];
              final isAi = msg['role'] == 'ai';
              final isAccordion = msg['type'] == 'accordion';

              if (isAccordion) {
                final data = msg['data'] as Map<String, dynamic>;
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
                    child: CrisisAccordionCard(
                      symbol: data['symbol'],
                      name: data['name'],
                      priceChange: data['priceChange'],
                      tags: List<String>.from(data['tags']),
                      alertText: data['alertText'],
                      stats: Map<String, String>.from(data['stats']),
                      socialHype: data['socialHype'],
                      sourceDistribution: Map<String, double>.from(data['sourceDistribution']),
                    ),
                  ),
                );
              }

              return Align(
                alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                  decoration: BoxDecoration(
                    color: isAi ? RakshaColors.cardWhite : RakshaColors.primary,
                    borderRadius: BorderRadius.circular(16).copyWith(
                      bottomLeft: isAi ? const Radius.circular(0) : const Radius.circular(16),
                      bottomRight: isAi ? const Radius.circular(16) : const Radius.circular(0),
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Text(
                    msg['text'] ?? '',
                    style: TextStyle(color: isAi ? RakshaColors.textDark : Colors.white, fontSize: 14),
                  ),
                ),
              );
            },
          ),
        ),
        _buildInput(),
      ],
    );
  }

  Widget _buildLoadingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: RakshaColors.cardWhite,
          borderRadius: BorderRadius.circular(16).copyWith(bottomLeft: const Radius.circular(0)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: RakshaColors.primary),
        ),
      ),
    );
  }

  Widget _buildInput() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_activeStockContext != null) _buildContextAttachment(),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.black12))),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    hintText: _activeStockContext != null ? 'Tanya detail emiten ini...' : 'Tanyakan sesuatu...',
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              IconButton(
                onPressed: _isLoading ? null : _sendMessage,
                icon: Icon(Icons.send, color: _isLoading ? Colors.grey : RakshaColors.primary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContextAttachment() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: RakshaColors.bgSlate,
        border: Border(top: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Text(
              '${_activeStockContext!['score']}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: RakshaColors.primary),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Akan dianalisis: ${_activeStockContext!['symbol']}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: RakshaColors.textDark),
                ),
                const Text(
                  'Lampiran ini akan dikirim bersama pesanmu',
                  style: TextStyle(fontSize: 10, color: RakshaColors.textGray),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _activeStockContext = null),
            icon: const Icon(Icons.close, size: 16, color: RakshaColors.textGray),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
