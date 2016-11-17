defmodule IdconexTest do
  use ExUnit.Case
  doctest Idconex

  test "rendering md5_3x3" do
    {:ok, image} = File.read "test/fixtures/identicon_md5_3x3.png"
    fix_image = Base.encode64 image

    Enum.each 1..2, fn(_) ->
      new_image = Idconex.render("identicon", :md5, 2) |> Idconex.encode64
      assert fix_image === new_image
    end
  end

  test "rendering md5_5x5" do
    {:ok, image} = File.read "test/fixtures/identicon_md5_5x5.png"
    fix_image = Base.encode64 image

    Enum.each 1..2, fn(_) ->
      new_image = Idconex.render("identicon", :md5, 3) |> Idconex.encode64
      assert fix_image === new_image
    end
  end

  test "rendering sha256_7x7" do
    {:ok, image} = File.read "test/fixtures/identicon_sha256_7x7.png"
    fix_image = Base.encode64 image

    Enum.each 1..2, fn(_) ->
      new_image = Idconex.render("identicon", :sha256, 4) |> Idconex.encode64
      assert fix_image === new_image
    end
  end

  test "rendering sha512_9x9" do
    {:ok, image} = File.read "test/fixtures/identicon_sha512_9x9.png"
    fix_image = Base.encode64 image

    Enum.each 1..2, fn(_) ->
      new_image = Idconex.render("identicon", :sha512, 5) |> Idconex.encode64
      assert fix_image === new_image
    end
  end

  test "saving png image" do
    path = "./test/tmp/"

    new_image = Idconex.render "identicon"
    encoded_image = Idconex.encode64 new_image
    Idconex.save new_image, path

    {:ok, image} = File.read "#{path}identicon_md5_5x5.png"
    loaded_image = Base.encode64 image

    assert encoded_image === loaded_image
  end
end
