import 'package:niortlife/features/map/data/repositories/poi_repository.dart';
import 'package:niortlife/features/map/data/repositories/poi_repository_mock.dart';
import 'package:niortlife/features/events/data/repositories/event_repository.dart';
import 'package:niortlife/features/events/data/repositories/event_repository_mock.dart';
import 'package:niortlife/features/discounts/data/repositories/discount_repository.dart';
import 'package:niortlife/features/discounts/data/repositories/discount_repository_mock.dart';
import 'package:niortlife/features/transport/data/repositories/transport_repository.dart';
import 'package:niortlife/features/transport/data/repositories/transport_repository_mock.dart';
import 'package:niortlife/features/nightlife/data/repositories/nightlife_repository.dart';
import 'package:niortlife/features/nightlife/data/repositories/nightlife_repository_mock.dart';

class Repos {
  static final POIRepository poi = POIRepositoryMock();
  static final EventRepository events = EventRepositoryMock();
  static final DiscountRepository discounts = DiscountRepositoryMock();
  static final TransportRepository transport = TransportRepositoryMock();
  static final NightlifeRepository nightlife = NightlifeRepositoryMock();
}
