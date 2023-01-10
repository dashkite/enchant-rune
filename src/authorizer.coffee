import { getSecret } from "@dashkite/dolores/secrets"
import * as Runes from "@dashkite/runes"
import { register } from "@dashkite/enchant/authorizers"

import { Messages } from "@dashkite/messages"
import messages from "./messages"

message = do ( _messages = null ) ->
  _messages = Messages.create()
  _messages.add messages
  ( code, context ) -> _messages.message code, context

secret = undefined

# TODO allow for multiple candidates

register "rune", ({ parameters, credential }, { request }) ->
  { nonce } = parameters
  secret ?= await getSecret "guardian"
  console.log "enchant: verifying", credential, nonce
  if Runes.verify { rune: credential, nonce, secret }
    console.log "enchant: verification succeeded"
    [ authorization ] = Runes.decode credential
    console.log "enchant: matching against request"
    if ( await Runes.match { request, authorization })
      console.log "enchant: match succeeded"
      valid: true
    else
      console.log "enchant: match failed"
      valid: false
      reason: message "request disallowed", { request }
  else
    console.log "enchant: verification failed"
    valid: false
    reason: message "verification failed", { request }
