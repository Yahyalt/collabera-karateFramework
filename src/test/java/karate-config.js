function fn() {
  var Dotenv = Java.type('io.github.cdimascio.dotenv.Dotenv');
  var dotenv = Dotenv.load();

  var config = {
    baseUrl: dotenv.get('GOREST_BASE_URL'),
    token: dotenv.get('GOREST_TOKEN')
  };
karate.configure('logPrettyRequest', true);
karate.configure('logPrettyResponse', true);

  return config;

}