import 'package:breathpacer/layers/domain/models/resources_model.dart';

class ResourcesState {
  List<ResourcesModel> resourceList;
  String selectedCategory;
  List<String> categories;
  bool isLoading;
  bool showErrorMessage;

  ResourcesState({
    this.resourceList = const [],
    this.selectedCategory = "All",
    this.categories = const ["All", "Infinite Wisdom", "Workshops"],
    this.showErrorMessage = false,
    this.isLoading = false,
  });

  ResourcesState.clone(ResourcesState existingState)
      : this(
            resourceList: existingState.resourceList,
            selectedCategory: existingState.selectedCategory,
            categories: List.from(existingState.categories),
            showErrorMessage: existingState.showErrorMessage,
            isLoading: existingState.isLoading);
}
