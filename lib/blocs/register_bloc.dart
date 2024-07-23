import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:funny_chat/ui/constants/app_strings.dart';
import '../repositories/register_repository.dart';

part 'events/register_event.dart';
part 'state/register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterRepository _registerRepository;

  RegisterBloc(this._registerRepository) : super(RegisterInitial()) {
    on<RegisterButtonPressed>(_onRegisterButtonPressed);
  }

  Future<void> _onRegisterButtonPressed(RegisterButtonPressed event, Emitter<RegisterState> emit) async {
    if (event.username.isEmpty || event.password.isEmpty) {
      emit(const RegisterFailure(AppStrings.emptyFields));
      return;
    }

    emit(RegisterLoading());
    try {
      await _registerRepository.register(event.username, event.password);
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}
