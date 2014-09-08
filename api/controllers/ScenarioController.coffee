module.exports =
   simulate: (req, res) ->
     @query = {}
     @query.exchange_id = req.param('exchange_id') if req.param('exchange_id')
     @query.market_type = req.param('market_type')if req.param('market_type')

     #res.badRequest('Position, Stake and Side is mandatory') unless req.param('stake') and req.param('side') and req.param('position')

     Race.native (err, raceCollection) =>
       mapFunction = () ->
         Mapper = () -> 
           map: (record) ->
            for scenario in scenarios
             for position in @positions(scenario, record.market_runners.length)
               @profitLoss(scenario, record._id, record.market_runners[position])
          
           positions: (scenario, size) ->
              switch(scenario.positions)
                when 'ALL' then [0..(size - 1)]
                when 'TOP 1/2' then [0..(Math.round(size * 0.5) - 1)]
                when 'BOTTOM 1/2' then [Math.round(size * 0.5)..size-1]
                when 'TOP 1/3' then [0..(Math.round(size * 0.33) - 1)]
                when 'BOTTOM 1/3' then [Math.round(size * 0.66)..(size - 1)]
                else scenario.positions

            profitLoss: (scenario, market_id, market_runner) ->
               if market_runner and !isNaN(market_runner.actual_sp)
                 price = parseFloat(market_runner.actual_sp)
                 if scenario.side == 'BACK'
                   amt = if market_runner.status == 'WINNER' then (price * scenario.stake) - scenario.stake else -scenario.stake
                 else if  scenario.side == 'LAY'
                   amt = if market_runner.status == 'WINNER' then -((price * scenario.stake) - scenario.stake) else scenario.stake
                 else #LAY (SP)
                   amt = if market_runner.status == 'WINNER' then -scenario.stake else (scenario.stake / price)
                 if amt > 0
                   emit(market_id, {ret: amt * ((100 - commission)/100)})
                 else if amt < 0
                   emit(market_id, {ret: amt})
                 amt
         new Mapper().map(this)
       
       reduce = (key, values) ->
          reducedVal = {ret:  0}
          vals = []
          for val in values
             vals.push val.ret
             reducedVal.ret += Math.round(val.ret * 100) / 100
          #print("Key " + key + "  Actual value " + vals)
          #print("Reduced value " + reducedVal.ret)
          reducedVal

       options = {
                   #out: 'racesMapReduce',
                   out: {inline: 1},
                   query: {exchange_id: 2, market_type: 'WIN', status: 'CLOSED'},
                   verbose: true,
                   scope: {commission: 5, scenarios: [
                             {side: req.param('side'), stake: req.param('stake'), positions: 'TOP 1/2'},
                             {side: 'BACK', stake: req.param('stake'), positions: 'BOTTOM 1/2'}
                           ]}

       }

       raceCollection.mapReduce(
               mapFunction,
               reduce,
               options,
               (err, collection, stats) ->
                 res.json({'response': collection, 'stats': stats}))
