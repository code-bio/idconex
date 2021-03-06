# idconex
Elixir identicon library

Creates an identicon for a given username.

Use `render/2` without options to create a usual github like identicon.  
Use `render/2` with options to create an extended identicon.

Use `encode64/1` to get the identicon as a base64 encoded png image.  
Use `save/2` to save the identicon as a png image file.
  
  
#### Examples
Create a github like 5x5 identicon for the username "codebio" and save the 250x250 pixel image as a png-file.
```elixir
Idconex.render("codebio") |> Idconex.save("./test/tmp/codebio.png")
```  

Create a 9x9 identicon and return the 225x225 pixel png image as a base64 string
```elixir
Idconex.render("cfranzl", alg: :sha512, chunk_size: 5, block_size: 25) |> Idconex.encode64
```  
