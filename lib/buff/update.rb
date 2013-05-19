module Buff
  class Client
    module Update
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
        response = get("/profiles/#{id}/updates/#{status.to_s}.json", options )
        updates = response['updates'].map { |r| Buff::Update.new(r) }
        Buff::Updates.new (
              { total: response['total'], updates: updates } )
      end

      def interactions_by_update_id(id, options={})
        optional_params = [:page, :count, :event]
        response = get("/updates/#{id}/interactions.json", options)
        interactions = response['interactions'].map { |r| Buff::Interaction.new(r) }
        Buff::Interactions.new(
          { total: response['total'], interactions: interactions }
        )
      end

      def reorder_updates(profile_id, options={})
        # order, optional: offset, utc
        order = options.fetch(:order) { raise ArgumentError }
        response = post("/profiles/#{profile_id}/updates/reorder.json", options)
      end

      def shuffle_updates(profile_id, options={})
        # optional count, utc
        response = post("/profiles/#{profile_id}/updates/shuffle.json", options)
      end

        #TODO
      def create_update(options={})

        # POST Data
        #     text=This%20is%20an%20example%20update&
        #     profile_ids[]=4eb854340acb04e870000010&
        #     profile_ids[]=4eb9276e0acb04bb81000067&
        #     media[link]=http%3A%2F%2Fgoogle.com&
        #     media[description]=The%20google%20homepage
        # options = {
        #   text: "bodytext",
        #   profile_ids: ["230958239058", "23059u2350923"],
        #   media: {
        #     link: "http://example.com",
        #     description: "That example page"
        #   }
        # }
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
