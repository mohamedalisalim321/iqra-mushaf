# IQRA — Simple Project Description

Project IQRA is a lightweight, offline Flutter app for reading, listening to, and studying the Quran. It focuses on a clear Mushaf (page) view, word-by-word audio, and basic Arabic analysis — all designed to work fast on mobile devices without internet.

## ScreenShots
| Pages | Pages (Dark)|
|--------------|------------|
| <img width="1080" height="2408" alt="home page" src="https://github.com/user-attachments/assets/dab18d2d-576b-4e73-9045-14f10ea91162" /> | <img width="1080" height="2408" alt="home page (dark)" src="https://github.com/user-attachments/assets/5327e98b-0cf2-4c12-9b63-23a3b1f850b5" /> |

## One-line summary
A fast, easy-to-use offline Quran app with accurate page layout, synchronized word audio, and simple Arabic word info for learners.

## Main features (easy to understand)
- Mushaf layout: Displays Quran pages the same way printed Mushafs do, with correct line breaks and verse numbers.
- Word-by-word audio: Tap a word to play its audio; follow along as words are highlighted while reciting.
- Arabic analysis: Quick info for each word — base form (lemma), root, and simple part-of-speech labels to help learners.
- Offline database: All core data (text, word timestamps, and analysis) is stored locally so the app works without internet.
- Fast lookups: Uses efficient search (binary search + caching) so tapping or searching responds instantly.

## Why this is useful
- Learners can replay words or short phrases to help memorization.
- Teachers can show exact word meanings and forms during lessons.
- Works in low-connectivity areas because everything is available offline.

## How it works (short)
- The app stores the Quran text and word metadata in a compact local database (Isar).
- Audio files are matched to words by timestamps. When you tap a word, the app finds its timestamp (fast) and plays the correct audio segment.
- Visual offsets (where words appear on the page) are kept in sorted lists so the app can quickly map screen taps to words using binary search.

## Who should use it
- Students learning to read or memorize the Quran.
- Teachers and study groups needing a clear visual and audio aid.
- Anyone who wants an offline, fast Quran reader with helpful study features.

## Quick technical notes
- Built with Flutter (cross-platform).
- Uses Isar for local data storage.
- Uses a reliable audio player library for playback and seeking.
- Preprocessing scripts prepare timestamps and analysis before packaging, keeping the app fast.

## Contact / Next steps
If you want screenshots, a demo build, or a short video, tell me which platform (Android/iOS) and I’ll add them. For questions or collaboration, reach out on GitHub: @mohamedalisalim321.
