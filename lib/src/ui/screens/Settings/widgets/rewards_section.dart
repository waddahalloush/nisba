// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/ui/screens/Settings/app_setting_controller.dart';

/// قسم المكافآت - تمرير أفقي
class RewardsSection extends StatelessWidget {
  final List<RewardModel> rewards;

  const RewardsSection({super.key, required this.rewards});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // صف العنوان + عرض الكل
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'مكافآت',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Text(
                    'عرض الكل',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 10.sp,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 14.sp,
                    color: cs.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        // قائمة أفقية
        SizedBox(
          height: 110.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            primary: true,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: rewards.length + 1, // +1 لبطاقة "المزيد من المكافآت"
            itemBuilder: (_, i) {
              if (i == 0) return const _MoreRewardsCard();
              return _RewardCard(
                key: ValueKey('reward_${i - 1}'),
                reward: rewards[i - 1],
              );
            },
          ),
        ),
      ],
    );
  }
}

/// بطاقة "المزيد من المكافآت" الثابتة
class _MoreRewardsCard extends StatelessWidget {
  const _MoreRewardsCard();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 70.w,
      margin: EdgeInsets.only(left: 3.w),
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: BorderRadius.circular(14.r),
      ),
      padding: EdgeInsets.all(10.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.gift4, size: 32.sp, color: Colors.white),
          SizedBox(height: 8.h),
          Text(
            'المزيد من\nالمكافآت',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// بطاقة مكافأة فردية
class _RewardCard extends StatelessWidget {
  final RewardModel reward;

  const _RewardCard({super.key, required this.reward});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      width: 87.w,
      margin: EdgeInsets.only(left: 3.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),

        image: DecorationImage(
          image: AssetImage(reward.icon),
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.only(top: 10.r, left: 10.r, right: 10.r, bottom: 2.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            reward.title,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
              fontSize: 9.sp,
            ),
          ),
          Text(
            reward.subtitle,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.primary,
              fontSize: 18.sp,
            ),
          ),
          reward.isPoints
              ? Text(
                  "نقطة",
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                    fontSize: 9.sp,
                  ),
                )
              : const SizedBox(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: Colors.white,
            ),
            child: Text(
              reward.buttonLabel,
              style: TextStyle(
                fontSize: 8.sp,
                color: reward.bgColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
