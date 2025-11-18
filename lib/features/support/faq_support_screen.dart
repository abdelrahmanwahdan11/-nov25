import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/skeleton.dart';
import '../../data/models/support_faq.dart';
import 'faq_controller.dart';

class FaqSupportScreen extends StatefulWidget {
  final FaqController controller;
  const FaqSupportScreen({super.key, required this.controller});

  @override
  State<FaqSupportScreen> createState() => _FaqSupportScreenState();
}

class _FaqSupportScreenState extends State<FaqSupportScreen> {
  late final TextEditingController _searchCtrl;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(
        title: Text(t('help_center')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: widget.controller.load,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: t('search_help'),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
              onChanged: widget.controller.search,
            ),
          ),
          Expanded(
            child: StreamBuilder<List<SupportFaq>>(
              stream: widget.controller.faqStream,
              builder: (context, snapshot) {
                if (widget.controller.isLoading) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 4,
                    itemBuilder: (_, __) => const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Skeleton(height: 90, width: double.infinity),
                    ),
                  );
                }
                final faqs = snapshot.data ?? [];
                if (faqs.isEmpty) return Center(child: Text(t('empty_faq')));
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: faqs.length,
                  itemBuilder: (_, i) => _FaqTile(faq: faqs[i]),
                );
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: () => _showSupportDialog(context, t),
          icon: const Icon(Icons.chat_bubble_outline),
          label: Text(t('contact_support')),
        ),
      ),
    );
  }

  void _showSupportDialog(BuildContext context, String Function(String) t) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t('contact_support')),
        content: Text(t('contact_support_body')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(t('close'))),
        ],
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  final SupportFaq faq;
  const _FaqTile({required this.faq});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(faq.category),
              ),
              const Spacer(),
              const Icon(Icons.keyboard_arrow_down_rounded)
            ],
          ),
          const SizedBox(height: 8),
          Text(faq.question, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(faq.answer),
        ],
      ),
    ).animate().fadeIn().slide(begin: const Offset(0, 0.08));
  }
}
