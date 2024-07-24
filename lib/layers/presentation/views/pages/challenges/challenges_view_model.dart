import 'package:breathpacer/layers/domain/models/challenge_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/models/audio_section_model.dart';
import 'challenges_state.dart';

class ChallengesViewModel extends Cubit<ChallengesState> {
  ChallengesViewModel() : super(ChallengesState()) {
    fetchAllChallenges();
  }

  void fetchAllChallenges() {
    fetchSevenChallenges();
    fetchThirteenChallenges();
    fetchTwentySevenChallenges();
  }

  void fetchSevenChallenges() {
    List<AudioSectionModel> getChallenges = [
      AudioSectionModel(
          id: 0,
          unlocked: false,
          title: "Immortal",
          image: "https://placehold.co/300x400.jpg",
          time: "2 min",
          description:
              "Description Here: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce mollis tristique ipsum, lobortis tempus lectus aliquam eu. Vestibulum ultricies nisl vitae lorem ullamcorper, non laoreet massa auctor.",
          audioURL:
              "https://firebasestorage.googleapis.com/v0/b/test-c299e.appspot.com/o/meditation_11-test-track-with-639hz-solfeggio-146354.mp3?alt=media&token=3e027e01-46ae-43af-9e06-9cd0cfc2ceb2",
          numOfLikes: 10,
          originalURL:
              "https://firebasestorage.googleapis.com/v0/b/test-c299e.appspot.com/o/meditation_11-test-track-with-639hz-solfeggio-146354.mp3?alt=media&token=3e027e01-46ae-43af-9e06-9cd0cfc2ceb2",
          isDownloaded: false,
          isLiked: false,
          isAddedToPlaylist: false,
          savedInPlaylists: [],
          savedInVaults: []),
      AudioSectionModel(
          id: 0,
          unlocked: false,
          title: "Be Pure Love & Manifest",
          image: "https://placehold.co/400x400.jpg",
          time: "15 min",
          description: "Description Here",
          audioURL:
              "https://firebasestorage.googleapis.com/v0/b/test-c299e.appspot.com/o/meditation_11-test-track-with-639hz-solfeggio-146354.mp3?alt=media&token=3e027e01-46ae-43af-9e06-9cd0cfc2ceb2",
          numOfLikes: 17,
          originalURL:
              "https://firebasestorage.googleapis.com/v0/b/test-c299e.appspot.com/o/meditation_11-test-track-with-639hz-solfeggio-146354.mp3?alt=media&token=3e027e01-46ae-43af-9e06-9cd0cfc2ceb2",
          isDownloaded: false,
          isLiked: false,
          isAddedToPlaylist: false,
          savedInPlaylists: [],
          savedInVaults: []),
      AudioSectionModel(
          id: 0,
          title: "Just Be",
          unlocked: false,
          image: "https://placehold.co/300x400.jpg",
          time: "34 min",
          description: "Description Here",
          audioURL:
              "https://firebasestorage.googleapis.com/v0/b/test-c299e.appspot.com/o/meditation_11-test-track-with-639hz-solfeggio-146354.mp3?alt=media&token=3e027e01-46ae-43af-9e06-9cd0cfc2ceb2",
          numOfLikes: 2,
          originalURL:
              "https://firebasestorage.googleapis.com/v0/b/test-c299e.appspot.com/o/meditation_11-test-track-with-639hz-solfeggio-146354.mp3?alt=media&token=3e027e01-46ae-43af-9e06-9cd0cfc2ceb2",
          isDownloaded: false,
          isLiked: false,
          isAddedToPlaylist: false,
          savedInPlaylists: [],
          savedInVaults: []),
      AudioSectionModel(
          id: 0,
          title: "Radially Unique",
          unlocked: false,
          image: "https://placehold.co/300x400.jpg",
          time: "25 min",
          description: "Description Here",
          audioURL:
              "https://firebasestorage.googleapis.com/v0/b/test-c299e.appspot.com/o/meditation_11-test-track-with-639hz-solfeggio-146354.mp3?alt=media&token=3e027e01-46ae-43af-9e06-9cd0cfc2ceb2",
          numOfLikes: 4,
          originalURL:
              "https://firebasestorage.googleapis.com/v0/b/test-c299e.appspot.com/o/meditation_11-test-track-with-639hz-solfeggio-146354.mp3?alt=media&token=3e027e01-46ae-43af-9e06-9cd0cfc2ceb2",
          isDownloaded: false,
          isLiked: false,
          isAddedToPlaylist: false,
          savedInPlaylists: [],
          savedInVaults: []),
      AudioSectionModel(
          id: 0,
          unlocked: false,
          title: "Radiate Love & Magic",
          image: "https://placehold.co/300x400.jpg",
          time: "3 min",
          description: "Description Here",
          audioURL:
              "https://firebasestorage.googleapis.com/v0/b/test-c299e.appspot.com/o/meditation_11-test-track-with-639hz-solfeggio-146354.mp3?alt=media&token=3e027e01-46ae-43af-9e06-9cd0cfc2ceb2",
          numOfLikes: 10,
          originalURL:
              "https://firebasestorage.googleapis.com/v0/b/test-c299e.appspot.com/o/meditation_11-test-track-with-639hz-solfeggio-146354.mp3?alt=media&token=3e027e01-46ae-43af-9e06-9cd0cfc2ceb2",
          isDownloaded: false,
          isLiked: false,
          isAddedToPlaylist: false,
          savedInPlaylists: [],
          savedInVaults: []),
      AudioSectionModel(
          id: 0,
          unlocked: false,
          title: "Cosmic Infusion",
          image: "https://placehold.co/300x400.jpg",
          time: "2 min",
          description: "Description Here",
          audioURL:
              "https://firebasestorage.googleapis.com/v0/b/test-c299e.appspot.com/o/meditation_11-test-track-with-639hz-solfeggio-146354.mp3?alt=media&token=3e027e01-46ae-43af-9e06-9cd0cfc2ceb2",
          numOfLikes: 24,
          originalURL:
              "https://firebasestorage.googleapis.com/v0/b/test-c299e.appspot.com/o/meditation_11-test-track-with-639hz-solfeggio-146354.mp3?alt=media&token=3e027e01-46ae-43af-9e06-9cd0cfc2ceb2",
          isDownloaded: false,
          isLiked: false,
          isAddedToPlaylist: false,
          savedInPlaylists: [],
          savedInVaults: []),
      AudioSectionModel(
          id: 0,
          unlocked: false,
          title: "5D Ascension",
          image: "https://placehold.co/300x400.jpg",
          time: "545 min",
          description: "Description Here",
          audioURL:
              "https://firebasestorage.googleapis.com/v0/b/test-c299e.appspot.com/o/meditation_11-test-track-with-639hz-solfeggio-146354.mp3?alt=media&token=3e027e01-46ae-43af-9e06-9cd0cfc2ceb2",
          numOfLikes: 0,
          originalURL:
              "https://firebasestorage.googleapis.com/v0/b/test-c299e.appspot.com/o/meditation_11-test-track-with-639hz-solfeggio-146354.mp3?alt=media&token=3e027e01-46ae-43af-9e06-9cd0cfc2ceb2",
          isDownloaded: false,
          isLiked: false,
          isAddedToPlaylist: false,
          savedInPlaylists: [],
          savedInVaults: []),
    ];

    state.sevenDayChallenge = ChallengeModel(
        title: "7 DAY CHALLENGE",
        description: "Listen to the following meditations in order for the next 7 days",
        challenges: getChallenges);
    state.originalSevenDayChallenge = ChallengeModel(
        title: "7 DAY CHALLENGE",
        description: "Listen to the following meditations in order for the next 7 days",
        challenges: getChallenges);
    emit(ChallengesState.clone(state));
  }

  void fetchThirteenChallenges() {
    List<AudioSectionModel> getChallenges = [
      AudioSectionModel(
          id: 0,
          unlocked: false,
          title: "Unconditional Self Love",
          image: "image_path",
          time: "20 min",
          description: "Description",
          audioURL: "audio_url",
          originalURL: "audio_url",
          isDownloaded: false,
          numOfLikes: 10,
          isLiked: false,
          isAddedToPlaylist: false,
          savedInPlaylists: [],
          savedInVaults: []),
    ];

    state.thirteenDayChallenge = ChallengeModel(
        title: "13 DAY CHALLENGE",
        description: "Listen to the following meditations in order for the next 13 days",
        challenges: getChallenges);
    state.originalThirteenDayChallenge = ChallengeModel(
        title: "13 DAY CHALLENGE",
        description: "Listen to the following meditations in order for the next 13 days",
        challenges: getChallenges);
    emit(ChallengesState.clone(state));
  }

  void fetchTwentySevenChallenges() {
    List<AudioSectionModel> getChallenges = [
      AudioSectionModel(
          id: 0,
          unlocked: false,
          title: "Experience Pure Love",
          image: "image_path",
          time: "20 min",
          description: "Description",
          audioURL: "audio_url",
          originalURL: "audio_url",
          isDownloaded: false,
          numOfLikes: 10,
          isLiked: false,
          isAddedToPlaylist: false,
          savedInPlaylists: [],
          savedInVaults: []),
    ];

    state.twentySevenDayChallenge = ChallengeModel(
        title: "27 DAY CHALLENGE",
        description: "Listen to the following meditations in order for the next 27 days",
        challenges: getChallenges);
    state.originalTwentySevenDayChallenge = ChallengeModel(
        title: "7 DAY CHALLENGE",
        description: "Listen to the following meditations in order for the next 27 days",
        challenges: getChallenges);
    emit(ChallengesState.clone(state));
  }

  void updateSelectedChallenge(int chosen) {
    state.selectedChallenges = chosen;
    emit(ChallengesState.clone(state));
  }

  void reset() {
    emit(ChallengesState());
  }
}
