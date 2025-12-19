import 'package:flutter/material.dart';

class WorkoutVideosSection extends StatelessWidget {
  const WorkoutVideosSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> newsItems = [
      {
        'image': 'https://picsum.photos/200/120?random=1',
        'title': 'Morning Stretch Routine',
        'desc': 'Start your day with calm and energy.',
      },
      {
        'image': 'https://picsum.photos/200/120?random=2',
        'title': 'HIIT Blast',
        'desc': 'Quick 15-min session to burn fat.',
      },
      {
        'image': 'https://picsum.photos/200/120?random=3',
        'title': 'Yoga Focus',
        'desc': 'Improve flexibility and posture.',
      },
      {
        'image': 'https://picsum.photos/200/120?random=6',
        'title': 'Morning Stretch Routine',
        'desc': 'Start your day with calm and energy.',
      },
      {
        'image': 'https://picsum.photos/200/120?random=7',
        'title': 'HIIT Blast',
        'desc': 'Quick 15-min session to burn fat.',
      },
      {
        'image': 'https://picsum.photos/200/120?random=8',
        'title': 'Yoga Focus',
        'desc': 'Improve flexibility and posture.',
      },
      {
        'image': 'https://picsum.photos/200/120?random=4',
        'title': 'Morning Stretch Routine',
        'desc': 'Start your day with calm and energy.',
      },
      {
        'image': 'https://picsum.photos/200/120?random=5',
        'title': 'HIIT Blast',
        'desc': 'Quick 15-min session to burn fat.',
      },
      {
        'image': 'https://picsum.photos/200/120?random=6',
        'title': 'Yoga Focus',
        'desc': 'Improve flexibility and posture.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Posts",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 260,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.2,
            ),
            itemCount: newsItems.length,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemBuilder: (context, index) {
              final item = newsItems[index];
              return _NewsCard(
                imageUrl: item['image']!,
                title: item['title']!,
                description: item['desc']!,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _NewsCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  const _NewsCard({
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(imageUrl,
                width: double.infinity, height: 80, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
