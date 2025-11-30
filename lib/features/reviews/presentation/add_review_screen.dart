import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/supabase_provider.dart';
import '../domain/review.dart';
import '../data/reviews_repository.dart';
import '../application/reviews_controller.dart';
import 'package:winepool_final/features/offers/application/offer_details_controller.dart';

class AddReviewScreen extends ConsumerStatefulWidget {
  final String wineId;
  final String userId;
  final String? offerId; // Добавляем необязательный параметр offerId

  const AddReviewScreen({
    Key? key,
    required this.wineId,
    required this.userId,
    this.offerId, // Параметр необязательный, чтобы не ломать существующий функционал
  }) : super(key: key);

  @override
  ConsumerState<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends ConsumerState<AddReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  double _rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить отзыв'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Оцените вино:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Center(
                child: RatingBar(
                  rating: _rating,
                  onRatingChanged: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Комментарий:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: 'Напишите ваш отзыв о вине...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitReview,
                  child: const Text('Отправить отзыв'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitReview() async {
    if (_rating == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, поставьте оценку')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      try {
        final review = Review(
          wineId: widget.wineId,
          userId: widget.userId,
          rating: _rating,
          text: _textController.text.isEmpty ? null : _textController.text,
        );

        final supabaseClient = ref.watch(supabaseClientProvider);
        final repository = ReviewsRepository(supabaseClient);
        await repository.addReview(review);
        // Обновляем провайдер отзывов
        ref.invalidate(reviewsControllerProvider(widget.wineId));
        
        // Если был передан offerId, инвалидируем провайдер деталей предложения
        if (widget.offerId != null) {
          ref.invalidate(offerDetailsControllerProvider(widget.offerId!));
        }
        
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Отзыв успешно добавлен!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка при добавлении отзыва: $e')),
          );
        }
      }
    }
  }
}

class RatingBar extends StatefulWidget {
  final double rating;
  final Function(double) onRatingChanged;

  const RatingBar({
    Key? key,
    required this.rating,
    required this.onRatingChanged,
  }) : super(key: key);

  @override
  State<RatingBar> createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  late double _selectedRating;

  @override
  void initState() {
    super.initState();
    _selectedRating = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedRating = index + 1.toDouble();
            });
            widget.onRatingChanged(_selectedRating);
          },
          child: Icon(
            index < _selectedRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 40,
          ),
        );
      }),
    );
  }
}