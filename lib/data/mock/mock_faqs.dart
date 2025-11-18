import '../models/support_faq.dart';

final mockFaqs = [
  SupportFaq(
    id: 'faq1',
    question: 'How often should I vaccinate my dog?',
    answer: 'Core vaccines are yearly after puppy boosters. Ask your vet for local guidance.',
    category: 'Health',
  ),
  SupportFaq(
    id: 'faq2',
    question: 'What is the best way to introduce a new pet?',
    answer: 'Use slow, supervised introductions with scent swapping and short sessions.',
    category: 'Behavior',
  ),
  SupportFaq(
    id: 'faq3',
    question: 'Can I adopt if I live in an apartment?',
    answer: 'Yes, choose breeds that suit small spaces and commit to daily walks.',
    category: 'Adoption',
  ),
  SupportFaq(
    id: 'faq4',
    question: 'How do reminders work offline?',
    answer: 'They are saved locally. No external backend is needed to stay organized.',
    category: 'App',
  ),
];
