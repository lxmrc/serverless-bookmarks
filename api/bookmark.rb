Handler = Proc.new do |req, res|
  res.status = 200
  res['Content-Type'] = 'text/html; charset=utf-8'
  url = req.query["url"]
  res.body = url
end
