# frozen_string_literal: true

module PtoTanuki
  class Notifier
    TEMPLATE = <<~NOTE.strip
      @%<username>s

      I am out of office from %<start_date>s until %<end_date>s. Any mentions
      during this period will be ignored, and any todos will be marked as done
      automatically. Should you want me to review any merge requests or provide
      any feedback, I recommend that you ask one of my team members instead.

      <hr>

      :robot: This message was generated automatically using [PTO
      Tanuki](https://gitlab.com/yorickpeterse/pto-tanuki). Future mentions of
      my username will not lead to another notification such as this one, unless
      the list of already notified users gets lost somehow.
    NOTE


    def initialize(gitlab, schedule)
      @gitlab = gitlab
      @schedule = schedule
    end

    def notify(todo)
      method =
        if todo.target_type == 'MergeRequest'
          :create_merge_request_note
        elsif todo.target_type == 'Issue'
          :create_issue_note
        end

      return unless method

      @gitlab.public_send(
        method,
        todo.target.project_id,
        todo.target.iid,
        note_body(todo)
      )
    end

    def note_body(todo)
      TEMPLATE % {
        username: todo.author.username,
        start_date: @schedule.start_date.iso8601,
        end_date: @schedule.end_date.iso8601
      }
    end
  end
end
