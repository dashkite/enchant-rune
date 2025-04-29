import api from "./api"
import handlers from "./handlers"

# mock fetch that just runs locally
globalThis.Sky =
  fetch: ( request ) ->
    { resource } = request
    if resource.name == "description"
        content: api
    else if ( response = handlers[ resource.name ] )?
      response
    else
      throw new Error "oops that's not a pretend resource!"
