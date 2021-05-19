import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_client/client/support_request_repository.dart';

import 'app.dart';

class ChatState extends Equatable {
  final List<SupportMessage> messages;

  ChatState(this.messages);

  @override
  List<Object> get props => [ messages ];
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SupportRequestRepository supportRequestRepository;

  ChatBloc({this.supportRequestRepository}) : super(ChatState(List.empty()));

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is ChatLoadedEvent) {
      yield* _mapChatLoadedToState(event);
    } else if (event is AddMessageEvent) {
      yield* _mapChatMessageAddedToState(event);
    } else if (event is ChatFetchEvent) {
      yield* _mapChatFetchToState(event);
    }
  }

  Stream<ChatState> _mapChatFetchToState(ChatFetchEvent event) async* {
    final messages = await supportRequestRepository.fetchMessages();
    add(ChatLoadedEvent(messages));
  }

  Stream<ChatState> _mapChatLoadedToState(ChatLoadedEvent event) async* {
    yield ChatState(event.messages);
  }

  Stream<ChatState> _mapChatMessageAddedToState(AddMessageEvent event) async* {
    await supportRequestRepository.addMessage(event.message);
    var newList = state.messages.toList();
    newList.add(event.message);
    yield ChatState(newList);
  }
}

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ChatFetchEvent extends ChatEvent {
  const ChatFetchEvent();

  @override
  List<Object> get props => [];
}

class ChatLoadedEvent extends ChatEvent {
  final List<SupportMessage> messages;

  ChatLoadedEvent(this.messages);

  @override
  List<Object> get props => [messages];
}

class AddMessageEvent extends ChatEvent {
  final SupportMessage message;

  AddMessageEvent(this.message);

  @override
  List<Object> get props => [message];
}

class LoggableBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    logger.i(event);
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    logger.i(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    logger.e(error);
    super.onError(bloc, error, stackTrace);
  }
}
