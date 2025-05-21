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
  final ValueChanged<Map<String, dynamic>> onChatCreateSettings;

  const MainAppBar({
    super.key,
    required this.onMenuPressed,
    required this.onPromtsPressed,
    required this.onChatCreateSettings,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 12),
      child: Container(
        margin: EdgeInsets.zero,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _buildStyledIconButton(
                  icon: Icons.menu,
                  tooltip: 'Меню',
                  onTap: onMenuPressed,
                ),
                const SizedBox(width: 8),
                _buildStyledTextButton("Promts", onPromtsPressed),
                const SizedBox(width: 8),
                const Expanded(
                  child: Center(
                      // child: _StyledLabel("Обычный чат-бот"),
                      ),
                ),
                _buildStyledIconButton(
                  icon: Icons.person,
                  tooltip: 'Профиль',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) =>
                          BlocBuilder<UserCubit, DataState<UserEntity>>(
                        builder: (context, state) {
                          if (state is DataLoading<UserEntity>) {
                            return Dialog(
                              backgroundColor: Colors.white.withOpacity(0.05),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                constraints: const BoxConstraints(
                                    maxWidth: 420, maxHeight: 300),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.12)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      blurRadius: 20,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Загрузка профиля",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 32),
                                    SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                    ),
                                  ],
                                ),
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
                                if (neuroState
                                    is DataLoading<List<NeuroEntity>>) {
                                  return const AlertDialog(
                                    title: Text("Загрузка нейросетей"),
                                    content: SizedBox(
                                      height: 100,
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    ),
                                  );
                                }
                                if (neuroState
                                    is DataError<List<NeuroEntity>>) {
                                  return AlertDialog(
                                    title: const Text("Ошибка"),
                                    content: Text(neuroState.message),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text("Закрыть"),
                                      ),
                                    ],
                                  );
                                }
                                if (neuroState
                                    is DataLoaded<List<NeuroEntity>>) {
                                  final List<NeuroModel> neuroList =
                                      neuroState.data.cast<NeuroModel>();
                                  final models = neuroList;
                                  final current = neuroList
                                      .firstWhere(
                                          (e) =>
                                              e.id == user.standartModelUriId,
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
                _buildStyledIconButton(
                  icon: Icons.android,
                  tooltip: 'Чат-боты',
                  onTap: () {
                    showAdaptiveDialog(
                      context: context,
                      builder: (dialogCtx) {
                        return Dialog(
                          child: SizedBox(
                            width: 600,
                            child: WidgetChatBots(
                              onBotSelected: (settings) {
                                onChatCreateSettings(settings); // кладём всё в _draft
                                Navigator.of(dialogCtx)
                                    .pop(); // закрываем список ботов
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
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
    final maxWidth = MediaQuery.of(context).size.width * 0.3;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
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
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
