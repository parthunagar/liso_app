import 'package:flutter/material.dart';
import 'package:sharish/borrows/borrows.dart';
import 'package:sharish/borrows/widgets/leading_icon.dart';
import 'package:sharish/utils/colors_util.dart';

class PostListItem extends StatelessWidget {
  const PostListItem({Key? key, required this.post}) : super(key: key);

  final Borrow post;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    String getInitials(String title) => title.isNotEmpty
        ? title.trim().split(' ').map((l) => l[0]).take(2).join()
        : '';
    // return ListTile(
    //   leading: Text('${post.id}', style: textTheme.caption),
    //   title: Text(post.book.title),
    //   isThreeLine: true,
    //   subtitle: Text(post.libraryName), //Text(post.body)
    //   dense: true,
    // );
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        LeadingIcon(
          leadingName: getInitials(post.book.title), // 'MJ',
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.book.title,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: AppColor.purple,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                post.libraryName,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: AppColor.greyFont, fontWeight: FontWeight.normal),
              ),
              // const SizedBox(height: 6),
            ],
          ),
        )
      ],
    );
  }
}
