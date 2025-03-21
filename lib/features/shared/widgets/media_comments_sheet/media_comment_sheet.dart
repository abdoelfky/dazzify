import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/shared/data/models/media_model.dart';
import 'package:dazzify/features/shared/logic/comments/comments_bloc.dart';
import 'package:dazzify/features/shared/widgets/dazzify_sheet_body.dart';
import 'package:dazzify/features/shared/widgets/media_comments_sheet/components/comments_page.dart';
import 'package:dazzify/features/shared/widgets/media_comments_sheet/components/replies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MediaCommentsSheet extends StatefulWidget {
  final MediaModel media;

  const MediaCommentsSheet({super.key, required this.media});

  @override
  State<MediaCommentsSheet> createState() => _MediaCommentsSheetState();
}

class _MediaCommentsSheetState extends State<MediaCommentsSheet> {
  final PageController _pageController = PageController();
  late final CommentsBloc _commentsBloc;

  @override
  void initState() {
    _commentsBloc = context.read<CommentsBloc>();
    super.initState();
  }

  void _onReplyTab(int parentIndex) {
    _commentsBloc.add(AssignParentIndexEvent(parentIndex: parentIndex));

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _onBackTab() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DazzifySheetBody(
      titleBottomPadding: 0,
      handlerColor: context.colorScheme.outline,
      enableBottomInsets: true,
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              CommentsPage(
                media: widget.media,
                onReplyTab: _onReplyTab,
              ),
              RepliesPage(
                media: widget.media,
                onBackTab: _onBackTab,
              )
            ],
          ),
        ),
      ],
    );
  }
}
