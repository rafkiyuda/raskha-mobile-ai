import 'dart:math';

class IdxService {
  static final Random _random = Random();

  // Mock Market Data
  static Map<String, dynamic> getMarketOverview() {
    return {
      'jci_change': -5.2, // Percent
      'vix_index': 38.5,
      'usd_idr': 16450.0,
      'foreign_net_sell': -2.1, // Trillion IDR
      'is_crisis': true,
    };
  }

  static List<Map<String, dynamic>> getSentimentFeed() {
    return [
      {
        'symbol': 'GOTO',
        'name': 'GoTo Gojek Tokopedia',
        'sentiment': 'Extreme FOMO',
        'score': 85.0, // 0-100 social hype
        'trend': 12.5, // Percent
        'mentions': '12.4K',
        'herding': 88, // Percent
        'fundamental': 32,
        'sources': {'Twitter': 65, 'TikTok': 25, 'Stockbit': 10},
        'alerts': ['Extreme social media hype detected.', '85% of mentions are from 3 finfluencer accounts.'],
      },
      {
        'symbol': 'BBCA',
        'name': 'Bank Central Asia',
        'sentiment': 'Neutral',
        'score': 50.0,
        'trend': 0.8,
        'mentions': '5.1K',
        'herding': 12,
        'fundamental': 92,
        'sources': {'Twitter': 30, 'TikTok': 10, 'Stockbit': 60},
        'alerts': ['Strong institutional buying detected.'],
      },
      {
        'symbol': 'BREN',
        'name': 'Barito Renewables',
        'sentiment': 'Bullish',
        'score': 75.0,
        'trend': 5.8,
        'mentions': '8.2K',
        'herding': 45,
        'fundamental': 68,
        'sources': {'Twitter': 40, 'TikTok': 15, 'Stockbit': 45},
        'alerts': ['Clean energy sentiment rising.'],
      },
      {
        'symbol': 'ARTO',
        'name': 'Bank Jago',
        'sentiment': 'Bearish',
        'score': 25.0,
        'trend': -3.2,
        'mentions': '3.4K',
        'herding': 65,
        'fundamental': 45,
        'sources': {'Twitter': 20, 'TikTok': 30, 'Stockbit': 50},
        'alerts': ['Sell pressure from retail sector.'],
      },
    ];
  }

  static List<Map<String, String>> getSafeHavenOptions() {
    return [
      {'name': 'SBN (Govt. Bonds)', 'risk': 'Very Low', 'yield': '6.8%'},
      {'name': 'Gold (Antam)', 'risk': 'Low', 'yield': '12.4% YTD'},
      {'name': 'Money Market Fund', 'risk': 'Very Low', 'yield': '4.2%'},
    ];
  }

  static List<Map<String, dynamic>> getFinancialIntegrityData() {
    return [
      {
        'symbol': 'BBCA',
        'name': 'Bank Central Asia',
        'score': 92,
        'grade': 'A',
        'netProfit': 'Rp 48.2T',
        'cashFlow': 'Rp 45.8T',
        'alignment': 95,
        'anomalies': 'No anomalies detected in financial statements',
        'isExpanded': true,
      },
      {
        'symbol': 'TLKM',
        'name': 'Telkom Indonesia',
        'score': 85,
        'grade': 'A',
        'netProfit': 'Rp 24.5T',
        'cashFlow': 'Rp 22.1T',
        'alignment': 90,
        'anomalies': 'Minor discrepancies in depreciation reporting.',
        'isExpanded': false,
      },
      {
        'symbol': 'GOTO',
        'name': 'GoTo Gojek Tokopedia',
        'score': 42,
        'grade': 'C',
        'netProfit': '-Rp 1.2T',
        'cashFlow': 'Rp 0.4T',
        'alignment': 33,
        'anomalies': 'Significant outlier in marketing spend to revenue ratio.',
        'isExpanded': false,
      },
    ];
  }
  static Future<String> getAIInsight(String symbol) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));
    
    final insights = {
      'BBCA': 'BBCA menunjukkan integritas laba yang sangat kuat (Alignment 92%). Pertumbuhan laba bersih didukung penuh oleh arus kas operasional, menandakan kualitas laba yang tinggi. Ekspansi kredit tetap terjaga dengan NPL rendah.',
      'TLKM': 'TLKM memiliki skor integritas stabil (85%). Meskipun arus kas sedikit tertinggal akibat belanja modal (CAPEX) 5G yang masif, namun profil profitabilitas tetap sehat tanpa anomali akuntansi yang signifikan.',
      'GOTO': 'GOTO menunjukkan perbaikan efisiensi yang signifikan. Meskipun skor integritas masih moderat (52%), tren penyusutan rugi bersih mulai selaras dengan efisiensi biaya operasional yang konsisten.',
      'ASII': 'ASII mempertahankan skor tinggi (78%). Diversifikasi bisnis yang kuat menopang arus kas yang solid, meskipun terdapat tekanan di sektor komoditas yang memengaruhi margin kontribusi anak usaha.',
    };

    return insights[symbol] ?? 'Analisis AI menunjukkan emiten ini memiliki profil risiko yang terjaga dengan transparansi laporan keuangan yang memadai bagi investor jangka menengah.';
  }
}
