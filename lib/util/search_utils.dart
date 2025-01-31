class SearchUtils {
  static Map<String, dynamic> buildQueryParams(String queryText) {
    final params = <String, dynamic>{};
    var hasKeyword = false;

    if (queryText.isEmpty) return params;

    final parts = queryText.split('|');
    for (final part in parts) {
      final keyValue = part.split(': ');
      if (keyValue.length != 2) continue;

      final key = keyValue[0].trim();
      final value = keyValue[1].trim();
      hasKeyword = true;

      switch (key) {
        case 'id':
          params['$key[eq]'] = value;
        case 'nom':
        case 'description':
          params['$key[like]'] = value;
        case 'nombreTickets':
        case 'dateDebut':
          params['$key[gt]'] = value;
      }
    }

    if (!hasKeyword) {
      params['nom[like]'] = queryText.trim();
    }

    return params;
  }

  static String formatDate(String? dateString) {
    if (dateString == null) return 'Date non définie';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year} '
          '${date.hour.toString().padLeft(2, '0')}:'
          '${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Date invalide';
    }
  }
}
