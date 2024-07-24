import 'package:breathpacer/layers/presentation/views/pages/faq/faq_view_model.dart';
import 'package:breathpacer/theme/app_theme.dart';
import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/models/faq_model.dart';
import '../../shared_widgets/star_magic/burger_drawer/burger_drawer_view.dart';
import 'faq_state.dart';

class FaqView extends StatelessWidget {
  FaqView({super.key});

  final FaqViewModel viewModel = FaqViewModel();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          drawer: BurgerDrawerView(),
          appBar: AppBar(
            title: const Text("FAQ's"),
            centerTitle: true,
            titleTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: AppTheme.colors.appBarColor,
            actions: [
              IconButton(
                icon: const Icon(Icons.home_filled),
                onPressed: () {
                  context.go("/home");
                },
              ),
            ],
          ),
          body: BlocBuilder<FaqViewModel, FaqState>(
            bloc: viewModel,
            builder: (_, state) {
              return SafeArea(
                top: true,
                bottom: true,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [buildFAQ(state.faqList)],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildFAQ(List<FaqModel> faqList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: faqList.length,
      itemBuilder: (context, index) {
        final category = faqList[index];
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.category,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 8.0),
              ...category.items.map((FaqItemModel item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: AppTheme.colors.blueSlider, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ExpansionWidget(
                      initiallyExpanded: item.isExpanded,
                      titleBuilder: (double animationValue, _, bool isExpanded, toggleFunction) {
                        return InkWell(
                          onTap: () => toggleFunction(animated: true),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  isExpanded ? Icons.remove : Icons.add,
                                  color: AppTheme.colors.blueSlider,
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    item.question,
                                    style: TextStyle(color: AppTheme.colors.blueSlider),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      content: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            item.answer,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
