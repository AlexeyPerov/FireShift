import 'package:flutter/material.dart';

class SupportThreadInfo {
  SupportThreadInfo(
      {this.id,
        this.project,
        this.senderId,
        this.receiverId,
        this.starred,
        this.unread,
        this.archived,
        this.subject,
        this.updateTime,
        this.preview,
        this.contentsId});

  SupportThreadInfo.clone(SupportThreadInfo ticketInfo)
      : this(
      id: ticketInfo.id,
      project: ticketInfo.project,
      senderId: ticketInfo.senderId,
      receiverId: ticketInfo.receiverId,
      starred: ticketInfo.starred,
      unread: ticketInfo.unread,
      archived: ticketInfo.archived,
      subject: ticketInfo.subject,
      updateTime: ticketInfo.updateTime,
      preview: ticketInfo.preview,
      contentsId: ticketInfo.contentsId);

  SupportThreadInfo copy(
      {String id,
        String projectId,
        String senderId,
        String receiverId,
        bool starred,
        bool unread,
        bool archived,
        String subject,
        String updateTime,
        String preview,
        String contentsId}) =>
      SupportThreadInfo(
        id: id ?? this.id,
        project: projectId ?? this.project,
        senderId: senderId ?? this.senderId,
        receiverId: receiverId ?? this.receiverId,
        starred: starred ?? this.starred,
        unread: unread ?? this.unread,
        archived: archived ?? this.archived,
        subject: subject ?? this.subject,
        updateTime: updateTime ?? this.updateTime,
        preview: preview ?? this.preview,
        contentsId: contentsId ?? this.contentsId,
      );

  final String id;
  final String project;
  final String senderId;
  final String receiverId;
  final bool starred;
  final bool unread;
  final bool archived;
  final String subject;
  final String updateTime;
  final String preview;
  final String contentsId;
}

class SupportThreadContents {
  SupportThreadContents({this.id, this.messages});

  SupportThreadContents.clone(SupportThreadContents contents)
      : this(
      id: contents.id,
      messages:
      contents.messages.map((e) => SupportMessage.clone(e)).toList());

  final String id;
  final List<SupportMessage> messages;
}

class SupportMessage {
  SupportMessage({this.authorId, this.contents, this.time});

  SupportMessage.clone(SupportMessage message)
      : this(
      authorId: message.authorId,
      contents: message.contents,
      time: message.time);

  final String authorId;
  final String contents;
  final DateTime time;
}

class SupportThread {
  SupportThread({this.info, this.contents});

  SupportThread.clone(SupportThread ticket)
      : this(
      info: SupportThreadInfo.clone(ticket.info),
      contents: SupportThreadContents.clone(ticket.contents));

  SupportThread copy(
      {SupportThreadInfo info, SupportThreadContents contents}) =>
      SupportThread(
          info: info ?? this.info, contents: contents ?? this.contents);

  final SupportThreadInfo info;
  final SupportThreadContents contents;
}

class Filter {
  final String project;

  Filter({this.project});
}

@immutable
class FilteredThreads {
  final Filter filter;
  final List<SupportThreadInfo> threads;

  FilteredThreads({this.filter, this.threads});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FilteredThreads &&
              runtimeType == other.runtimeType &&
              filter == other.filter &&
              threads == other.threads;

  @override
  int get hashCode => filter.hashCode ^ threads.hashCode;

  FilteredThreads copy({Filter filter, List<SupportThreadInfo> threads}) =>
      FilteredThreads(
          filter: filter ?? this.filter,
          threads: threads ?? List<SupportThreadInfo>.from(this.threads));
}
