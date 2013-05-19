module Buff
  class Client
    module User
      def user_info(options={})
        Buff::UserInfo.new(get("/user.json"))
      end
    end
  end
end
