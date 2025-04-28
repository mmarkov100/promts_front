import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promts_application_1/core/cubits/data_cubit.dart';
import 'package:promts_application_1/features/neuro/cubits/neuro_cubit.dart';
import 'package:promts_application_1/features/neuro/data/models/neuro_model.dart';
import 'package:promts_application_1/features/neuro/domain/entities/neuro_entity.dart';
import 'package:promts_application_1/features/user/cubit/user_cubit.dart';
import 'package:promts_application_1/features/user/domain/entities/user_entity.dart';
import 'package:promts_application_1/features/user/view/widgets/widget_user_settings.dart';
import '../../../chatbot/view/widgets/widget_chat_bots.dart';

/// AppBar с кнопкой Promts и дополнительным callback для нее.
class WidgetAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuPressed; // для открытия левого Drawer
  final VoidCallback onPromtsPressed; // callback для кнопки Promts

  const WidgetAppBar({
    super.key,
    required this.onMenuPressed,
    required this.onPromtsPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          // Кнопка открытия NavigationDrawer (иконка "3 полоски")
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: onMenuPressed,
          ),
          // Кнопка "Promts"
          TextButton(
            onPressed: onPromtsPressed, // вызываем переданный callback
            child: const Text(
              "Promts",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
          // Центр AppBar (название чата)
          const Expanded(
            child: Text(
              "Обычный чат-бот",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          // Кнопка настроек пользователя (иконка человечка)
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => BlocBuilder<UserCubit, DataState<UserEntity>>(
                  builder: (context, state) {
                    if (state is DataLoading<UserEntity>) {
                      // Показываем диалог с индикатором
                      return const AlertDialog(
                        title: Text("Загрузка профиля"),
                        content: SizedBox(
                          width: 400,
                          height: 450,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      );
                    }
                    if (state is DataError<UserEntity>) {
                      // Показываем ошибку с кнопкой закрыть
                      return AlertDialog(
                        title: const Text("Ошибка"),
                        content: Text(state.message),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("Закрыть"),
                          ),
                        ],
                      );
                    }
                    if (state is DataLoaded<UserEntity>) {
                      final user = state.data;
                      return BlocBuilder<NeuroCubit,
                          DataState<List<NeuroEntity>>>(
                        builder: (context, neuroState) {
                          if (neuroState is DataLoading<List<NeuroEntity>>) {
                            return const AlertDialog(
                              title: Text("Загрузка нейросетей"),
                              content: SizedBox(
                                height: 100,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              ),
                            );
                          }
                          if (neuroState is DataError<List<NeuroEntity>>) {
                            return AlertDialog(
                              title: const Text("Ошибка"),
                              content: Text(neuroState.message),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text("Закрыть"),
                                ),
                              ],
                            );
                          }
                          if (neuroState is DataLoaded<List<NeuroEntity>>) {
                            final List<NeuroModel> neuroList =
                                neuroState.data.cast<NeuroModel>();

                            final models =
                                neuroList;
                            final current = neuroList
                                .firstWhere(
                                    (e) => e.id == user.standartModelUrild,
                                    orElse: () => neuroList.first)
                                .id;

                            return WidgetUserSettings(
                              userEntity: user,
                              selectedModelId: current,
                              availableModels: models,
                              onSave: (updatedData) {
                                Navigator.of(context).pop();
                                // …
                              },
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              );
            },
          ),

          // Кнопка открытия виджета чат-ботов
          IconButton(
            icon: const Icon(Icons.android),
            onPressed: () {
              showAdaptiveDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return const Dialog(
                    child: SizedBox(
                      width: 600,
                      child: WidgetChatBots(),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
