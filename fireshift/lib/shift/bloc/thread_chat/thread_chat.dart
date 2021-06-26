import 'package:equatable/equatable.dart';
import 'package:fireshift/shift/entities/support_thread.dart';
import 'package:fireshift/shift/repositories/support/support_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ThreadChatState extends Equatable {
  @override
  List<Object> get props => [];
}

class ThreadChatLoaded extends ThreadChatState {
  final SupportThread thread;

  ThreadChatLoaded(this.thread);

  @override
  List<Object> get props => [thread];

  @override
  String toString() => 'ThreadChatLoaded { thread: $thread }';
}

class ThreadChatNotLoaded extends ThreadChatState {}

class ThreadChatBloc extends Bloc<ThreadChatEvent, ThreadChatState> {
  final SupportRepository supportRepository;

  ThreadChatBloc({this.supportRepository}) : super(ThreadChatNotLoaded());

  @override
  Stream<ThreadChatState> mapEventToState(ThreadChatEvent event) async* {
    if (event is LoadThread) {
      yield* _mapLoadThreadContentsToState(event);
    } else if (event is ThreadUpdated) {
      yield* _mapThreadUpdateToState(event);
    } else if (event is ThreadInfoUpdated) {
      yield* _mapThreadInfoUpdateToState(event);
    } else if (event is AddThreadMessage) {
      yield* _mapAddThreadMessageToState(event);
    } else if (event is ArchiveThread) {
      yield* _mapArchiveThreadToState(event);
    } else if (event is StarThread) {
      yield* _mapStarThreadToState(event);
    } else if (event is MarkThreadRead) {
      yield* _mapMarkThreadReadToState(event);
    }
  }

  Stream<ThreadChatState> _mapLoadThreadContentsToState(
      LoadThread event) async* {
    var thread = await supportRepository.fetchThread(event.threadId);
    add(ThreadUpdated(thread));
  }

  Stream<ThreadChatState> _mapThreadUpdateToState(ThreadUpdated event) async* {
    yield ThreadChatLoaded(event.thread);
  }

  Stream<ThreadChatState> _mapThreadInfoUpdateToState(
      ThreadInfoUpdated event) async* {
    var currentState = state;
    if (currentState is ThreadChatLoaded) {
      yield ThreadChatLoaded(currentState.thread.copy(info: event.thread));
    }
  }

  Stream<ThreadChatState> _mapAddThreadMessageToState(
      AddThreadMessage event) async* {
    var thread = await supportRepository.addThreadMessage(
        event.threadOwnerId, event.message);
    add(ThreadUpdated(thread));
  }

  Stream<ThreadChatState> _mapArchiveThreadToState(ArchiveThread event) async* {
    var thread = await supportRepository.archive(event.threadOwnerId, event.archive);
    add(ThreadInfoUpdated(thread));
  }

  Stream<ThreadChatState> _mapStarThreadToState(StarThread event) async* {
    var thread = await supportRepository.star(event.threadOwnerId, event.star);
    add(ThreadInfoUpdated(thread));
  }

  Stream<ThreadChatState> _mapMarkThreadReadToState(
      MarkThreadRead event) async* {
    var thread = await supportRepository.markRead(event.threadOwnerId, event.read);
    add(ThreadInfoUpdated(thread));
  }
}

abstract class ThreadChatEvent extends Equatable {
  const ThreadChatEvent();

  @override
  List<Object> get props => [];
}

class LoadThread extends ThreadChatEvent {
  final String threadId;

  LoadThread(this.threadId);

  @override
  List<Object> get props => [threadId];
}

class AddThreadMessage extends ThreadChatEvent {
  final String threadOwnerId;
  final String message;

  AddThreadMessage(this.threadOwnerId, this.message);

  @override
  List<Object> get props => [threadOwnerId, message];
}

class ArchiveThread extends ThreadChatEvent {
  final String threadOwnerId;
  final bool archive;

  ArchiveThread(this.threadOwnerId, this.archive);

  @override
  List<Object> get props => [threadOwnerId, archive];
}

class StarThread extends ThreadChatEvent {
  final String threadOwnerId;
  final bool star;

  StarThread(this.threadOwnerId, this.star);

  @override
  List<Object> get props => [threadOwnerId, star];
}

class MarkThreadRead extends ThreadChatEvent {
  final String threadOwnerId;
  final bool read;

  MarkThreadRead(this.threadOwnerId, this.read);

  @override
  List<Object> get props => [threadOwnerId, read];
}

class ThreadUpdated extends ThreadChatEvent {
  final SupportThread thread;

  const ThreadUpdated(this.thread);

  @override
  List<Object> get props => [thread];

  @override
  String toString() => 'ThreadUpdated { thread: $thread }';
}

class ThreadInfoUpdated extends ThreadChatEvent {
  final SupportThreadInfo thread;

  const ThreadInfoUpdated(this.thread);

  @override
  List<Object> get props => [thread];

  @override
  String toString() => 'ThreadInfoUpdated { thread: $thread }';
}
