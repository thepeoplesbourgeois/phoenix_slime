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

  To use Slime within LiveComponents, where the result must be validated
  by `Phoenix.LiveView.HTMLEngine`, the expression may be tagged with
  the charlist `'heex'`, which will cause the Slime markup to compile
  to a `Phoenix.LiveView.Rendered` struct.

      iex> import PhoenixSlime
      iex> assigns = %{world: "world"}
      iex> rendered = ~L"\""
      ...> p hello \#{@world}
      ...> "\""heex
      %Phoenix.LiveView.Rendered{
        rendered |
        static: ["<p>hello ", "</p>"]
      }
  """
  defmacro sigil_L(expr, opts) do
    handle_sigil(expr, opts, __CALLER__.line)
  end

  defp handle_sigil({:<<>>, _, [expr]}, [], line) do
    expr
    |> Slime.Renderer.precompile()
    |> EEx.compile_string(engine: Phoenix.HTML.Engine, line: line + 1)
  end

  defp handle_sigil({:<<>>, _, [expr]}, 'heex', line) do
    expr
     |> Slime.Renderer.precompile_heex()
     |> EEx.compile_string(engine: Phoenix.LiveView.HTMLEngine, line: line + 1)
  end

  defp handle_sigil(_, _, _) do
    raise ArgumentError,
          ~S(Templating is not allowed with #{} in ~l sigil.) <>
            ~S( Remove the #{}, use = to insert values, or ) <>
            ~S(use ~L to template with #{}.)
  end

  # NOT A GREAT IDEA: conflicts with `Phoenix.LiveView.Helpers`'s own `sigil_H`
  # KEEPING IT HERE ANYWAY: in case the `heex` charlist tag above feels kludgey in the end

  # @doc ~S"""
  # Provides .heex compatibility with the `~L` sigil with HTML safe Slime syntax for components.

  # Enables using Slime to build live components

  #     iex> import PhoenixSlime
  #     iex> assigns = %{world: "world"}
  #     iex> rendered = ~H[p hello #{@world}]
  #     iex> rendered.static
  #     ["<p>hello ", "</p>"]
  # """
  # defmacro sigil_H(expr, _opts) do
  #   handle_sigil(expr, 'heex', __CALLER__.line)
  # end
end
