import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/globals.dart';
import '../../../../domain/models/audio_section_model.dart';
import '../../../../domain/use_cases/database/add_like_use_case.dart';
import '../../../../domain/use_cases/database/remove_like_use_case.dart';
import 'audio_section_state.dart';

class AudioSectionViewModel extends Cubit<AudioSectionState> {
  AudioSectionViewModel() : super(AudioSectionState());

  AddLikeUseCase addLikeUseCase = AddLikeUseCase();
  RemoveLikeUseCase removeLikeUseCase = RemoveLikeUseCase();

  void saveChallenge(List<AudioSectionModel> audio) {
    state.allItems = audio;
    state.originalItemsList = audio;
    emit(AudioSectionState.clone(state));
  }

  void onFilterSelected(BuildContext context, List<String> filters) {
    updateSelectedFilter(filters);
    updateSelectedFilterLabel(getFilterLabel(filters));
    filterByTime(filters);
    //Navigator.pop(context);
  }

  void filterByTime(List<String> timeRange) {
    var challenges = state.originalItemsList;
    List<AudioSectionModel> allChallengesTime = [];
    for (var time in timeRange) {
      if (time != 'All') {
        allChallengesTime.addAll(challenges.where((challenge) => _isWithinTimeRange(challenge.time, time)).toList());
      } else {
        allChallengesTime = challenges;
      }
    }
    _updateCurrentChallenges(allChallengesTime);
  }

  void onSortSelected(String sortOption) {
    if (sortOption == 'High to Low') {
      updateSelectedSortLabel(sortOption);
      filterByLikes(false);
    } else {
      updateSelectedSortLabel("Low to High");
      filterByLikes(true);
    }
  }

  void filterByLikes(bool ascending) {
    state.allItems
        .sort((a, b) => ascending ? a.numOfLikes.compareTo(b.numOfLikes) : b.numOfLikes.compareTo(a.numOfLikes));
    emit(AudioSectionState.clone(state));
  }

  void _updateCurrentChallenges(List<AudioSectionModel> updatedChallenges) {
    state.allItems = updatedChallenges;

    emit(AudioSectionState.clone(state));
  }

  void setCurrentFiltersSelected(List<String> filters) {
    state.selectedFilters = filters;
    emit(AudioSectionState.clone(state));
  }

  void updateSelectedFilter(List<String> newFilter) {
    if (newFilter.length == 1) {
      state.selectedFilter = newFilter[0];
    } else {
      state.selectedFilter = "multiple";
    }

    emit(AudioSectionState.clone(state));
  }

  void updateSelectedFilterLabel(String newFilter) {
    state.selectedFilterLabel = newFilter;
    emit(AudioSectionState.clone(state));
  }

  void updateSelectedSortLabel(String newSort) {
    state.selectedSortLabel = newSort;
    emit(AudioSectionState.clone(state));
  }

  Future<void> toggleLiked(AudioSectionModel challenge, int index, List<AudioSectionModel> challenges) async {
    try {
      final token = await globalGetToken();

      if (challenges[index].isLiked) {
        challenges[index] = challenges[index].copyWith(isLiked: false, numOfLikes: challenges[index].numOfLikes - 1);
        await removeLikeUseCase.execute(challenges[index].id, token!);
      } else {
        challenges[index] = challenges[index].copyWith(isLiked: true, numOfLikes: challenges[index].numOfLikes + 1);
        await addLikeUseCase.execute(challenges[index].id, token!);
      }
    } catch (e) {
      state.showErrorMessage = true;
      print("Failed to update like value: $e");
    }
    emit(AudioSectionState.clone(state));
  }

  void reset() {
    emit(AudioSectionState());
  }

  ////----------------------------------------------------
  //// Helper Methods
  ////----------------------------------------------------

  String getFilterLabel(List<String> filter) {
    String label = "";
    if (filter.length == 1) {
      label = filter[0];
    } else {
      label = "multiple";
    }

    switch (label) {
      case 'All':
        return 'All';
      case '0-10 mins':
        return '0-10 mins';
      case '10-20 mins':
        return '10-20 mins';
      case '20-30 mins':
        return '20-30 mins';
      case '30-40 mins':
        return '30-40 mins';
      case '40-50 mins':
        return '40-50 mins';
      case '50 mins - 1 hour':
        return '50 mins-1 hour';
      case '1 - 2 hours':
        return '1-2 hours';
      case 'More than 2 hours':
        return '2+ hours';
      case 'multiple':
        return 'Filters Selected';
      default:
        return 'Filter by time';
    }
  }

  bool _isWithinTimeRange(String time, String timeRange) {
    final duration = _parseTimeToMinutes(time);

    switch (timeRange) {
      case '0-10 mins':
        return duration >= 0 && duration <= 10;
      case '10-20 mins':
        return duration > 10 && duration <= 20;
      case '20-30 mins':
        return duration > 20 && duration <= 30;
      case '30-40 mins':
        return duration > 30 && duration <= 40;
      case '40-50 mins':
        return duration > 40 && duration <= 50;
      case '50 mins - 1 hour':
        return duration > 50 && duration <= 60;
      case '1 - 2 hours':
        return duration > 60 && duration <= 120;
      case 'More than 2 hours':
        return duration > 120;
      default:
        return false;
    }
  }

  int _parseTimeToMinutes(String time) {
    // In format -> 00:00:00
    List<String> split = time.split(":");
    if (split.length == 1) {
      // only seconds
      return 0;
    } else if (split.length == 2) {
      // minutes at 0, seconds at 1
      return int.parse(split.elementAt(0));
    } else if (split.length == 3) {
      // hours at 0, minutes at 1, seconds at 2
      int hours = int.parse(split.elementAt(0));
      int hoursAsMinutes = hours * 60;
      int minutes = int.parse(split.elementAt(1));

      return hoursAsMinutes + minutes;
    }

    return 0;
  }
}
