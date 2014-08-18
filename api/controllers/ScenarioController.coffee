module.exports = {
   hi: (req, res) ->
    Scenario.create({data: {'key': 'value 2'}}).exec (err, scenario) ->
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

       scenarioCollection.mapReduce(map, reduce, output)
       res.end('Reduced successfully')
     
   simulate: (req, res) ->
     Races.native (err, raceCollection) ->
       map = () ->
         if this.data.market_runners[0].status == 'WINNER'
           val = {ret: parseFloat(this.data.market_runners[0].actual_sp)}
           if isNaN(val.ret)
              print("Found it = " + this.data.market_runners[0].actual_sp)
              print("Found it = " + this.data.id)
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

       output = {out: 'racesMapReduce'}
       raceCollection.mapReduce(map, reduce, output)
       res.end('Reduced successfully')
     
}
