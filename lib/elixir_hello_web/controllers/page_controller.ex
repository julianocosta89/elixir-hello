defmodule ElixirHelloWeb.PageController do
  use ElixirHelloWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
