defmodule Tableau.Document do
  defmodule Helper do
    defmacro render(inner_content, extra_assigns \\ Macro.escape(%{})) do
      quote do
        case unquote(inner_content) do
          [module | rest] ->
            module.template(
              Map.merge(Map.new(unquote(extra_assigns)), %{
                site: Access.fetch!(var!(assigns), :site),
                inner_content: rest
              })
            )

          [] ->
            nil
        end
      end
    end
  end

  def render(graph, module, assigns) do
    [root | mods] =
      graph
      |> Graph.dijkstra(module, :root)
      |> Enum.reverse()
      |> tl()

    root.template(Map.merge(assigns, %{inner_content: mods}))
  end
end