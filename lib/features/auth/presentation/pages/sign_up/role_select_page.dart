import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/core/widgets/app_elevated_button.dart';
import 'package:bookshelf_mobile/core/widgets/role_card.dart';
import 'package:bookshelf_mobile/core/widgets/step_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoleSelectPage extends StatefulWidget {
  const RoleSelectPage({super.key});

  @override
  State<RoleSelectPage> createState() => _RoleSelectPageState();
}

class _RoleSelectPageState extends State<RoleSelectPage> {
  bool? _isAdmin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const StepAppBar(),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text('회원가입',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              const Text('회원가입하고 책마루에 가입하세요',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF777777))),
              const SizedBox(height: 71),
              Row(
                children: [
                  Expanded(
                    child: RoleCard(
                      rolePicture: 'assets/images/student.png',
                      role: '학생',
                      selected: _isAdmin == false,
                      onTap: () => setState(() => _isAdmin = false),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: RoleCard(
                      rolePicture: 'assets/images/manager.png',
                      role: '관리자',
                      selected: _isAdmin == true,
                      onTap: () => setState(() => _isAdmin = true),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              AppElevatedButton(
                onPressed: _isAdmin != null
                    ? () => context.push(
                          AppRoutes.registerEmail,
                          extra: _isAdmin,
                        )
                    : null,
                label: '다음',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
