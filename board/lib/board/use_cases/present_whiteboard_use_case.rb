require "board/values/whiteboard"

module Board
  module UseCases
    class PresentWhiteboardUseCase
      class << self
        def collectors
          @collector ||= []
        end

        def add_collector(collector)
          collectors << collector
        end
      end

      def initialize(team_id:, observer:, repo_factory:)
        @repo_factory = repo_factory
        @observer = observer
        @team_id = team_id
        @items = {}
      end
      
      def add_items(item_name, items)
        @items[item_name] = items
      end

      def execute
        self.class.collectors.each do |collector|
          collector.call(repo_factory: @repo_factory, team_id: @team_id, whiteboard_items: self)
        end

        @observer.whiteboard_presented(Board::Values::Whiteboard.new(@items))
      end
    end
  end
end


Dir[File.join(__dir__, "whiteboard_item_collectors", "**", "*.rb")].each do |collector|
  require collector
end
