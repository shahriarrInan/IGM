import 'package:igm/pages/home/controllers/home_controller.dart';
import 'package:refreshed/refreshed.dart';

class HomeBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.put(() => HomeController(), permanent: true)];
  }
}
