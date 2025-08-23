// is_changed_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class IsChangedCubit extends Cubit<bool> {
  IsChangedCubit() : super(false);

  bool isChanged = false;
}