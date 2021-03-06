# see the detailed Configuration documentation at http://ddnexus.github.io/flex/doc/1-Global-Doc/3-Configuration.html

Flex::Configuration.configure do |config|

  # you must add your indexed model names here
  config.flex_models = %w[ Order ]

  # you must add your active model names here
  config.flex_active_models = %w[ Order ]

  # Add the your result extenders here
  config.result_extenders |= [ FlexSearchExtender ]
  
  config.variables[:index] = ["txn_order_development"]

  # Add the default variables here:
  # see also the details Variables documentation at http://ddnexus.github.io/flex/doc/2-flex/2-Templating/4-Variables.html
  # config.variables.deep_merge! :index    => 'my_index',
  #                              :type     => 'project',
  #                              :anything => 'anything

  # used by the live-reindex feature
  # if you change it you must deploy the change first, then you can live-reindex in any next deploy
  # read the documentation at http://ddnexus.github.io/flex/doc/2-flex/7-Live-Reindex.html#flexconfigurationapp_id
  config.app_id = '20140716141052_txn_' + Rails.env

  # used by the live-reindex feature
  # Uncomment and set the redis client only if you don't want to use the redis default client
  # config.redis = Redis.new(:host => somehost, :port: 6379, :db = 1)


  # Logger variables: see http://ddnexus.github.io/flex/doc/1-Global-Doc/3-Configuration.html
  # config.logger.debug_variables = false
  # config.logger.debug_request   = false
  # config.logger.debug_result    = false
  # config.logger.curl_format     = false

  # Custom config file path
  # config.config_file = '/custom/path/to/flex.yml',

  # Custom flex dir path
  # config.flex_dir = '/custom/path/to/flex',

  # The custom http_client you may want to implement
  # config.http_client = Your::Client.new

  # The custom url of your ElasticSearch server
  # config.http_client.base_uri = 'http://localhost:9200'

  # The options passed to the http_client. They are client specific.
  # config.http_client.options = {:timeout => 5}

  # Experimental: checks the response and returns a boolean (should raise?)
  # config.http_client.raise_proc = proc{|response| response.status >= 400}

end
