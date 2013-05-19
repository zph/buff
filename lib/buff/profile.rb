module Buff
  class Client
    module Profile
      # Profile API Calls
      def profiles(options={})
        response = get("/profiles.json", options)
        response.map { |profile| Buff::Profile.new(profile) }
      end

      def profile_by_id(id, options={})
        response = get("/profiles/#{id}.json")
        Buff::Profile.new(response)
      end

      def profile_schedules_by_id(id, options={})
        response = get("/profiles/#{id}/schedules.json")
        response.map { |r| Buff::Schedule.new(r) }
      end

      # Requires :schedules to be set
      # currently wipes out schedule on site
      # TODO massive bug
      # currently deletes schedule due to malformed request
      def set_schedules(id, options={})
        # schedules = options.fetch(:schedules) { raise ArgumentError }
        # options = { schedules: schedules }
        response = faraday_post("/profiles/#{id}/schedules/update.json", options )
          Buff::Response.new(JSON.parse(response.body))
      end

    end
  end

end
