import 'package:flutter/material.dart';
import 'package:twake/config/dimensions_config.dart';
import 'package:twake/models/badge/badge.dart';
import 'package:twake/models/channel/channel.dart';
import 'package:twake/utils/dateformatter.dart';
import 'package:twake/widgets/common/badges.dart';
import 'package:twake/widgets/common/image_widget.dart';

typedef OnHomeChannelTileClick = void Function();

class HomeChannelTile extends StatelessWidget {
  final String title;
  final String? name;
  final String? content;
  final String? imageUrl;
  final List<Avatar> avatars;
  final int? dateTime;
  final OnHomeChannelTileClick? onHomeChannelTileClick;
  final String channelId;
  final bool isPrivate;
  final bool isDirect;

  const HomeChannelTile(
      {required this.title,
      this.name,
      this.content,
      this.imageUrl,
      this.dateTime,
      this.avatars = const [],
      this.onHomeChannelTileClick,
      required this.channelId,
      this.isPrivate = false,
      this.isDirect = false})
      : super();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onHomeChannelTileClick,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.only(left: 12, top: 12, bottom: 12),
        child: Row(
          children: [
            ImageWidget(
              imageType: isDirect ? ImageType.common : ImageType.channel,
              imageUrl: imageUrl ?? '',
              isPrivate: isPrivate,
              name: title,
              size: 54,
              avatars: avatars,
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                        Text(
                          DateFormatter.getVerboseTimeForHomeTile(dateTime),
                          style: TextStyle(
                            color: Color(0xffc2c6cc),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: Dim.widthPercent(70),
                            ),
                            child: Text(
                              name ?? 'This channel is empty',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: Color(0xb2000000),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                          Spacer(),
                          BadgesCount(
                            type: BadgeType.channel,
                            id: channelId,
                            key: ValueKey(channelId),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        content ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: Color(0x7f000000),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
