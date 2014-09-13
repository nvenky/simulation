module.exports.connections = {
  mongodbServer: {
    adapter: 'sails-mongo',
    // user: 'username',
    // password: 'password',
    url: process.env.MONGOHQ_URL || 'mongodb://localhost:27017/punters_bot'
    //database: 'punters_bot'
  }
};
