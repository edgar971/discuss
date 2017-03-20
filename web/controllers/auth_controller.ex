defmodule Discuss.AuthController do 
    use Discuss.Web, :controller
    plug Ueberauth

    def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
        
        user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "github"}
        changeset = Discuss.User.changeset(%Discuss.User{}, user_params)
        sigin(conn, changeset)
    end

    def signout(conn, _params) do 
        conn
        |> configure_session(drop: true) # This way is more secure
        |> redirect(to: topic_path(conn, :index))
    end

    defp sigin(conn, changeset) do 
        case insert_or_update_user(changeset) do 
            {:ok, user} -> 
                conn
                |> put_flash(:info, "Welcome Back")
                |> put_session(:user_id, user.id)
                |> redirect(to: topic_path(conn, :index))

            {:error, _reason} ->
                conn
                |> put_flash(:error, "Error Signin In")
                |> redirect(to: topic_path(conn, :index))
        end
    end
    defp insert_or_update_user(changeset) do 
        case Repo.get_by(Discuss.User, email: changeset.changes.email) do
            nil -> Repo.insert(changeset)
            user -> {:ok, user}
        end
    end
end