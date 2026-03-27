class NewsItem {
  final String id;
  final String title;
  final String content;
  final String excerpt;
  final String imageUrl;
  final String category;
  final DateTime date;
  final String author;

  NewsItem({
    required this.id,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.imageUrl,
    required this.category,
    required this.date,
    this.author = "Raksha Editorial",
  });
}

// Mock data for News
List<NewsItem> mockNews = [
  NewsItem(
    id: '1',
    title: 'IHSG Melemah di Tengah Ketidakpastian Ekonomi Global',
    excerpt: 'Indeks Harga Saham Gabungan (IHSG) ditutup memerah sore ini...',
    content: '''Indeks Harga Saham Gabungan (IHSG) Bursa Efek Indonesia (BEI) pada penutupan perdagangan Kamis (26/3) sore ini ditutup melemah. IHSG turun 6,06% ke level 3.750,21.

Penurunan ini didorong oleh aksi jual investor asing di saham-saham blue chip seperti BBCA, BBRI, dan TLKM. Analis memperkirakan pelemahan ini bersifat sementara di tengah penyesuaian pasar terhadap data inflasi terbaru.

Bagi investor ritel, Raksha AI merekomendasikan untuk tetap tenang dan tidak melakukan 'panic selling'. Fokus pada fundamental perusahaan yang kuat dan pertimbangkan untuk melakukan dollar cost averaging pada saham-saham dengan valuasi yang sudah menarik.''',
    imageUrl: 'assets/images/news_ihsg_drop.png', // I will make sure to copy/move these later or use paths
    category: 'Pasar Saham',
    date: DateTime.now(),
  ),
  NewsItem(
    id: '2',
    title: 'Waspada Modus Penipuan Investasi Lewat Chat WhatsApp',
    excerpt: 'Modus penipuan berkedok investasi melalui pesan singkat WhatsApp kembali marak...',
    content: '''Waspada! Tim Raksha AI menemukan peningkatan laporan terkait modus penipuan 'pig butchering' yang dilakukan melalui pesan WhatsApp dari nomor luar negeri.

Pelaku biasanya memulai dengan menyapa secara ramah, lalu perlahan menawarkan 'kesempatan investasi emas' dengan keuntungan tidak realistis (lebih dari 1% per hari). 

Tanda-tanda bahaya yang harus diwaspadai:
1. Menjanjikan keuntungan pasti tanpa risiko.
2. Meminta transfer ke rekening pribadi, bukan perusahaan sekuritas.
3. Desakan untuk segera melakukan transfer saldo.

Selalu gunakan fitur Truth Scanner di aplikasi Raksha AI untuk memverifikasi klaim mencurigakan sebelum Anda mengirimkan dana apapun.''',
    imageUrl: 'assets/images/news_fraud_alert.png',
    category: 'Keamanan',
    date: DateTime.now().subtract(const Duration(days: 1)),
  ),
  NewsItem(
    id: '3',
    title: 'Pentingnya Diversifikasi Emas di Tengah Inflasi Dunia',
    excerpt: 'Emas tetap menjadi aset safe haven pilihan di tengah fluktuasi mata uang global...',
    content: '''Dalam kondisi ekonomi yang tidak menentu, emas kembali membuktikan perannya sebagai pelindung nilai kekayaan (safe haven). 

Data terbaru menunjukkan permintaan emas fisik terus meningkat di sektor ritel. Diversifikasi aset ke dalam logam mulia dapat membantu menjaga daya beli jangka panjang dari erosi inflasi.

Raksha AI menyarankan alokasi 5-10% dari portofolio Anda pada aset komoditas atau emas untuk menjaga stabilitas keseluruhan investasi Anda di masa depan.''',
    imageUrl: 'assets/images/news_edu_gold.png',
    category: 'Edukasi',
    date: DateTime.now().subtract(const Duration(hours: 5)),
  ),
  NewsItem(
    id: '4',
    title: 'Tren Kripto 2026: Fokus pada Utilitas dan Regulasi',
    excerpt: 'Pasar aset digital mulai bergeser ke arah proyek yang memiliki utilitas nyata...',
    content: '''Memasuki pertengahan 2026, pasar kripto menunjukkan kedewasaan dengan fokus yang lebih besar pada proyek-proyek berbasis smart contract dan solusi Layer-2.

Regulasi global yang semakin jelas memberikan kepastian bagi institusi besar untuk masuk ke pasar. Namun, investor ritel tetap diimbau waspada terhadap proyek 'meme coin' yang tidak memiliki fundamental jelas.

Pastikan Anda hanya berinvestasi pada koin yang terdaftar di BAPPEBTI dan selalu melakukan riset mendalam melalui bantuan Raksha AI.''',
    imageUrl: 'assets/images/news_crypto_trends.png',
    category: 'Kripto',
    date: DateTime.now().subtract(const Duration(days: 2)),
  ),
];
