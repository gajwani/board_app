Board::UseCases::PresentStandupUseCase.add_standup_item_collector(
  -> (repo_factory:, standup_use_case:, team_id:, date: ) {
    standup_use_case.add_items(
      :interestings,
      repo_factory.interesting_repo.all_by_team_id_and_date(team_id, date)
    )
  }
)
