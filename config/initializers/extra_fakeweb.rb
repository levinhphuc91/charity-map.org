module FakeWeb
  class Registry
    def unregister_uri(method, uri)
      uri_map[normalize_uri(uri)][method] = {}
    end
  end

  def self.unregister_uri(*args)
    case args.length
    when 2
      Registry.instance.unregister_uri(*args)
    else
      raise ArgumentError.new("wrong number of arguments (#{args.length} for 2)")
    end
  end
end