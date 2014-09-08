HomeController = 
	index: (req,res) -> 
		res.view({
			description: 'This is a SailsJS / AngularJS Application'
		})

module.exports = HomeController
