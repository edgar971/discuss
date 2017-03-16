defmodule Discuss.AuthController do 
    use Discuss.Web, :controller
    plug Ueberauth

    def callback(conn, params) do
        
        # IO.log(conn)
        # user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "github"}


    end
end