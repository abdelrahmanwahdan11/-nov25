import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/skeleton.dart';
import '../../data/models/adoption_request.dart';
import 'adoption_controller.dart';

class AdoptionRequestsScreen extends StatefulWidget {
  final AdoptionController controller;
  const AdoptionRequestsScreen({super.key, required this.controller});

  @override
  State<AdoptionRequestsScreen> createState() => _AdoptionRequestsScreenState();
}

class _AdoptionRequestsScreenState extends State<AdoptionRequestsScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.load();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(title: Text(t('adoption_requests'))),
      body: RefreshIndicator(
        onRefresh: widget.controller.load,
        child: StreamBuilder<List<AdoptionRequest>>(
          stream: widget.controller.requestsStream,
          builder: (context, snapshot) {
            if (widget.controller.isLoading) {
              return ListView.builder(
                itemCount: 4,
                padding: const EdgeInsets.all(16),
                itemBuilder: (_, __) => const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Skeleton(height: 120, width: double.infinity),
                ),
              );
            }
            final requests = snapshot.data ?? [];
            if (requests.isEmpty) {
              return Center(child: Text(t('empty_requests')));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: requests.length,
              itemBuilder: (_, i) {
                final request = requests[i];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(request.petName, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                            const Spacer(),
                            Chip(
                              label: Text(t(request.status)),
                              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.15),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(request.note.isEmpty ? t('no_note') : request.note),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text('${t('submitted_on')} ${request.submittedAt.toLocal().toString().split(' ').first}', style: Theme.of(context).textTheme.bodySmall),
                            const Spacer(),
                            IconButton(
                              onPressed: () => setState(() => widget.controller.updateStatus(request, 'reviewed')),
                              icon: const Icon(Icons.visibility_outlined),
                              tooltip: t('mark_reviewed'),
                            ),
                            IconButton(
                              onPressed: () => setState(() => widget.controller.removeRequest(request)),
                              icon: const Icon(Icons.delete_outline),
                              tooltip: t('remove'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
