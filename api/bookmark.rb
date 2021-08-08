Handler = Proc.new do |req, res|
  res.status = 200
  res['Content-Type'] = 'text/html; charset=utf-8'
  res['Access-Control-Allow-Origin'] = '*'
  url = req.query["url"]
  res.body = req.header["Origin"]
end
