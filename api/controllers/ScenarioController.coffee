module.exports =
   hi: (req, res) ->
    Scenario.create({data: {'key': 'value 3'}}).exec (err, scenario) ->
       console.log('Scenario created ' + scenario.id)
       Scenario.count().exec (err, result) ->
         res.send("Hi " + result)
    
   map: (req, res) ->
     Scenario.native (err, scenarioCollection) ->
       map = () ->
        emit this.data.key, 1
       
       reduce = (key, values) ->
          Array.sum(values)

       output = {out: 'scenarioMapReduce'}

       scenarioCollection.mapReduce(
                map,
                reduce,
                output,
                (err, collection, stats) ->
                  for record in collection
                    res.send record.value
                  res.end 'Reduced successfully'
       )
     
   simulate: (req, res) ->
     #query = {}
     #query['exchange_id'] = req.param('exchange_id') if req.param('exchange_id')
     #query['market_type'] = req.param('market_type')if req.param('market_type')

     Race.native (err, raceCollection) ->
       map = () ->
         if this.market_runners[0].status == 'WINNER'
           val = {ret: parseFloat(this.market_runners[0].actual_sp)}
           if isNaN(val.ret)
              print("Found it = " + this.market_runners[0].actual_sp)
              print("Found it = " + this.id)
           else
             emit('Summary', val)

       reduce = (key, values) ->
          reducedVal = {ret:  0 }
          vals = []
          for val in values
             vals.push val.ret
             reducedVal.ret += val.ret
          print("Actual value " + vals)
          print("Reduced value " + reducedVal.ret)
          reducedVal

       output = {out: 'racesMapReduce'}#, query: query}
       raceCollection.mapReduce(
               map,
               reduce,
               output,
               (err, collection, stats) ->
                 res.send('Collection' + collection)
                 res.end('Reduced successfully')
       )
