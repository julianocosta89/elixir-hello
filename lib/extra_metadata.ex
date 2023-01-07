defmodule ExtraMetadata do

  @behaviour :otel_resource_detector

  def get_resource(_) do
    lines =
      case File.read("extrametadata.properties") do
        {:ok, contents} ->
          String.split(contents, "\n")
        {:error, _reason} ->
          []
      end

    filePath =
      case File.read("hiddenpath.properties") do
        {:ok, contents} ->
          String.split(contents, "\n")
        {:error, _reason} ->
          []
      end

    lines2 =
      case File.read(filePath) do
        {:ok, contents} ->
          String.split(contents, "\n")
        {:error, _reason} ->
          []
      end

    attributes = get_attributes(lines)
    attributes2 = get_attributes(lines2)

    resource1 = :otel_resource.create(attributes)
    resource2 = :otel_resource.create(attributes2)
    :otel_resource.merge(resource1, resource2)
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
