### Tugas 7

1. Widget tree adalah struktur hierarkis yang menggambarkan susunan widget dalam flutter. Hubungan parent-child menunjukkan widget induk yang membungkus widget anak menggunakan `child` untuk satu anak dan `children` untuk beberapa anak. contoh, `InfoCard` terdiri dari `Card`, `Container`, dan `Column` yang berisi `Text` serta `SizedBox`. Data dari parent dapat diteruskan ke child melalui parameter konstruktor, seperti `title` dan `content` dari `MyHomePage` ke `InfoCard`.

2. widget widget yang digunakan di myportofolio_mobile:
- MyApp dan MaterialApp: Mengatur konfigurasi, tema, dan halaman awal aplikasi.
- MyHomePage dan Scaffold: Menyusun struktur halaman utama.
- AppBar dan Text: Menampilkan judul dan informasi.
- Column, Row, GridView.count, dan Flexible: Mengatur tata letak widget.
- Padding, Container, SizedBox, dan Center: Mengatur ukuran, posisi, dan jarak antarelemen.
- SingleChildScrollView: Memungkinkan halaman digulir.
- InfoCard dan Card: Menampilkan informasi profil dalam bentuk kartu.
- ItemCard, Material, InkWell, Icon, dan FittedBox: Menampilkan kartu aksi beserta ikon dan interaksinya.
- SnackBar: Menampilkan pesan sementara setelah tombol ditekan.

3. widget MaterialApp mengatur konfigurasi aplikasi flutter, seperti tema, judul, navigasi, dan halaman awal. Dalam proyek ini, MaterialApp mengatur judul “MyPortfolio”, tema melalui ThemeData, serta MyHomePage sebagai halaman awal. MaterialApp ditempatkan dekat akar widget tree agar konfigurasinya dapat digunakan oleh widget lain. Pada proyek ini, MyApp menjadi widget akar yang dipanggil melalui runApp(), kemudian membangun MaterialApp.

4. StatelessWidget adalah widget yang tidak mengelola state internal dan cocok untuk menampilkan data yang relatif tetap, seperti InfoCard pada proyek ini. Widget ini tetap dapat dibangun ulang jika konfigurasi atau data dari induknya berubah.

StatefulWidget memiliki objek State untuk mengelola data yang berubah selama aplikasi berjalan, seperti penghitung atau input formulir. Perubahan tampilan dapat dilakukan menggunakan setState().

Interaksi tidak selalu membutuhkan StatefulWidget. Contohnya, ItemCard tetap menggunakan StatelessWidget karena hanya menampilkan SnackBar tanpa mengubah state internal.

5. BuildContext adalah objek yang menunjukkan posisi widget dalam widget tree dan memungkinkan akses ke informasi dari widget induknya.

Dalam proyek ini, BuildContext digunakan melalui Theme.of(context) untuk mengambil tema, MediaQuery.of(context) untuk memperoleh ukuran layar, dan ScaffoldMessenger.of(context) untuk menampilkan SnackBar.

Penggunaan context harus sesuai dengan posisi widget agar dapat mengakses informasi yang dibutuhkan.

6. Hot reload digunakan untuk menerapkan perubahan kode tanpa menjalankan ulang aplikasi dan tetap mempertahankan state. Fitur ini cocok untuk perubahan tampilan seperti warna, teks, dan tata letak.

Hot restart menjalankan ulang aplikasi dari main() dan mereset state, sehingga cocok untuk perubahan inisialisasi. Sementara itu, full restart menjalankan ulang aplikasi sepenuhnya, termasuk perubahan kode native.

Dalam mode debug melalui flutter run, tombol r digunakan untuk hot reload dan R untuk hot restart.


AI Disclosure: Saya menggunakan AI(chatGPT dan codex)sebagai alat bantu dalam pengerjaan Tugas Individu 7.

Bantuan bantuan yang diberikan AI:
- Menyesuaikan informasi profil serta menambahkan atribut warna pada ItemHomepage agar setiap kartu aksi memiliki warna berbeda.
- Merapikan penempatan teks pada kartu profil dan memperbarui dokumentasi penggunaan proyek.
- Menjelaskan konsep Flutter yang digunakan dan membantu menyusun draf jawaban pertanyaan reflektif.

