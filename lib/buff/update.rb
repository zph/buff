module Buff
  class Client
    module Update
      def update_by_id(id, options={})
        check_id(id)
        response = get("/updates/#{id}.json")
        Buff::Update.new(response)
      end

      def updates_by_profile_id(id, options={})
        status = options.fetch(:status) do
          raise Buff::MissingStatus, "Include :pending or :sent in args"
        end
        options.delete(:status)
        response = get("/profiles/#{id}/updates/#{status.to_s}.json", options )
        updates = response['updates'].map { |r| Buff::Update.new(r) }
        Buff::Updates.new (
              { total: response['total'], updates: updates } )
      end

      def interactions_by_update_id(id, options={})
        response = get("/updates/#{id}/interactions.json", options)
        interactions = response['interactions'].map { |r| Buff::Interaction.new(r) }
        Buff::Interactions.new(
          { total: response['total'], interactions: interactions }
        )
      end

      def reorder_updates(profile_id, options={})
        options.fetch(:order) { raise ArgumentError }
        post("/profiles/#{profile_id}/updates/reorder.json", body: options)
      end

      def shuffle_updates(profile_id, options={})
        response = post("/profiles/#{profile_id}/updates/shuffle.json", body: options)
      end

      def create_update(options={})
        response = post("/updates/create.json", options)
        Hashie::Mash.new(JSON.parse response.body)
      end

      def modify_update_text(update_id, options={})
        # text, (now, media, utc)
        options.fetch(:text) { raise ArgumentError }
        response = post("/updates/#{update_id}/update.json", options)
        Hashie::Mash.new(JSON.parse response.body)
      end

      def share_update(update_id, options={})
        response = post("/updates/#{update_id}/share.json", options)
      end

      def destroy_update(update_id, options={})
        response = post("/updates/#{update_id}/destroy.json", options)
      end

      def check_id(id)
        raise Buff::InvalidIdLength unless id.length == 24
        raise Buff::InvalidIdContent unless id[/^[a-f0-9]+$/i]
      end
    end
  end
end
