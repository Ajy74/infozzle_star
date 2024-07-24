import '../../../../domain/models/challenge_model.dart';

class ChallengesState {
  ChallengeModel sevenDayChallenge;
  ChallengeModel thirteenDayChallenge;
  ChallengeModel twentySevenDayChallenge;
  ChallengeModel originalSevenDayChallenge;
  ChallengeModel originalThirteenDayChallenge;
  ChallengeModel originalTwentySevenDayChallenge;
  int selectedChallenges;
  String selectedFilter;
  String selectedFilterLabel;
  String selectedSortLabel;

  ChallengesState({
    this.sevenDayChallenge = const ChallengeModel(title: "", description: "", challenges: []),
    this.thirteenDayChallenge = const ChallengeModel(title: "", description: "", challenges: []),
    this.twentySevenDayChallenge = const ChallengeModel(title: "", description: "", challenges: []),
    this.originalSevenDayChallenge = const ChallengeModel(title: "", description: "", challenges: []),
    this.originalThirteenDayChallenge = const ChallengeModel(title: "", description: "", challenges: []),
    this.originalTwentySevenDayChallenge = const ChallengeModel(title: "", description: "", challenges: []),
    this.selectedChallenges = 7,
    this.selectedFilter = "All",
    this.selectedFilterLabel = 'Filter by time',
    this.selectedSortLabel = 'Sort by likes',
  });

  ChallengesState.clone(ChallengesState existingState)
      : this(
            sevenDayChallenge: existingState.sevenDayChallenge,
            thirteenDayChallenge: existingState.thirteenDayChallenge,
            twentySevenDayChallenge: existingState.twentySevenDayChallenge,
            originalSevenDayChallenge: existingState.originalSevenDayChallenge,
            originalThirteenDayChallenge: existingState.originalThirteenDayChallenge,
            originalTwentySevenDayChallenge: existingState.originalTwentySevenDayChallenge,
            selectedChallenges: existingState.selectedChallenges,
            selectedFilter: existingState.selectedFilter,
            selectedFilterLabel: existingState.selectedFilterLabel,
            selectedSortLabel: existingState.selectedSortLabel);
}
