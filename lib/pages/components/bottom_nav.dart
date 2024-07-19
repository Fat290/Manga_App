import 'package:doan_cs3/models/nav/nav_item_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({required this.navigationShell, Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
  final StatefulNavigationShell navigationShell;
}

class _BottomNavState extends State<BottomNav> {
  List<SMIBool> riveIconInputs = [];
  List<StateMachineController?> controllers = [];
  int selctedNavIndex = 0;

  void animateTheIcon(int index) {
     int newIndex = index==0 ? 0:index-1;
    riveIconInputs[newIndex].change(true);
    Future.delayed(
      const Duration(seconds: 1),
          () {
        riveIconInputs[newIndex].change(false);
      },
    );
  }
  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
  void riveOnInIt(Artboard artboard, {required String stateMachineName}) {
    StateMachineController? controller =
    StateMachineController.fromArtboard(artboard, stateMachineName);
    artboard.addController(controller!);
    controllers.add(controller);
    riveIconInputs.add(controller.findInput<bool>('active') as SMIBool);
  }
  @override
  void dispose() {
    for (var controller in controllers) {
      controller?.dispose();
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 28,vertical: 12),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                offset: const Offset(0,20),
                blurRadius: 30
            )
          ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
            bottomNavItems.length,
              (index) => GestureDetector(
            onTap: ()
            {
              setState(() {
                selctedNavIndex = index;
              });
                animateTheIcon(selctedNavIndex);
               _goBranch(selctedNavIndex);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBar(isActive: selctedNavIndex == index),
                SizedBox(
                  height: 28,
                  width: 36,
                  child: Opacity(
                    opacity: selctedNavIndex == index ? 1 : 0.5,
                    child: RiveAnimation.asset(
                      bottomNavItems[index].src,
                      artboard: bottomNavItems[index].artboard,
                      onInit: (artboard) {
                        riveOnInIt(artboard,
                            stateMachineName: bottomNavItems[index].stateMachineName);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class AnimatedBar extends StatelessWidget {
  const AnimatedBar({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      // margin: const EdgeInsets.only(bottom: 2),
      height: 4,
      width: isActive ? 20 : 0,
      decoration:  BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}