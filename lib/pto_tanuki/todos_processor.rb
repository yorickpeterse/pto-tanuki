# frozen_string_literal: true

module PtoTanuki
  class TodosProcessor
    def initialize(gitlab, group_names)
      @gitlab = gitlab
      @group_names = group_names
      @current_user = gitlab.user
    end

    def process
      schedule = Schedule.new(@gitlab)

      unless schedule.pto_status_set?
        warn("Status doesn't match pto-tanuki format")
      end

      if schedule.out_of_office?
        process_group_todos
      else
        warn('Not OOO today')
      end
    end

    def process_group_todos
      @gitlab.todos.auto_paginate do |todo|
        path = todo.project.path_with_namespace

        next unless @group_names.any? { |name| path.start_with?("#{name}/") }

        @gitlab.mark_todo_as_done(todo.id)
      end
    end
  end
end
