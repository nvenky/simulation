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
                    res.send 'Reduced successfully'
       )
     
   simulate: (req, res) ->
     @query = {}
     @query.exchange_id = req.param('exchange_id') if req.param('exchange_id')
     @query.market_type = req.param('market_type')if req.param('market_type')

     res.badRequest('Position, Stake and Side is mandatory') unless req.param('stake') and req.param('side') and req.param('position')

     Race.native (err, raceCollection) =>
       mapFunction = () ->
         Mapper = () -> {
           map: (record) ->
            for scenario in scenarios
             for position in @positions(scenario, record.market_runners.length)
               #print('Position '+ position)
               market_runner = record.market_runners[position]
               if market_runner and !isNaN(market_runner.actual_sp)
                 if scenario.side == 'BACK'
                   @amt = if market_runner.status == 'WINNER' then parseFloat(market_runner.actual_sp * scenario.stake) - scenario.stake else -scenario.stake
                 else
                   @amt = if market_runner.status == 'WINNER' then -(parseFloat(market_runner.actual_sp * scenario.stake) - scenario.stake) else scenario.stake
                 emit(record._id, {ret: parseFloat(@amt)})
          
           positions: (scenario, size) ->
              switch(scenario.positions)
                when 'ALL' then [0..(size - 1)]
                when 'TOP 1/2' then [0..(Math.round(size * 0.5) - 1)]
                when 'BOTTOM 1/2' then [Math.round(size * 0.5)..size-1]
                when 'TOP 1/3' then [0..(Math.round(size * 0.33) - 1)]
                when 'BOTTOM 1/3' then [Math.round(size * 0.66)..(size - 1)]
                else scenario.positions

         }
         new Mapper().map(this)
       
       reduce = (key, values) ->
          reducedVal = {ret:  0}
          vals = []
          for val in values
             vals.push val.ret
             reducedVal.ret += val.ret
          print("Key " + key + "  Actual value " + vals)
          #print("Reduced value " + reducedVal.ret)
          reducedVal

       options = {
                   #out: 'racesMapReduce',
                   out: {inline: 1},
                   query: {exchange_id: 2, market_type: 'WIN', status: 'CLOSED'},
                   verbose: true,
                   scope: {scenarios: [
                             {side: req.param('side'), stake: req.param('stake'), positions: 'TOP 1/2'},
                             {side: 'BACK', stake: req.param('stake'), positions: 'BOTTOM 1/2'}
                   ]}

       }

       raceCollection.mapReduce(
               mapFunction,
               reduce,
               options,
               (err, collection, stats) ->
                 res.json({'response': collection, 'stats': stats})
       )
    
   mapper: (req) ->
      @side = req.param('side') 
      @position = req.param('position') 
      @stake = req.param('stake') 
      () =>
         for market_runner in @market_runners
           if !isNaN(market_runner.actual_sp)
             if @side == 'BACK' 
               if market_runner.status == 'WINNER'
                 @amt = parseFloat(market_runner.actual_sp * @stake)
               else
                 @amt = -@stake 
             else
               if market_runner.status == 'WINNER'
                 @amt = -@stake
               else
                 @amt = @stake
             emit('12345', {ret: @amt})


