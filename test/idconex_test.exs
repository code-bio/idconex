defmodule IdconexTest do
  use ExUnit.Case
  doctest Idconex

  test "rendering md5_5x5, block_size: 5" do
    {:ok, image} = File.read "test/fixtures/identicon_md5_5x5_bs5.png"
    fix_image = Base.encode64 image

    Enum.each 1..2, fn(_) ->
      new_image = Idconex.render("identicon", block_size: 5) |> Idconex.encode64
      assert fix_image === new_image
    end
  end

  test "rendering md5_3x3" do
    {:ok, image} = File.read "test/fixtures/identicon_md5_3x3.png"
    fix_image = Base.encode64 image

    Enum.each 1..2, fn(_) ->
      new_image = Idconex.render("identicon", chunk_size: 2) |> Idconex.encode64
      assert fix_image === new_image
    end
  end

  test "rendering md5_5x5 (default)" do
    {:ok, image} = File.read "test/fixtures/identicon_md5_5x5.png"
    fix_image = Base.encode64 image

    Enum.each 1..2, fn(_) ->
      new_image = Idconex.render("identicon") |> Idconex.encode64
      assert fix_image === new_image
    end
  end

  test "rendering sha256_7x7" do
    {:ok, image} = File.read "test/fixtures/identicon_sha256_7x7.png"
    fix_image = Base.encode64 image

    Enum.each 1..2, fn(_) ->
      new_image = Idconex.render("identicon", alg: :sha256, chunk_size: 4) |> Idconex.encode64
      assert fix_image === new_image
    end
  end

  test "rendering sha512_9x9" do
    {:ok, image} = File.read "test/fixtures/identicon_sha512_9x9.png"
    fix_image = Base.encode64 image

    Enum.each 1..2, fn(_) ->
      new_image = Idconex.render("identicon", alg: :sha512, chunk_size: 5) |> Idconex.encode64
      assert fix_image === new_image
    end
  end

  test "saving png image" do
    path = "./test/tmp/identicon_md5_5x5.png"

    new_image = Idconex.render "identicon"
    encoded_image = Idconex.encode64 new_image
    Idconex.save new_image, path

    {:ok, image} = File.read path
    loaded_image = Base.encode64 image

    assert encoded_image === loaded_image
  end
end
