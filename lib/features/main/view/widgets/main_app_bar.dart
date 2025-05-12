import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promts_application_1/core/cubits/data_cubit.dart';
import 'package:promts_application_1/features/neuro/cubits/neuro_cubit.dart';
import 'package:promts_application_1/features/neuro/data/models/neuro_model.dart';
import 'package:promts_application_1/features/neuro/domain/entities/neuro_entity.dart';
import 'package:promts_application_1/features/user/cubit/user_cubit.dart';
import 'package:promts_application_1/features/user/domain/entities/user_entity.dart';
import 'package:promts_application_1/features/user/view/widgets/user_settings.dart';
import '../../../chatbot/view/widgets/widget_chat_bots.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuPressed;
  final VoidCallback onPromtsPressed;

  const MainAppBar({
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
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        children: [
          // Меню-кнопка
          _buildStyledIconButton(
            icon: Icons.menu,
            tooltip: 'Меню',
            onTap: onMenuPressed,
          ),
          const SizedBox(width: 8),

          // Promts кнопка
          _buildStyledTextButton("Promts", onPromtsPressed),
          const SizedBox(width: 8),

          // Название чат-бота
          const Expanded(
            child: Center(
              child: _StyledLabel("Обычный чат-бот"),
            ),
          ),

          // Профиль
          _buildStyledIconButton(
            icon: Icons.person,
            tooltip: 'Профиль',
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => BlocBuilder<UserCubit, DataState<UserEntity>>(
                  builder: (context, state) {
                    if (state is DataLoading<UserEntity>) {
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
                            final models = neuroList;
                            final current = neuroList
                                .firstWhere(
                                    (e) => e.id == user.standartModelUriId,
                                    orElse: () => neuroList.first)
                                .id;
                            return UserSettings(
                              userEntity: user,
                              selectedModelId: current!,
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
          const SizedBox(width: 8),

          // Чат-боты
          _buildStyledIconButton(
            icon: Icons.android,
            tooltip: 'Чат-боты',
            onTap: () {
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

Widget _buildStyledIconButton({
  required IconData icon,
  required String tooltip,
  required VoidCallback onTap,
}) {
  return MouseRegion(
    onEnter: (_) => {},
    onExit: (_) => {},
    child: GestureDetector(
      onTap: onTap,
      child: Tooltip(
        message: tooltip,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(1, 1),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    ),
  );
}

Widget _buildStyledTextButton(String text, VoidCallback onTap) {
  return MouseRegion(
    onEnter: (_) => {},
    onExit: (_) => {},
    child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            color: Color.fromARGB(255, 235, 235, 235),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}

class _StyledLabel extends StatelessWidget {
  final String text;
  const _StyledLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white70,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
