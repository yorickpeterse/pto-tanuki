# frozen_string_literal: true

module PtoTanuki
  class Schedule
    STATUS_PATTERN =
      /\AOOO from (?<start>\d+-\d+-\d+)\s+\w+\s+(?<stop>\d+-\d+-\d+)\z/.freeze

    DATE_FORMAT = '%Y-%m-%d'

    attr_reader :start_date, :end_date

    def initialize(gitlab)
      @gitlab = gitlab
      @start_date = nil
      @end_date = nil

      retrieve_status
    end

    def out_of_office?
      return false unless @start_date && @end_date

      (@start_date..@end_date).cover?(Date.today)
    end

    def retrieve_status
      status = @gitlab.get('/user/status')

      return unless status

      matches = status.message.match(STATUS_PATTERN)

      return unless matches[:start] && matches[:stop]

      @start_date = Date.strptime(matches[:start], DATE_FORMAT)
      @end_date = Date.strptime(matches[:stop], DATE_FORMAT)
    end
  end
end