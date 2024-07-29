import 'package:flutter/material.dart';
import 'package:sharish/books/books.dart';
import 'package:sharish/borrows/widgets/leading_icon.dart';
import 'package:sharish/utils/colors_util.dart';

class BookListItem extends StatelessWidget {
  const BookListItem({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Book post;

  bool? checkStatus(String status) {
    if (status == 'available') {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    String getInitials(String title) => title.isNotEmpty
        ? title.trim().split(' ').map((l) => l[0]).take(2).join()
        : '';

    // return ListTile(
    //   title: Text(post.title),
    //   isThreeLine: true,
    //   subtitle: Text(post.status),
    //   dense: true,
    // );
    return Row(
      children: [
        LeadingIcon(
          leadingName: getInitials(post.title),
          borderColor:
              checkStatus(post.status)! ? AppColor.purple : AppColor.greyFont,
          TextColor:
              checkStatus(post.status)! ? AppColor.purple : AppColor.greyFont,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: checkStatus(post.status)!
                          ? AppColor.purple
                          : AppColor.greyFont,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                post.status,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: checkStatus(post.status)!
                          ? AppColor.green
                          : AppColor.greyFont,
                      fontWeight: checkStatus(post.status)!
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
              )
            ],
          ),
        )
      ],
    );
  }
}
