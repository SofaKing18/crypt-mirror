defmodule RocketCryptWeb.CryptControllerTest do
  use RocketCryptWeb.ConnCase

  alias RocketCrypt.Rates

  setup %{conn: conn} do
    Rates.create_crypt(%{symbol: "BTC", usd: 124.50})
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "calculate" do
    test "to_usd - existing crypt", %{conn: conn} do
      conn = get(conn, calculator_path(conn, :to_usd), %{quantity: 2, crypt: "BTC"})
      assert "249.0" == json_response(conn, 200)["usd"]
    end

    test "to_usd - unexisting crypt", %{conn: conn} do
      conn = get(conn, calculator_path(conn, :to_usd), %{quantity: 1234, crypt: "BTM"})
      assert "0.0" == json_response(conn, 200)["usd"]
    end

    test "to_usd - negative qantity", %{conn: conn} do
      conn = get(conn, calculator_path(conn, :to_usd), %{quantity: -2, crypt: "BTC"})
      assert "-249.0" == json_response(conn, 200)["usd"]
    end
  end
end
