import 'package:flutter/material.dart';
import 'package:twake/config/image_path.dart';
import 'package:twake/repositories/badges_repository.dart';
import 'package:twake/widgets/common/badges.dart';
import 'package:twake/widgets/common/image_widget.dart';
import 'package:twake/widgets/common/twake_button.dart';

typedef OnWorkspaceDrawerTileTap = void Function();

class WorkspaceDrawerTile extends StatelessWidget {
  final bool isSelected;
  final String? logo;
  final String? name;
  final OnWorkspaceDrawerTileTap? onWorkspaceDrawerTileTap;
  final String? workspaceId;

  const WorkspaceDrawerTile({
    required this.isSelected,
    this.onWorkspaceDrawerTileTap,
    this.logo,
    this.name,
    this.workspaceId,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return TwakeButton(
      onTap: onWorkspaceDrawerTileTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                isSelected
                    ? Image.asset(
                        imageSelectedTile,
                        width: 6,
                        height: 44,
                      )
                    : SizedBox(
                        width: 6,
                        height: 44,
                      ),
                SizedBox(width: 16.0),
                ImageWidget(
                  imageType: ImageType.common,
                  imageUrl: logo ?? '',
                  name: name ?? '',
                  size: 44,
                  backgroundColor: Color(0xfff5f5f5),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    name ?? '',
                    style: TextStyle(
                      color: Color(0xff000000),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                BadgesCount(type: BadgeType.workspace, id: workspaceId!),
                SizedBox(width: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
