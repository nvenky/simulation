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
       #output = {out: 'racesMapReduce', query: @query}
    #   map = () ->
    #     for market_runner in @market_runners
    #       if !isNaN(market_runner.actual_sp)
    #         if req.param('side') == 'BACK' 
    #           if market_runner.status == 'WINNER'
    #             @amt = parseFloat(market_runner.actual_sp * req.stake('stake'))
    #           else
    #             @amt = -req.param('stake') 
    #         else
    #           if market_runner.status == 'WINNER'
    #             @amt = -req.param('stake')
    #           else
    #             @amt = req.param('stake') 
    #         emit('12345', {ret: @amt})

    #map = (stake, side, position) -> () ->
       map = () ->
               side = 'BACK' 
               stake = 5
               for market_runner in this.market_runners
                 if !isNaN(market_runner.actual_sp)
                   if side == 'BACK' 
                     if market_runner.status == 'WINNER'
                       @amt = parseFloat(market_runner.actual_sp * stake)
                     else
                       @amt = -stake 
                   else
                     if market_runner.status == 'WINNER'
                       @amt = -stake
                     else
                       @amt = stake
                   emit(this._id, {ret: @amt})
  

       reduce = (key, values) ->
          reducedVal = {ret:  0}
          vals = []
          for val in values
             vals.push val.ret
             reducedVal.ret += val.ret
          print("Actual value " + vals)
          print("Reduced value " + reducedVal.ret)
          reducedVal

       side = req.param('side') 
       position = req.param('position') 
       stake = req.param('stake') 

       raceCollection.mapReduce(
               map,
               reduce,
               #output,
               {out: 'racesMapReduce', query: {exchange_id: 2, market_type: 'WIN', status: 'CLOSED'}}
               (err, collection, stats) ->
                 #res.json({'data': collection})
                 res.send('Reduced successfully')
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


