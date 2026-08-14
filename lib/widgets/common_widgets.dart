
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 46});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF1677FF),
        borderRadius: BorderRadius.circular(size * .30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1677FF).withValues(alpha: .22),
            blurRadius: 18,
            offset: const Offset(0, 7),
          )
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        'T',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: size * .55,
          height: 1,
        ),
      ),
    );
  }
}

class SectionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const SectionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF3FF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: const Color(0xFF1677FF)),
              ),
              const Spacer(),
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w900, fontSize: 16)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: const TextStyle(
                      color: Colors.black54, fontSize: 11, height: 1.3)),
            ],
          ),
        ),
      ),
    );
  }
}
