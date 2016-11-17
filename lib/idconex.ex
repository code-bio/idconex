defmodule Idconex do
  @moduledoc """
  Creates an identicon for a given username.

  Use `render/1` to create a usual github like identicon.
  Use `render/4` to create an extended identicon.

  Use `encode64/1` to get the identicon as a base64 encoded png image.
  Use `save/2` to save the identicon as a png image file.

  ## Examples

      iex> Idconex.render("codebio") |> Idconex.save("./test/tmp/codebio.png")
      :ok

      iex> Idconex.render("cfranzl", :md5, 3, 5) |> Idconex.encode64
      "iVBORw0KGgoAAAANSUhEUgAAABkAAAAZCAIAAABLixI0AAAAMklEQVR4nGP4Tz3AMGoWRWbxO5ejIeJlR80aPGZRAkaEWZjBSTYaNWsAzaJmmhgBZgEAXVVi4TlXmOgAAAAASUVORK5CYII="
  """

  defstruct [:name, :hashlist, :alg, :rgb, :grid, :chunk_size, :row_size, :block_size, :image_size, :image]

  @doc """
  Render a given username to an identicon.

  Provide the hash algorithm to create different kinds of identicons.
  Provide a chunk_size to change the number of columns (chunk_size*2-1 = number of rectangles per side).
  Provide a block_size to define the number of pixels per side of a rectangle.

  Typical types of identicons are:
  * `alg: :md5, chunk_size: 3`: Image of 250x250 pixel with 5x5 grid
  * `alg: :sha256, chunk_size: 4`: Image of 350x350 pixel with 7x7 grid
  * `alg: :sha512, chunk_size: 5`: Image of 450x450 pixel with 9x9 grid
  * `alg: :sha512, chunk_size: 5, block_size: 27`: Image of 243x243 pixel with 9x9 grid

  Parameter:
  * `name`: username
  * `alg`: md5 | sha | sha224 | sha256 | sha384 | sha512
  * `chunk_size`: number of rectangles for one side including the axis
  * `block_size`: side length of the rectangle in pixel (default: 50)

  Returns: `%Idconex{}`
  """
  def render(name, alg, chunk_size, block_size \\ 50) do
    name
    |> hashlist(alg)
    |> set_color
    |> set_size(chunk_size, block_size)
    |> build_grid
    |> build_image
  end

  @doc """
  Render a given username to an identicon.

  Using md5 hash algorithm and a chunk_size of 3. Use this to create
  usual github like identicon.

  Parameter:
  * `name`: username

  Returns: `%Idconex{}`
  """
  def render(name) do
    render(name, :md5, 3)
  end

  @doc """
  Save the identicon as png image.

  Provide only a path to create a file with the default name in the given path
  or include a complete new filename to override the default filename.

  Parameter:
  * `%Idconex{}`: rendered image struct
  * `path`: optional ; default: #name_#alg_#gridsize.png

  Returns: `:ok`
  """
  def save(%Idconex{name: name, image: image, row_size: row_size, alg: alg}, path \\ nil) do
    default_filename = "#{name}_#{alg}_#{row_size}x#{row_size}.png"

    filename =
      case path do
        nil -> default_filename
        _ -> path
      end

    if(String.ends_with?(filename, "/")) do
      filename = "#{filename}#{default_filename}"
    end

    File.write filename, image
  end

  @doc """
  Encode the identicon with base64.

  Parameter:
  * `%Idconex{}`: rendered image struct

  Returns: base64 encoded png image
  """
  def encode64(%Idconex{image: image}) do
    Base.encode64 image
  end

  defp hashlist(name, alg) do
    hashlist = :crypto.hash(alg, name) |> :binary.bin_to_list
    %Idconex{name: name, hashlist: hashlist, alg: alg}
  end

  defp set_color(%Idconex{hashlist: [r, g, b | _tail]} = idc) do
    %Idconex{idc | rgb: {r, g, b}}
  end

  defp set_size(idc, chunk_size, block_size) do
    row_size = chunk_size * 2 - 1
    %Idconex{idc | chunk_size: chunk_size, row_size: row_size, block_size: block_size, image_size: block_size * row_size}
  end

  defp build_grid(%Idconex{hashlist: hashlist, chunk_size: chunk_size} = idc) do
    grid =
      hashlist
      |> Enum.chunk(chunk_size)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index
      |> Enum.filter(fn({x, _index}) -> rem(x, 2) == 0 end)

    %Idconex{idc | grid: grid}
  end

  defp mirror_row(row) do
    [_axis | append] = Enum.reverse row
    row ++ append
  end

  defp build_image(%Idconex{grid: grid, rgb: rgb, row_size: row_size, block_size: block_size, image_size: image_size} = idc) do
    image = :egd.create(image_size, image_size)
    color = :egd.color(rgb)

    for {_point, index} <- grid do
      x = rem(index, row_size) * block_size
      y = div(index, row_size) * block_size
      :egd.filledRectangle(image, {x, y}, {x + block_size, y + block_size}, color)
    end

    %Idconex{idc | image: :egd.render(image)}
  end
end
