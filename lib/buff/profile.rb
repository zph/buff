module Buff
  class Client
    module Profile
      def profiles
        response = get("/profiles.json" )
        response.map { |profile| Buff::Profile.new(profile) }
      end

      def profile_by_id(id)
        response = get("/profiles/#{id}.json")
        Buff::Profile.new(response)
      end

      def profile_schedules_by_id(id)
        response = get("/profiles/#{id}/schedules.json")
        response.map { |response| Buff::Schedule.new(response) }
      end

      def set_schedules(id, options)
        schedules = Buff::Encode.encode(options.fetch(:schedules) { raise ArgumentError })
        response = post("/profiles/#{id}/schedules/update.json", body: {schedules: schedules} )
        Buff::Response.new(JSON.parse(response.body))
      end
    end
  end
end
