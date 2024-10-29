import '../../core/index.dart';

class CategoryTitleWidget extends StatelessWidget {
  final BuildContext context;
  final String title;
  final Widget screen;

  const CategoryTitleWidget({
    super.key,
    required this.context,
    required this.title,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => screen,
                ),
              );
            },
            icon: const Icon(Icons.arrow_forward),
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
