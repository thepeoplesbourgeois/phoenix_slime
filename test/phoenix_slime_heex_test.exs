defmodule PhoenixSlimeHeexTest do
  use ExUnit.Case
  alias Phoenix.View
  doctest PhoenixSlime

  defmodule MyApp.PageView do
    use Phoenix.View, root: "test/fixtures/templates"

    use Phoenix.HTML
  end

  test "compiles & renders a sheex template with no dynamics" do
    result = View.render(MyApp.PageView, "new_heex_static.html", [])

    assert result.__struct__ == Phoenix.LiveView.Rendered
    assert result.static == ["<h2 name=\"value\">inner html</h2>"]
  end

  test "properly escapes dynamic attributes" do
    rendered =
      View.render(MyApp.PageView, "new_heex_attribute.html", dynamic_attribute: "success")

    assert rendered.__struct__ == Phoenix.LiveView.Rendered
    iodata = Phoenix.HTML.Safe.to_iodata(rendered)
    html = IO.chardata_to_string(iodata)

    assert html == "<h2 name=\"success\">inner html</h2>"
  end

  test "properly escapes node bodies" do
    rendered = View.render(MyApp.PageView, "new_heex_body.html", [])

    assert rendered.__struct__ == Phoenix.LiveView.Rendered

    html = rendered
    |> Phoenix.HTML.Safe.to_iodata()
    |> IO.chardata_to_string()

    assert html == "<h2 name=\"value\">eex expression</h2>"
  end
end
