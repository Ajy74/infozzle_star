import 'package:breathpacer/layers/domain/models/blog_model.dart';
import 'package:breathpacer/layers/domain/services/database_fetch_service.dart';
import 'package:get/get.dart';

class GetBlogsUseCase {
  Future<List<BlogModel>> execute(String type) async {
    return await Get.find<DatabaseFetchService>().fetchBlogs(type);
  }
}
