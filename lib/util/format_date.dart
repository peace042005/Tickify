String formatDate(String? dateString) {
  if (dateString == null) return 'Date non définie';
  try {
    final date = DateTime.parse(dateString);
    const monthAbbreviations = [
      'Janv.',
      'Févr.',
      'Mars',
      'Avr.',
      'Mai',
      'Juin',
      'Juil.',
      'Août',
      'Sept.',
      'Oct.',
      'Nov.',
      'Déc.'
    ];
    return '${date.day.toString().padLeft(2, '0')} ${monthAbbreviations[date.month - 1]} ${date.year} à '
        '${date.hour.toString().padLeft(2, '0')}h'
        '${date.minute.toString().padLeft(2, '0')}';
  } catch (e) {
    return 'Date invalide';
  }
}
