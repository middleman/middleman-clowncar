require "middleman-core"
require "middleman-clowncar/version"
  
::Middleman::Extensions.register(:clowncar) do
  require "middleman-clowncar/extension"
  ::Middleman::ClownCarExtension
end
