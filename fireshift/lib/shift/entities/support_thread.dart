const kAdminUserId = "0";

class SupportThreadInfo {
  SupportThreadInfo(
      {this.id,
      this.project,
      this.threadOwnerId,
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
            threadOwnerId: ticketInfo.threadOwnerId,
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
          String threadOwnerId,
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
        threadOwnerId: threadOwnerId ?? this.threadOwnerId,
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
  final String threadOwnerId;
  final String receiverId;
  final bool starred;
  final bool unread;
  final bool archived;
  final String subject;
  final DateTime updateTime;
  final String preview;
  final String contentsId;

  factory SupportThreadInfo.fromJson(Map<String, dynamic> json) {
    return SupportThreadInfo(
        id: json['id'],
        project: json['project'],
        threadOwnerId: json['threadOwnerId'],
        receiverId: json['receiverId'],
        subject: json['subject'],
        preview: json['preview'],
        updateTime: DateTime.fromMicrosecondsSinceEpoch(json['updateTime']),
        starred: json['starred'],
        unread: json['unread'],
        archived: json['archived'],
        contentsId: json['contentsId']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'project': project,
        'threadOwnerId': threadOwnerId,
        'receiverId': receiverId,
        'starred': starred,
        'unread': unread,
        'archived': archived,
        'subject': subject,
        'updateTime': updateTime.microsecondsSinceEpoch,
        'preview': preview,
        'contentsId': contentsId
      };
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

  factory SupportThreadContents.fromJson(Map<String, dynamic> jsonMap) {
    Iterable l = jsonMap['messages'];

    return SupportThreadContents(
        id: jsonMap['id'],
        messages: List<SupportMessage>.from(
            l.map((model) => SupportMessage.fromJson(model))));
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'messages': messages.map((model) => model.toJson())};
}

class SupportMessage {
  SupportMessage({this.authorId, this.contents, this.time, this.read});

  SupportMessage.clone(SupportMessage message)
      : this(
            authorId: message.authorId,
            contents: message.contents,
            time: message.time,
            read: message.read);

  final String authorId;
  final String contents;
  final DateTime time;
  final bool read;

  factory SupportMessage.fromJson(Map<String, dynamic> json) {
    return SupportMessage(
      authorId: json['authorId'],
      contents: json['contents'],
      time: DateTime.fromMicrosecondsSinceEpoch(json['time']),
      read: json['read']
    );
  }

  Map<String, dynamic> toJson() => {
        'authorId': authorId,
        'contents': contents,
        'time': time.microsecondsSinceEpoch,
        'read': read
      };
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

  factory SupportThread.fromJson(Map<String, dynamic> json) {
    return SupportThread(
        info: SupportThreadInfo.fromJson(json['info']),
        contents: SupportThreadContents.fromJson(json['contents']));
  }

  Map<String, dynamic> toJson() =>
      {'info': info.toJson(), 'contents': contents.toJson()};
}

class Filter {
  final FilterText contents;
  final FilterToggle starred;
  final FilterToggle unread;
  final FilterToggle archived;

  Filter({this.contents, this.starred, this.unread, this.archived});

  Filter.deactivated()
      : contents = FilterText.deactivated(),
        starred = FilterToggle.deactivated(),
        unread = FilterToggle.deactivated(),
        archived = FilterToggle.deactivated();

  Filter copy(
          {FilterText contents,
          FilterToggle starred,
          FilterToggle unread,
          FilterToggle archived}) =>
      Filter(
          contents: contents ?? this.contents,
          starred: starred ?? this.starred,
          unread: unread ?? this.unread,
          archived: archived ?? this.archived);

  factory Filter.fromJson(Map<String, dynamic> json) {
    return Filter(
        contents: FilterText.fromJson(json['contents']),
        starred: FilterToggle.fromJson(json['starred']),
        unread: FilterToggle.fromJson(json['unread']),
        archived: FilterToggle.fromJson(json['archived']));
  }

  Map<String, dynamic> toJson() => {
        'contents': contents.toJson(),
        'starred': starred.toJson(),
        'unread': unread.toJson(),
        'archived': archived.toJson()
      };
}

class FilterToggle {
  final bool value;
  final bool activated;

  FilterToggle(this.value, this.activated);

  FilterToggle.activated(bool newValue)
      : value = newValue,
        activated = true;

  FilterToggle.deactivated()
      : value = false,
        activated = false;

  FilterToggle next() {
    if (!activated)
      return FilterToggle(value, !activated);
    else if (!value)
      return FilterToggle(!value, activated);
    else
      return FilterToggle.deactivated();
  }

  factory FilterToggle.fromJson(Map<String, dynamic> json) {
    return FilterToggle(json['value'], json['activated']);
  }

  Map<String, dynamic> toJson() => {'value': value, 'activated': activated};
}

class FilterText {
  final String value;

  FilterText(this.value);

  FilterText.activated(String newValue) : value = newValue;

  FilterText.deactivated() : value = "";

  factory FilterText.fromJson(Map<String, dynamic> json) {
    return FilterText(json['value']);
  }

  Map<String, dynamic> toJson() => {'value': value};
}

class PageTarget {
  final int pageStart;
  final int pageSize;

  PageTarget({this.pageStart, this.pageSize});

  factory PageTarget.fromJson(Map<String, dynamic> json) {
    return PageTarget(pageStart: json['pageStart'], pageSize: json['pageSize']);
  }

  Map<String, dynamic> toJson() =>
      {'pageStart': pageStart, 'pageSize': pageSize};
}
