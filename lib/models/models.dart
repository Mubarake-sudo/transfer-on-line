class Transaction {
  final String id;
  final String operator;
  final String service;
  final String operation;
  final String phone;
  final int amount;
  final String paymentMethod;
  final DateTime date;
  final String status; // 'ok' | 'fail' | 'pending'

  Transaction({
    required this.id,
    required this.operator,
    required this.service,
    required this.operation,
    required this.phone,
    required this.amount,
    required this.paymentMethod,
    required this.date,
    required this.status,
  });

  String get statusLabel {
    switch (status) {
      case 'ok': return 'Réussie';
      case 'fail': return 'Échouée';
      default: return 'En attente';
    }
  }

  String get serviceIcon {
    switch (service) {
      case 'Internet': return '🌐';
      case 'Appels': return '📞';
      case 'SMS': return '💬';
      default: return '📋';
    }
  }
}

class AppNotification {
  final String title;
  final String message;
  final String time;
  bool read;
  final String icon;
  final String type; // 'success' | 'error' | 'warning' | 'info'

  AppNotification({
    required this.title,
    required this.message,
    required this.time,
    required this.read,
    required this.icon,
    required this.type,
  });
}

class OperationConfig {
  final String name;
  final String subtitle;
  final String icon;
  final int colorValue;

  const OperationConfig({
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.colorValue,
  });
}

// Sample data
List<Transaction> sampleTransactions = [
  Transaction(id: 'TRX-2025-000125', operator: 'Orange', service: 'Internet', operation: 'Souscription pour moi', phone: '0701234567', amount: 1000, paymentMethod: 'Orange Money', date: DateTime.now().subtract(const Duration(hours: 2)), status: 'ok'),
  Transaction(id: 'TRX-2025-000124', operator: 'MTN', service: 'Appels', operation: 'Souscription pour moi', phone: '0701234567', amount: 2000, paymentMethod: 'MTN Money', date: DateTime.now().subtract(const Duration(days: 1)), status: 'ok'),
  Transaction(id: 'TRX-2025-000123', operator: 'Orange', service: 'SMS', operation: 'Transfert pour moi', phone: '0705678901', amount: 500, paymentMethod: 'Wave', date: DateTime.now().subtract(const Duration(days: 2)), status: 'ok'),
  Transaction(id: 'TRX-2025-000122', operator: 'Moov', service: 'Internet', operation: 'Souscription pour moi', phone: '0701234567', amount: 5000, paymentMethod: 'Moov Money', date: DateTime.now().subtract(const Duration(days: 3)), status: 'fail'),
  Transaction(id: 'TRX-2025-000121', operator: 'MTN', service: 'Appels', operation: 'Transfert pour un tiers', phone: '0709876543', amount: 1000, paymentMethod: 'Orange Money', date: DateTime.now().subtract(const Duration(days: 4)), status: 'ok'),
  Transaction(id: 'TRX-2025-000120', operator: 'Orange', service: 'Internet', operation: 'Souscription pour un tiers', phone: '0701234567', amount: 2000, paymentMethod: 'Wave', date: DateTime.now().subtract(const Duration(days: 5)), status: 'ok'),
];

List<AppNotification> sampleNotifications = [
  AppNotification(title: 'Transaction réussie', message: 'Forfait Internet 1000 FCFA activé sur 0701234567', time: "Aujourd'hui · 10:45", read: false, icon: '✅', type: 'success'),
  AppNotification(title: 'Souscription confirmée', message: 'Orange Internet 2000 FCFA · 07XXXXXXXX', time: "Hier · 08:12", read: false, icon: '📋', type: 'success'),
  AppNotification(title: 'Transfert effectué', message: 'MTN Appels 500 FCFA transféré avec succès', time: "22 Jul · 16:30", read: false, icon: '🔄', type: 'success'),
  AppNotification(title: 'Paiement échoué', message: 'Solde insuffisant - MTN Money', time: "21 Jul · 09:00", read: true, icon: '❌', type: 'error'),
  AppNotification(title: 'Forfait expiré', message: 'Votre forfait Internet de 500 FCFA a expiré', time: "20 Jul · 07:00", read: true, icon: '⚠️', type: 'warning'),
];
