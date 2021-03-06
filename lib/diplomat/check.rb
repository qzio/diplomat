require 'base64'
require 'faraday'

module Diplomat
  class Check < Diplomat::RestClient

    # Get registered checks
    # @return [OpenStruct] all data associated with the service
    def checks
      ret = @conn.get "/v1/agent/checks"
      return JSON.parse(ret.body)
    end

    # Register a check
    # @param check_id [String] the unique id of the check
    # @param name [String] the name
    # @param notes [String] notes about the check
    # @param script [String] command to be run for check
    # @param interval [String] frequency (with units) of the check execution
    # @param ttl [String] time (with units) to mark a check down
    # @return [Integer] Status code
    def register_script check_id, name, notes, script, interval
      json = JSON.generate(
      {
        "ID" => check_id,
        "Name" => name,
        "Notes" => notes,
        "Script" => script,
        "Interval" => interval
      }
      )

      ret = @conn.put do |req|
        req.url "/v1/agent/check/register"
        req.body = json
      end
      
      return true if ret.status == 200
    end

    def register_ttl check_id, name, notes, ttl
      json = JSON.generate(
      {
        "ID" => check_id,
        "Name" => name,
        "Notes" => notes,
        "TTL" => ttl,
      }
      )

      ret = @conn.put do |req|
        req.url "/v1/agent/check/register"
        req.body = json
      end
      
      return true if ret.status == 200
    end

    # Deregister a check
    # @param check_id [String] the unique id of the check
    # @return [Integer] Status code
    def deregister check_id
      ret = @conn.get "/v1/agent/check/deregister/#{check_id}"
      return true if ret.status == 200
    end

    # Pass a check
    # @param check_id [String] the unique id of the check
    # @return [Integer] Status code
    def pass check_id
      ret = @conn.get "/v1/agent/check/pass/#{check_id}"
      return true if ret.status == 200
    end

    # Warn a check
    # @param check_id [String] the unique id of the check
    # @return [Integer] Status code
    def warn check_id
      ret = @conn.get "/v1/agent/check/warn/#{check_id}"
      return true if ret.status == 200
    end

    # Warn a check
    # @param check_id [String] the unique id of the check
    # @return [Integer] Status code
    def fail check_id
      ret = @conn.get "/v1/agent/check/fail/#{check_id}"
      return true if ret.status == 200
    end

    # @note This is sugar, see (#checks)
    def self.checks
      Diplomat::Check.new.checks
    end

    # @note This is sugar, see (#register_script)
    def self.register_script *args
      Diplomat::Check.new.register_script *args
    end

    # @note This is sugar, see (#register_ttl)
    def self.register_ttl *args
      Diplomat::Check.new.register_ttl *args
    end

    # @note This is sugar, see (#deregister)
    def self.deregister *args
      Diplomat::Check.new.deregister *args
    end

    # @note This is sugar, see (#pass)
    def self.pass *args
      Diplomat::Check.new.pass *args
    end

    # @note This is sugar, see (#warn)
    def self.warn *args
      Diplomat::Check.new.warn *args
    end

    # @note This is sugar, see (#fail)
    def self.fail *args
      Diplomat::Check.new.fail *args
    end

  end
end
