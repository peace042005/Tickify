import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  final List<dynamic> images;
  final double height;
  final double borderRadius;

  const ImageCarousel({
    super.key,
    required this.images,
    this.height = 280,
    this.borderRadius = 16,
  });

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showImageViewer(BuildContext context, int initialIndex) {
    List<String> imageUrls = widget.images
        .map((image) => image.url?.toString() ?? '')
        .where((url) => url.isNotEmpty)
        .toList();

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withOpacity(0.95),
        pageBuilder: (_, __, ___) => ModernImageViewer(
          imageUrls: imageUrls,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main Carousel
        ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: SizedBox(
            height: widget.height,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                if (!_isAnimating) {
                  setState(() => _currentPage = index);
                }
              },
              itemBuilder: (context, index) => Hero(
                tag: 'image_$index',
                child: GestureDetector(
                  onTap: () => _showImageViewer(context, index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.images[index].url ?? '',
                      fit: BoxFit.cover,
                      memCacheWidth: 800,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Theme.of(context).colorScheme.errorContainer,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image_rounded,
                              size: 48,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Image non disponible',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Navigation Arrows
        if (widget.images.length > 1)
          Positioned.fill(
            child: Row(
              children: [
                _buildNavigationButton(
                  icon: Icons.chevron_left_rounded,
                  onPressed: () {
                    if (_currentPage > 0) {
                      _isAnimating = true;
                      _pageController
                          .previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          )
                          .then((_) => _isAnimating = false);
                    }
                  },
                ),
                const Spacer(),
                _buildNavigationButton(
                  icon: Icons.chevron_right_rounded,
                  onPressed: () {
                    if (_currentPage < widget.images.length - 1) {
                      _isAnimating = true;
                      _pageController
                          .nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          )
                          .then((_) => _isAnimating = false);
                    }
                  },
                ),
              ],
            ),
          ),

        // Page Indicator
        if (widget.images.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (index) => TweenAnimationBuilder<double>(
                  tween: Tween(
                    begin: 0.0,
                    end: _currentPage == index ? 1.0 : 0.0,
                  ),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, value, _) {
                    return Container(
                      width: 8.0 + (value * 8.0),
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: Color.lerp(
                          Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.3),
                          Theme.of(context).colorScheme.primary,
                          value,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
              ),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class ModernImageViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const ModernImageViewer({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  State<ModernImageViewer> createState() => _ModernImageViewerState();
}

class _ModernImageViewerState extends State<ModernImageViewer> {
  late final PageController _pageController;
  late int _currentIndex;
  final _transformationController = TransformationController();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Images
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) => Hero(
              tag: 'image_$index',
              child: InteractiveViewer(
                transformationController: _transformationController,
                minScale: 0.5,
                maxScale: 4.0,
                onInteractionEnd: (_) {
                  if (_transformationController.value != Matrix4.identity()) {
                    _transformationController.value = Matrix4.identity();
                  }
                },
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrls[index],
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.broken_image,
                          color: Colors.white, size: 64),
                      const SizedBox(height: 16),
                      Text(
                        'Image non disponible',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Top Bar
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Counter
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${_currentIndex + 1}/${widget.imageUrls.length}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  // Close Button
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
