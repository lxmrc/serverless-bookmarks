require 'rubygems'
require 'httparty'
require 'json'

class Editor
  include HTTParty
  debug_output $stdout

  attr_accessor :repo, :branch, :author

  base_uri 'https://api.github.com'
  basic_auth ENV['GITHUB_USERNAME'], ENV['GITHUB_TOKEN']
  default_params :output => 'json'
  format :json

  def initialize(repo, branch = 'master')
    @repo = repo
    @branch = branch
    @author = false
  end

  def set_author(name, email)
    @author = {'name' => name, 'email' => email}
  end

  def update_file(file, message, content)
    last_commit_sha = last_commit         # get last commit
    last_tree = tree_for(last_commit_sha) # get base tree
    content = get_file_contents(file) + "\n#{content}"
    tree_sha = create_tree(file, content, last_tree) # create new tree
    new_commit_sha = create_commit(message, tree_sha, last_commit_sha) # create new commit
    update_branch(new_commit_sha) # update reference
  end

  private

  def get_file_contents(file)
    response = Editor.get("/repos/#{@repo}/contents/#{file}")
    Base64.decode64(response["content"])
  end

  def last_commit
    Editor.get("/repos/#{@repo}/git/refs/heads/#{@branch}").parsed_response['object']['sha']
  end

  def tree_for(commit_sha)
    Editor.get("/repos/#{@repo}/git/commits/#{commit_sha}").parsed_response['tree']['sha']
  end

  def create_tree(file, content, last_tree)
    new_tree = {
      "base_tree" => last_tree,
      "tree" => [{"path" => file, "mode" => "100644", "type" => "blob", "content" => content}]
    }
    Editor.post("/repos/#{@repo}/git/trees", body: new_tree.to_json).parsed_response['sha']
  end

  def create_commit(message, tree_sha, parent)
    commit = { 'message' => message, 'parents' => [parent], 'tree' => tree_sha }
    if @author
      commit['author'] = @author
    end
    Editor.post("/repos/#{@repo}/git/commits", :body => commit.to_json).parsed_response['sha']
  end

  def update_branch(new)
    ref = {'sha' => new}
    post = Editor.post("/repos/#{@repo}/git/refs/heads/#{@branch}", :body => ref.to_json)
    post.headers['status'] == '200 OK'
  end
end

editor = Editor.new('lxmrc/lxmrc.com')

Handler = Proc.new do |req, res|
  title = req.query["title"]
  url = req.query["url"]
  yaml = <<~YAML
  - title: #{title}
    url: #{url}
  YAML
  editor.update_file('_data/bookmarks.yml', 'Add bookmark', "\n#{yaml}")
  res.status = 200
  res['Access-Control-Allow-Origin'] = '*'
end
