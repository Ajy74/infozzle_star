import '../../../../domain/models/audio_section_model.dart';

class AudioSectionState {
  List<AudioSectionModel> allItems;
  List<AudioSectionModel> originalItemsList;
  List<String> categories;
  List<String> selectedFilters;
  String selectedFilter;
  String selectedFilterLabel;
  String selectedSortLabel;
  bool showErrorMessage;
  int? playlistId;

  AudioSectionState({
    this.allItems = const [],
    this.originalItemsList = const [],
    this.selectedFilters = const [],
    this.selectedFilter = "All",
    this.selectedFilterLabel = 'Filter by time',
    this.categories = const ["High to Low", "Low to High"],
    this.selectedSortLabel = "",
    this.showErrorMessage = false,
    this.playlistId,
  });

  AudioSectionState.clone(AudioSectionState existingState)
      : this(
            allItems: existingState.allItems,
            originalItemsList: existingState.originalItemsList,
            categories: existingState.categories,
            selectedFilters: existingState.selectedFilters,
            selectedFilter: existingState.selectedFilter,
            selectedFilterLabel: existingState.selectedFilterLabel,
            selectedSortLabel: existingState.selectedSortLabel,
            showErrorMessage: existingState.showErrorMessage,
            playlistId: existingState.playlistId);
}
