import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twake/blocs/workspaces_bloc.dart';
import 'package:twake/config/dimensions_config.dart';
import 'package:twake/widgets/common/image_avatar.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const MainAppBar({Key key, this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0.0,
      leading: InkWell(
        onTap: () => scaffoldKey.currentState.openDrawer(),
        child: Image.asset('assets/images/menu.png'),
      ),
      backgroundColor: Colors.white,
      toolbarHeight: Dim.heightPercent(
        (kToolbarHeight * 0.15).round(),
      ),
      // taking into account current appBar height to calculate a new one
      title: BlocBuilder<WorkspacesBloc, WorkspaceState>(builder: (ctx, state) {
        if (state is WorkspacesLoaded)
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: ImageAvatar(state.selected.logo),
            title: Text(
              state.selected.name,
              style: Theme.of(context).textTheme.headline6,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          );
        else
          return CircularProgressIndicator();
      }),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
