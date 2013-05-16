module Buff
  class Client
    module Profile
      # Profile API Calls
      def profiles(options={})
        response = get("/profiles.json")
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
      def set_schedules(id, options={})
        schedules = options.fetch(:schedules) { raise ArgumentError }
        #process schedules object
        # permit it to be hash or Buff::Schedules
        # TODO left off here 20130515 10pm

        response = post("/profiles/#{id}/schedules/update.json")
        Buff::Response.new(response)
      end

    end
  end

end
