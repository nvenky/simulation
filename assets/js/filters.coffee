angular.module 'PuntersBotApp.filters', []
  .filter 'interpolate', ['version', (version) ->
     (text) ->
        String(text).replace(/\%VERSION\%/mg, version)
   ]
