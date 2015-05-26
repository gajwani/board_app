class TeamsController < ApplicationController
  def new

  end

  def show
    Board.present_team(
      observer: self,
      team_id: params[:id],
      team_repo: team_repo,
    ).execute

    Board.present_standup(
      observer: self,
      team_id: params[:id],
      repo_factory: repo_factory,
      date: Date.today,
    ).execute
  end

  def create
    Board.create_team(
      observer: self,
      attributes: params[:team].symbolize_keys,
      team_repo: team_repo,
    ).execute
  end

  def team_created(team)
    redirect_to team_path(team.id)
  end

  def team_presented(team)
    @team = team
  end

  def standup_presented(standup)
    @standup = standup
  end
end
