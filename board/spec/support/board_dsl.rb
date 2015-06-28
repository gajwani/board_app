module BoardDSL
  include TestAttributes

  def event_repo
    @event_repo ||= repo_factory.event_repo
  end

  def new_face_repo
    @new_face_repo ||= repo_factory.new_face_repo
  end

  def help_repo
    @help_repo ||= repo_factory.help_repo
  end

  def interesting_repo
    @interesting_repo ||= repo_factory.interesting_repo
  end

  def whiteboard_repo
    @whiteboard_repo ||= repo_factory.whiteboard_repo
  end

  def repo_factory
    @repo_factory ||= FakeRepoFactory.new
  end

  def observer
    @observer ||= GuiSpy.new
  end

  def create_interesting(whiteboard:, date:)
    Board.create_interesting(
      observer: observer,
      attributes: valid_interesting_attributes.merge(date: date),
      interesting_repo: interesting_repo,
      whiteboard_id: whiteboard.id,
    ).execute

    observer.spy_created_interesting
  end

  def create_help(whiteboard:, date:)
    Board.create_help(
      observer: observer,
      attributes: valid_help_attributes.merge(date: date),
      help_repo: help_repo,
      whiteboard_id: whiteboard.id,
    ).execute

    observer.spy_created_help
  end

  def create_event(whiteboard:, date:)
    Board.create_event(
      observer: observer,
      attributes: valid_event_attributes.merge(date: date),
      event_repo: event_repo,
      whiteboard_id: whiteboard.id,
    ).execute

    observer.spy_created_event
  end

  def create_new_face(whiteboard:, date:)
    Board.create_new_face(
      observer: observer,
      attributes: valid_new_face_attributes.merge(date: date),
      new_face_repo: new_face_repo,
      whiteboard_id: whiteboard.id,
    ).execute

    observer.spy_created_new_face
  end

  def archive_standup(whiteboard_id, date)
    Board.archive_standup(
      observer: observer,
      repo_factory: repo_factory,
      whiteboard_id: whiteboard_id,
      date: date,
    ).execute
  end

  def create_whiteboard
    Board.create_whiteboard(
      observer: observer,
      attributes: valid_whiteboard_attributes,
      whiteboard_repo: whiteboard_repo,
    ).execute

    observer.spy_created_whiteboard
  end

  def present_standup(whiteboard:, date:)
    Board.present_standup(
      whiteboard_id: whiteboard.id,
      repo_factory: repo_factory,
      date: date,
      observer: observer,
    ).execute

    observer.spy_presented_standup
  end

  def present_whiteboard(whiteboard:)
    Board.present_whiteboard_items(
      whiteboard_id: whiteboard.id,
      repo_factory: repo_factory,
      observer: observer,
    ).execute

    observer.spy_presented_whiteboard_items
  end
end
