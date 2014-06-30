require 'test_helper'
require 'lotus/commands/server'

describe Lotus::Commands::Server do
  let(:opts) { Hash.new }

  before do
    @server = Lotus::Commands::Server.new(opts)
  end

  describe '#options' do
    let(:opts) { { port: "3005", host: 'example.com' } }

    it 'sets the options correctly for rack' do
      @server.options[:Port].must_equal "3005"
      @server.options[:Host].must_equal "example.com"
    end

    it 'merges in default values' do
      @server.options[:environment].must_equal "development"
      @server.options[:config].must_equal "config.ru"
    end
  end

  describe '#middleware' do
    it 'does not mount ShowExceptions in deployment' do
      @server.middleware["deployment"]
        .include?(::Rack::ShowExceptions).must_equal false
    end

    it 'does mount ShowExceptions in development' do
      @server.middleware["development"]
        .include?(::Rack::ShowExceptions).must_equal true
    end

    it 'mounts ContentLength middleware' do
      @server.middleware.each do |env, middleware|
        middleware.include?(::Rack::ContentLength).must_equal true
      end
    end
  end
end
