defmodule ExtraMetadata do

  @behaviour :otel_resource_detector

  def get_resource(_) do
    lines = read_file("extrametadata.properties") |> unwrap_lines
    file_path = read_file("hiddenpath.properties") |> unwrap_lines
    lines2 = read_file(file_path) |> unwrap_lines
    attributes = get_attributes(Enum.concat(lines, lines2))
    :otel_resource.create(attributes)
  end

  defp unwrap_lines({:ok, lines}), do: lines
  defp unwrap_lines({:error, _}), do: []

  defp read_file(file_name) do
    try do
      {:ok, String.split(File.read!(file_name), "\n")}
    rescue
      File.Error ->
        {:error, "File does not exist, safe to continue"}
    end
  end

  defp get_attributes(lines) do
    # Transform each string into a tuple
    Enum.map(lines, fn(line) ->
      if String.length(line) > 0 do
        [key, value] = String.split(line, "=")
        {key, value}
      else
        {:error, "Empty string"}
      end
    end)
  end
end
