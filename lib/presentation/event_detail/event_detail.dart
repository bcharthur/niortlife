import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons_section.dart';
import './widgets/event_hero_image.dart';
import './widgets/event_info_section.dart';
import './widgets/expandable_description.dart';
import './widgets/related_events_carousel.dart';
import './widgets/social_proof_section.dart';
import './widgets/venue_map_widget.dart';

class EventDetail extends StatefulWidget {
  const EventDetail({super.key});

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  final ScrollController _scrollController = ScrollController();
  bool _showAppBar = false;

  // Mock event data
  final Map<String, dynamic> eventData = {
    "id": 1,
    "title": "Festival de Musique Électronique - Niort Summer Beats",
    "description":
        """Rejoignez-nous pour une soirée inoubliable de musique électronique au cœur de Niort ! Le Festival Summer Beats présente les meilleurs DJs locaux et internationaux dans une ambiance festive et conviviale.

Au programme : sets électro, house, techno et bien plus encore. Bars et food trucks sur place pour vous restaurer tout au long de la soirée. Ambiance garantie jusqu'au bout de la nuit !

Cet événement s'adresse aux amateurs de musique électronique de tous horizons. Venez danser, rencontrer de nouvelles personnes et profiter d'une soirée exceptionnelle dans un cadre unique.

Dress code : tenue décontractée recommandée. Vestiaire disponible sur place.""",
    "date": "Samedi 26 Août 2025",
    "time": "20h00 - 02h00",
    "venue": "Parc de la Brèche",
    "price": "15€ - 25€",
    "ageRestriction": "18+ uniquement",
    "hasStudentDiscount": true,
    "hasTickets": true,
    "image":
        "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    "category": "Musique",
  };

  final Map<String, dynamic> venueData = {
    "name": "Parc de la Brèche",
    "address": "Avenue de la Brèche, 79000 Niort",
    "latitude": 46.3236,
    "longitude": -0.4594,
  };

  final Map<String, dynamic> socialData = {
    "attendeeCount": 247,
    "friendsAttending": [
      {
        "id": 1,
        "name": "Marie Dubois",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      },
      {
        "id": 2,
        "name": "Thomas Martin",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      },
      {
        "id": 3,
        "name": "Sophie Laurent",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      },
      {
        "id": 4,
        "name": "Lucas Bernard",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      },
    ],
  };

  final List<Map<String, dynamic>> relatedEvents = [
    {
      "id": 2,
      "title": "Concert Jazz au Moulin du Roc",
      "date": "Vendredi 1er Septembre",
      "venue": "Moulin du Roc",
      "price": "12€",
      "category": "Jazz",
      "image":
          "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 3,
      "title": "Soirée Étudiante - Rentrée 2025",
      "date": "Jeudi 7 Septembre",
      "venue": "Le Camé",
      "price": "Gratuit",
      "category": "Soirée",
      "image":
          "https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 4,
      "title": "Marché Nocturne de Niort",
      "date": "Samedi 9 Septembre",
      "venue": "Place du Pilori",
      "price": "Gratuit",
      "category": "Culture",
      "image":
          "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final shouldShowAppBar = _scrollController.offset > 200;
    if (shouldShowAppBar != _showAppBar) {
      setState(() => _showAppBar = shouldShowAppBar);
    }
  }

  void _handleBackPressed() {
    Navigator.pop(context);
  }

  void _handleSharePressed() {
    _showShareOptions();
  }

  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Partager cet événement',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(
                    'message', 'Messages', () => _shareViaMessages()),
                _buildShareOption('link', 'Copier le lien', () => _copyLink()),
                _buildShareOption(
                    'more_horiz', 'Plus', () => _showMoreOptions()),
              ],
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(String iconName, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  void _shareViaMessages() {
    Navigator.pop(context);
    Fluttertoast.showToast(
      msg: "Partage via messages - Fonctionnalité à venir",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _copyLink() {
    Navigator.pop(context);
    Clipboard.setData(
        const ClipboardData(text: "https://niortlife.fr/events/1"));
    Fluttertoast.showToast(
      msg: "Lien copié dans le presse-papiers",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _showMoreOptions() {
    Navigator.pop(context);
    Fluttertoast.showToast(
      msg: "Plus d'options de partage - Fonctionnalité à venir",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleGetDirections() {
    Fluttertoast.showToast(
      msg: "Ouverture de l'application de navigation...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleAddToCalendar() {
    Fluttertoast.showToast(
      msg: "Événement ajouté au calendrier",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleShareEvent() {
    _showShareOptions();
  }

  void _handleBuyTickets() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Achat de billets',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        content: Text(
          'Vous allez être redirigé vers notre plateforme de billetterie sécurisée.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: "Redirection vers la billetterie...",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            },
            child: const Text('Continuer'),
          ),
        ],
      ),
    );
  }

  void _handleRelatedEventTap(Map<String, dynamic> event) {
    Navigator.pushNamed(context, '/event-detail');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _showAppBar
          ? AppBar(
              backgroundColor: AppTheme.lightTheme.colorScheme.surface
                  .withValues(alpha: 0.95),
              elevation: 1,
              leading: IconButton(
                onPressed: _handleBackPressed,
                icon: CustomIconWidget(
                  iconName: 'arrow_back_ios',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 20,
                ),
              ),
              title: Text(
                eventData['title'] as String,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              actions: [
                IconButton(
                  onPressed: _handleSharePressed,
                  icon: CustomIconWidget(
                    iconName: 'share',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 20,
                  ),
                ),
              ],
            )
          : null,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Hero image
          SliverToBoxAdapter(
            child: EventHeroImage(
              imageUrl: eventData['image'] as String,
              onBackPressed: _handleBackPressed,
              onSharePressed: _handleSharePressed,
            ),
          ),

          // Event content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event info
                EventInfoSection(eventData: eventData),

                // Description
                ExpandableDescription(
                  description: eventData['description'] as String,
                ),

                // Venue map
                VenueMapWidget(
                  venueData: venueData,
                  onGetDirections: _handleGetDirections,
                ),

                // Social proof
                SocialProofSection(socialData: socialData),

                // Action buttons
                ActionButtonsSection(
                  onAddToCalendar: _handleAddToCalendar,
                  onShareEvent: _handleShareEvent,
                  onBuyTickets: eventData['hasTickets'] == true
                      ? _handleBuyTickets
                      : null,
                  hasTickets: eventData['hasTickets'] == true,
                ),

                // Related events
                RelatedEventsCarousel(
                  relatedEvents: relatedEvents,
                  onEventTap: _handleRelatedEventTap,
                ),

                SizedBox(height: 4.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
