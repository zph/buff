module Buff
  class Client
    module User

      def user_info(options={})
        response = get("/user.json")
        Buff::UserInfo.new(response)
      end
    end
  end
end
