import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class ListSkeleton extends StatelessWidget {
  const ListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonListView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      item: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            const SkeletonAvatar(
              style: SkeletonAvatarStyle(
                width: 56,
                height: 56,
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: SkeletonParagraph(
                      style: const SkeletonParagraphStyle(
                        lines: 2,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SkeletonParagraph(
                      style: const SkeletonParagraphStyle(
                        lines: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
