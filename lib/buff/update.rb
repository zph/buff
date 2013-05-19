module Buff
  class Client
    module Update

      # Updates via Get
        # /updates/:id
        # /profiles/:id/updates/pending
        # /profiles/:id/updates/sent
        # /updates/:id/interactions
      #
      def update_by_id(id, options={})
        check_id(id)
        response = get("/updates/#{id}.json")
        Buff::Update.new(response)
      end


      def updates_by_profile_id(id, options={})
        optional_params = [ :page, :count, :since, :utc ]
        status = options.fetch(:status) do
          raise Buff::MissingStatus, "Include :pending or :sent in args"
        end
        options.delete(:status)
        response = get("/profiles/#{id}/updates/#{status.to_s}.json", {query: options} )
        updates = response['updates'].map { |r| Buff::Update.new(r) }
        Buff::Updates.new (
              { total: response['total'], updates: updates } )
      end

      def interactions_by_update_id(id, options={})
        optional_params = [:page, :count, :event]
        response = get("/updates/#{id}/interactions.json", {query: options})
        interactions = response['interactions'].map { |r| Buff::Interaction.new(r) }
        Buff::Interactions.new(
          { total: response['total'], interactions: interactions }
        )
      end

      # Updates via post
      #POST
        # /profiles/:id/updates/reorder
        # /profiles/:id/updates/shuffle
        # /updates/create
        # /updates/:id/update
        # /updates/:id/share
        # /updates/:id/destroy

      def reorder_updates(profile_id, options={})
        # order, optional: offset, utc
        order = options.fetch(:order) { raise ArgumentError }
        response = post("/profiles/#{profile_id}/updates/reorder.json")
      end

      def shuffle_updates(profile_id, options={})
        # optional count, utc
        response = post("/profiles/#{profile_id}/updates/shuffle.json", options)
      end

        #TODO
      def create_update(options={})
      end

      def share_update(update_id)
        response = post("/updates/#{update_id}/share.json")
      end

      def destroy_update(update_id)
        response = post("/updates/#{update_id}/destroy.json")
      end

      def check_id(id)
        raise Buff::InvalidIdLength unless id.length == 24
        raise Buff::InvalidIdContent unless id[/^[a-f0-9]+$/i]
      end
    end
  end
end
