defmodule PhoenixSlime do
  @doc """
  Provides the `~l` sigil with HTML safe Slime syntax inside source files.

  Raises on attempts to use `\#{}`. Use `~L` to allow templating with `\#{}`.

      iex> import PhoenixSlime
      iex> assigns = %{w: "world"}
      iex> ~l"\""
      ...> p = "hello " <> @w
      ...> "\""
      {:safe, ["<p>", "hello world", "</p>"]}
  """
  defmacro sigil_l(expr, opts) do
    handle_sigil(expr, opts, __CALLER__.line)
  end

  @doc """
  Provides the `~L` sigil for compiling Slime markup into `eex` or `heex` template code.

      iex> import PhoenixSlime
      iex> ~L"\""
      ...> p hello \#{"world"}
      ...> "\""
      {:safe, ["<p>hello ", "world", "</p>"]}
  """
  defmacro sigil_L(expr, opts) do
    handle_sigil(expr, opts, __CALLER__.line)
  end

  defp handle_sigil({:<<>>, _, [expr]}, [], line) do
    expr
    |> Slime.Renderer.precompile()
    |> EEx.compile_string(engine: Phoenix.HTML.Engine, line: line + 1)
  end

  defp handle_sigil(_, _, _) do
    raise ArgumentError,
          ~S(Templating is not allowed with #{} in ~l sigil.) <>
            ~S( Remove the #{}, use = to insert values, or ) <>
            ~S(use ~L to template with #{}.)
  end

  @doc ~S"""
  Outputs the given string as a validated heex template.

  Enables the use of Slime within components' `render/1` function.

      iex> import PhoenixSlime
      iex> assigns = %{world: "world"}
      iex> rendered = ~H[p hello #{@world}]
      %Phoenix.LiveView.Rendered{
        rendered |
        static: ["<p>hello ", "</p>"]
      }

  **Note:** this sigil collides with `phoenix_live_view`'s own `sigil_H`.
  You will likely need to change the expression within your app's `*Web.ex` file
  where `Phoenix.LiveView.Helpers` is imported, like so:

  ```diff
  - import Phoenix.LiveView.Helpers
  + import Phoenix.LiveView.Helpers, except: [sigil_H: 2]
  ```

  That same space is probably a fine spot to import this sigil, too, while you're at it,
  but it's your code, you do you. I gotta go.
  """
  defmacro sigil_H({:<<>>, _, [expr]}, _opts) do
    expr
     |> Slime.Renderer.precompile_heex()
     |> EEx.compile_string(
          engine: Phoenix.LiveView.HTMLEngine,
          line: __CALLER__.line + 1
        )
  end
end
