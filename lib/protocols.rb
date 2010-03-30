module Protocols
  def Protocols.json opts
    { 'status' => nil,
      'message' => nil,
      'data' => nil
    }.merge(opts).to_json
  end

  def Protocols.json_ok opts={}
    json opts.merge({ 'status' => 200 })
  end

  def Protocols.json_oops opts={}
    json opts.merge({ 'status' => 400 })
  end
end
