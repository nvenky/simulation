module.exports = {
   hi: function(req, res){
    race = Race.create({data: {name: 'Race 1'}})//.done(function(err, race){
//      res.end(JSON.stringify(race));
//    });
    res.send("Failure no idea" + race);
   }
}
