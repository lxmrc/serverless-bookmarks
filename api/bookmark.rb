require_relative 'api/editor' 

editor = Editor.new('lxmrc/serverless-bookmarks')

Handler = Proc.new do |req, res|
  url = req.query["url"]
  editor.update_file('test.md', 'Update test.md', "\n#{url}")
  res.status = 200
  res['Access-Control-Allow-Origin'] = '*'
end
