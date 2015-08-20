archive_events = -> (repo_factory:, whiteboard_id:, date:) do
  event_repo = repo_factory.event_repo

  event_repo.unarchived_by_whiteboard_id_on_or_before_date(whiteboard_id, date).each do |event|
    event.archive!
    event_repo.save(event)
  end
end

Board::UseCases::ArchiveStandupUseCase.add_archiver(archive_events)
