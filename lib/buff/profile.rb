module Buff
  class Client
    module Profile
      def profiles
        response = get("/profiles.json")
        response.map { |profile| Buff::Profile.new(profile) }
      end

      def profile_by_id(id)
        response = get("/profiles/#{id}.json")
        Buff::Profile.new(response)
      end

      def schedules_by_profile_id(id)
        response = get("/profiles/#{id}/schedules.json")
        response.map { |a_response| Buff::Schedule.new(a_response) }
      end

      def set_schedules(id, options)
        schedules = Buff::Encode.encode(
                        options.fetch(:schedules) { raise ArgumentError })
        post("/profiles/#{id}/schedules/update.json",
                        body: { schedules: schedules })
      end
    end
  end
end
