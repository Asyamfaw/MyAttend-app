# MyAttend — Presensi Digital



**MyAttend** adalah aplikasi presensi karyawan berbasis Flutter yang dirancang untuk mencatat aktivitas kehadiran, mulai dari jam kedatangan hingga jam kepulangan. Aplikasi ini juga menyediakan ringkasan presensi harian dan riwayat kehadiran beserta dokumentasi foto.

## ✨ Fitur

- Login dan registrasi menggunakan akun email.
- Presensi kedatangan (jam masuk).
- Presensi kepulangan (jam pulang).
- Ringkasan presensi harian dan durasi kerja.
- Dokumentasi foto masuk dan foto pulang.
- Riwayat presensi.

> **Catatan:** Fitur dan tampilan yang tersedia mengikuti implementasi project saat ini. GPS, validasi radius kantor, payroll, dan manajemen cuti tidak termasuk dalam cakupan aplikasi ini.

## 🛠️ Tech Stack

| Teknologi                                                            | Kegunaan                         |
| -------------------------------------------------------------------- | -------------------------------- |
| [Flutter](https://flutter.dev/)                                      | Framework aplikasi multiplatform |
| [Dart](https://dart.dev/)                                            | Bahasa pemrograman               |
| [Firebase](https://firebase.google.com/)                             | Layanan backend aplikasi         |
| [Firebase Authentication](https://firebase.google.com/products/auth) | Autentikasi pengguna             |

## 📋 Persiapan

Pastikan perangkat development sudah memiliki:

- Git
- Flutter SDK dan Dart SDK (Dart sudah termasuk dalam Flutter).
- Android Studio.
- Android SDK dan Android Emulator, atau HP Android dengan USB Debugging aktif.
- Node.js 22 LTS (untuk Firebase CLI).
- Akun Google dan Firebase project.

Periksa instalasi Flutter:

```bash
flutter doctor -v
```

Ikuti petunjuk `flutter doctor` untuk menyelesaikan komponen Android yang belum terpasang atau lisensi Android SDK yang belum diterima.

## 📥 Clone Repository

Ganti URL berikut dengan URL repository project yang sebenarnya:

```bash
git clone https://github.com/USERNAME/REPOSITORY.git
cd REPOSITORY
```

## 💻 Setup di Windows

### 1. Install dan cek tools

Install Git, Flutter SDK, Android Studio, dan Node.js 22 LTS. Pastikan folder `flutter\bin` sudah ditambahkan ke Windows PATH.

Buka PowerShell baru, lalu jalankan:

```powershell
flutter --version
dart --version
node --version
npm --version
git --version
flutter doctor -v
```

### 2. Install Firebase CLI

```powershell
npm install -g firebase-tools
firebase --version
firebase login
```

Perintah `firebase login` akan membuka browser untuk login ke akun Google yang memiliki akses ke Firebase project.

### 3. Install FlutterFire CLI

```powershell
dart pub global activate flutterfire_cli
```

Tambahkan folder berikut ke User PATH Windows jika perintah `flutterfire` belum dikenali:

```text
%LOCALAPPDATA%\Pub\Cache\bin
```

Tutup dan buka kembali PowerShell, lalu cek:

```powershell
flutterfire --version
```

### 4. Konfigurasi Firebase

Dari root folder project:

```powershell
flutterfire configure --project=YOUR_FIREBASE_PROJECT_ID
```

Ganti `YOUR_FIREBASE_PROJECT_ID` dengan Project ID Firebase milikmu. Pilih platform Android (dan platform lain hanya jika memang digunakan project).

Pastikan layanan Firebase yang diperlukan aplikasi sudah disiapkan di Firebase Console, misalnya Authentication dengan metode Email/Password apabila aplikasi menggunakan login email dan password.

### 5. Install dependency dan jalankan aplikasi

```powershell
flutter pub get
flutter devices
flutter run
```

Untuk menjalankan ke perangkat tertentu:

```powershell
flutter run -d DEVICE_ID
```

## 🐧 Setup di Linux (Arch Linux)

### 1. Install tools sistem

```fish
sudo pacman -S --needed git nodejs npm
```

Install Flutter SDK, Android Studio, Android SDK, dan Android platform-tools sesuai panduan resmi masing-masing. Pastikan Flutter dan Android SDK sudah masuk PATH.

Periksa instalasi:

```fish
flutter --version
dart --version
node --version
npm --version
git --version
flutter doctor -v
```

Terima lisensi Android SDK jika diminta:

```fish
flutter doctor --android-licenses
```

### 2. Install Firebase CLI

```fish
npm install -g firebase-tools
firebase --version
firebase login
```

Gunakan Node.js versi LTS yang kompatibel dengan Firebase CLI.

Jika npm global menampilkan `EACCES`, jangan langsung menjalankan `sudo npm install -g`. Atur npm global prefix atau gunakan pengelola versi Node.js yang kompatibel dengan Fish Shell.

### 3. Install FlutterFire CLI

```fish
dart pub global activate flutterfire_cli
```

Tambahkan executable Dart global ke PATH Fish:

```fish
fish_add_path -U $HOME/.pub-cache/bin
```

Buka terminal baru atau jalankan ulang Fish, lalu cek:

```fish
flutterfire --version
```

### 4. Konfigurasi Firebase

Dari root folder project:

```fish
flutterfire configure --project=YOUR_FIREBASE_PROJECT_ID
```

Ganti `YOUR_FIREBASE_PROJECT_ID` dengan Project ID Firebase milikmu. Pilih Android sebagai platform jika aplikasi hanya ditargetkan untuk Android.

### 5. Install dependency dan jalankan aplikasi

```fish
flutter pub get
flutter devices
flutter run
```

Untuk menjalankan ke perangkat tertentu:

```fish
flutter run -d DEVICE_ID
```

## 🔥 Konfigurasi Firebase untuk Teman yang Melakukan Clone

Firebase configuration terikat pada Firebase project milik pemilik aplikasi. Setelah melakukan clone, kamu mungkin perlu menghubungkan aplikasi ke Firebase project milikmu sendiri.

1. Buat atau pilih project di [Firebase Console](https://console.firebase.google.com/).

2. Daftarkan aplikasi Android menggunakan Android application ID yang ada di `android/app/build.gradle.kts` pada bagian `applicationId`.

3. Aktifkan metode Authentication yang digunakan aplikasi, misalnya Email/Password.

4. Login melalui Firebase CLI:

   ```bash
   firebase login
   ```

5. Jalankan FlutterFire Configure:

   ```bash
   flutterfire configure --project=YOUR_FIREBASE_PROJECT_ID
   ```

6. Ikuti instruksi FlutterFire CLI untuk menghasilkan konfigurasi Firebase.

7. Install dependency dan jalankan aplikasi:

   ```bash
   flutter pub get
   flutter run
   ```

> **Penting:** Jangan pernah memasukkan Firebase Admin SDK service account, private key, token rahasia, atau kredensial server ke repository publik. Atur Firebase Security Rules dan Authentication sesuai kebutuhan aplikasi. File konfigurasi aplikasi klien bukan pengganti Security Rules.

## 📝 Catatan untuk Teman-Teman yang Suka Nge-Clone

Kalau kamu sudah baca sampai sini, selamat, literasimu masih ada ternyata, bre. \:v

Terima kasih sudah mampir dan mencoba project ini. Jangan lupa sesuaikan konfigurasi Firebase dengan project milikmu sendiri sebelum menjalankan aplikasinya.

---

## 👨‍💻 Author

**Asyam Mahdi Fawwaz**

*Software Developer Student | Web Development Enthusiast*

[![GitHub](https://img.shields.io/badge/GitHub-Asyamfaw-181717?style=for-the-badge&logo=github)](https://github.com/Asyamfaw)
[![Instagram](https://img.shields.io/badge/Instagram-Follow-E4405F?style=for-the-badge&logo=instagram&logoColor=white)](https://www.instagram.com/simakan.siang/)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/asyammahdifawwaz/)

---

Dibuat sebagai project pembelajaran dan pengembangan aplikasi presensi digital.

**MyAttend — Digital Attendance System**
