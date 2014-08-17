module.exports = {
   hi: (req, res) ->
    Race.create({data: {'key': 'value 2'}}).exec (err, race) ->
       console.log('Race created ' + race.id)
       Race.count().exec (err, result) ->
         res.send("Hi " + result)
    
   map: (req, res) ->
     Race.native (err, raceCollection) ->
       map = () ->
        emit this.data.key, 1
       
       reduce = (key, values) ->
          Array.sum(values)

       output = {out: 'raceMapReduce'}

       raceCollection.mapReduce(map, reduce, output)
       res.end('Reduced successfully')
     
     
}
